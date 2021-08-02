package store.admin.service.shiro;

import admin.model.AdminMenu;
import admin.model.AdminRole;
import admin.model.AdminUser;
import com.google.common.base.Objects;
import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.codec.binary.Base64;
import org.apache.commons.lang3.BooleanUtils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.*;
import org.apache.shiro.authc.credential.HashedCredentialsMatcher;
import org.apache.shiro.authc.pam.UnsupportedTokenException;
import org.apache.shiro.authz.AuthorizationInfo;
import org.apache.shiro.authz.SimpleAuthorizationInfo;
import org.apache.shiro.realm.AuthorizingRealm;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.PrincipalCollection;
import org.apache.shiro.subject.Subject;
import org.apache.shiro.util.ByteSource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.BoundValueOperations;
import org.springframework.data.redis.core.RedisTemplate;
import spring.boot.shiro.service.AccountService;
import store.admin.service.AdminAccountService;
import store.admin.service.AdminService;
import utils.Lang;
import utils.data.CopyUtil;

import javax.annotation.PostConstruct;
import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Random;
import java.util.concurrent.TimeUnit;


/**
 * Created by xiaoqian on 2015/11/10.
 */
@Slf4j
public class ShiroDbRealm extends AuthorizingRealm {

    private static final Logger _logger = LoggerFactory.getLogger(AuthorizingRealm.class);

    //@Autowired
    private AdminService adminService;

    @Autowired
    private AccountService accountService;

    @Autowired
    private AdminAccountService adminAccountService;
    @Value("${admin.system.code}")
    private String adminSystemCode;
    /**
     * 是否启用校验码
     */
    protected boolean useCaptcha = false;

    @Autowired
    private RedisTemplate redisTemplate;


    /**
     * 授权查询回调函数, 进行鉴权但缓存中无用户的授权信息时调用.
     */
    @Override
    protected AuthorizationInfo doGetAuthorizationInfo(PrincipalCollection principals) {
        ShiroUser shiroUser = (ShiroUser) principals.getPrimaryPrincipal();
        AdminUser user = adminService.findUserByUsernameAndSystem(shiroUser.loginName, adminSystemCode);
        user = null;
        if (user == null || (user.getState() != null && "0".equals(user.getState()))) {
            SecurityUtils.getSubject().getSession().stop();
            throw new AuthenticationException("用户不存在，或者已经删除");
        }
        SimpleAuthorizationInfo info = new SimpleAuthorizationInfo();
        for (AdminRole userRole : user.getRoles()) {
            // 基于Role的权限信息
            info.addRole(userRole.getCode());
            // 基于Permission的权限信息
            List<String> perms = new ArrayList<String>();
            for (AdminMenu permission : userRole.getAdminMenus()) {
                perms.add(permission.getCode());
                if (permission.getUrl() != null) {
                    perms.add(permission.getUrl());
                }
            }
            info.addStringPermissions(perms);
        }
        return info;
    }

    /**
     * 认证回调函数,登录时调用.
     */
    @Override
    protected AuthenticationInfo doGetAuthenticationInfo(AuthenticationToken authcToken) throws AuthenticationException {
        UsernamePasswordToken token = (UsernamePasswordToken) authcToken;

        Subject currentUser = SecurityUtils.getSubject();
        Session session = currentUser.getSession();
        String loginIp = (String) session.getAttribute("loginIp");

        log.info("登录请求IP = {}, 账号 = {}", loginIp, token.getUsername());

        if (Lang.isEmpty(token.getUsername())) {
            throw new UnsupportedTokenException();
        } else if (Lang.isEmpty(token.getPassword())) {
            throw new CredentialsException();
        }

        String ipLockKey = getIpLockKey(loginIp);
        BoundValueOperations ipLockBoundValueOperations = redisTemplate.boundValueOps(ipLockKey);
        Integer ipErrorCount = (Integer) ipLockBoundValueOperations.get();
        if (ipErrorCount != null && ipErrorCount >= 10) {
            throw new ExcessiveAttemptsException();
        }

        String accountLockKey = getAccountLockKey(token.getUsername());
        BoundValueOperations accountLockBoundValueOperations = redisTemplate.boundValueOps(accountLockKey);
        Integer passwordErrorCount = (Integer) accountLockBoundValueOperations.get();
        if (passwordErrorCount != null && passwordErrorCount >= 3) {
            throw new LockedAccountException();
        }

        try {
            //修改使用其它方法登录可以在这处理
            AdminUser user = adminService.findUserByUsernameAndSystem(token.getUsername(), adminSystemCode);

            if (user != null && BooleanUtils.isNotTrue(user.getIsDelete())) {


                String ip = session.getHost();

                char[] pwdChar = token.getPassword();
                String password1 = String.valueOf(pwdChar);
                String loginPasswordKey = (String) session.getAttribute("loginPasswordKey");
                String desEncryptPassword = desEncrypt(password1, loginPasswordKey, loginPasswordKey);
                String password = adminAccountService.entryptPassword(desEncryptPassword, user.getSalt());

                token.setPassword(desEncryptPassword.toCharArray());

                if (Lang.isEmpty(user.getValidFlag()) || !user.getValidFlag()) {
                    throw new DisabledAccountException();
                } else if (!(password.equals(user.getPassword()))) {
                    throw new IncorrectCredentialsException();
                } else {
                    Date date = new Date();
                    AuthenticationInfo authenticationInfo = new SimpleAuthenticationInfo(new ShiroUser(user.getUsername(), user.getUsername()), user.getPassword(), ByteSource.Util.bytes(user.getSalt()), getName());

                    session.setAttribute("user", user);
                    AdminUser user1 = CopyUtil.map(user, AdminUser.class);
                    user1.setRoles(user.getRoles());
                    user1.setLastLoginIp(loginIp);
                    if (!Lang.isEmpty(user1.getLastUpdated())) {
                        user1.setLastLoginTime(date);
                    }
                    AdminUser user2 = adminService.saveBean2(user1);

                    redisTemplate.delete(ipLockKey);
                    redisTemplate.delete(accountLockKey);

                    return authenticationInfo;
                }
            } else {
                throw new UnknownAccountException();
            }
        } catch (UnknownAccountException | IncorrectCredentialsException e) {
            if (e instanceof IncorrectCredentialsException) {
                if (passwordErrorCount == null) {
                    passwordErrorCount = 0;
                }
                passwordErrorCount++;
                accountLockBoundValueOperations.set(passwordErrorCount, 1L, TimeUnit.DAYS);
                if (passwordErrorCount >= 3) {
                    throw new LockedAccountException();
                }
            }
            if (ipErrorCount == null) {
                ipErrorCount = 0;
            }
            ipErrorCount++;
            ipLockBoundValueOperations.set(ipErrorCount, 1L, TimeUnit.DAYS);
            if (ipErrorCount >= 10) {
                throw new ExcessiveAttemptsException();
            }
            throw e;
        }


    }

    @SneakyThrows
    private static String desEncrypt(String sSrc, String sKey, String IV) {
        byte[] raw = sKey.getBytes("ASCII");
        SecretKeySpec skeySpec = new SecretKeySpec(raw, "AES");
        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        IvParameterSpec iv = new IvParameterSpec(IV.getBytes());
        cipher.init(Cipher.DECRYPT_MODE, skeySpec, iv);
        byte[] encrypted1 = Base64.decodeBase64(sSrc);//先用bAES64解密
        try {
            byte[] original = cipher.doFinal(encrypted1);
            return new String(original);
        } catch (Exception e) {
            log.error("登录密码解密失败", e);
            return null;
        }
    }

    /**
     * 设定Password校验的Hash算法与迭代次数.
     */
    @PostConstruct
    public void initCredentialsMatcher() {
        HashedCredentialsMatcher matcher = new HashedCredentialsMatcher(AccountService.HASH_ALGORITHM);
        matcher.setHashIterations(AccountService.HASH_INTERATIONS);
        setCredentialsMatcher(matcher);
    }

    public void setAdminService(AdminService adminService) {
        this.adminService = adminService;
    }

    public void setAccountService(AccountService accountService) {
        this.accountService = accountService;
    }

    /**
     * 自定义Authentication对象，使得Subject除了携带用户的登录名外还可以携带更多信息.
     */
    public static class ShiroUser implements Serializable {
        private static final long serialVersionUID = -1373760761780840081L;
        public String loginName;
        public String name;

        public ShiroUser(String loginName, String name) {
            this.loginName = loginName;
            this.name = name;
        }

        public String getName() {
            return name;
        }

        /**
         * 本函数输出将作为默认的<shiro:principal/>输出.
         */
        @Override
        public String toString() {
            return loginName;
        }

        /**
         * 重载hashCode,只计算loginName;
         */
        @Override
        public int hashCode() {
            return Objects.hashCode(loginName);
        }

        /**
         * 重载equals,只计算loginName;
         */
        @Override
        public boolean equals(Object obj) {
            if (this == obj) {
                return true;
            }
            if (obj == null) {
                return false;
            }
            if (getClass() != obj.getClass()) {
                return false;
            }
            ShiroUser other = (ShiroUser) obj;
            if (loginName == null) {
                if (other.loginName != null) {
                    return false;
                }
            } else if (!loginName.equals(other.loginName)) {
                return false;
            }
            return true;
        }
    }

    public void setUseCaptcha(boolean useCaptcha) {
        this.useCaptcha = useCaptcha;
    }

    public static String getIpLockKey(String host) {
        return "store-admin-web:login:lock:ip:" + host;
    }

    public static String getAccountLockKey(String username) {
        return "store-admin-web:login:lock:account:" + username;
    }

    public static String getStringRandom(int length) {
        String val = "";
        Random random = new Random();
        // 参数length，表示生成几位随机数
        for (int i = 0; i < length; i++) {
            String charOrNum = random.nextInt(2) % 2 == 0 ? "char" : "num";
            // 输出字母还是数字
            if ("char".equalsIgnoreCase(charOrNum)) {
                // 输出是大写字母还是小写字母
                int temp = random.nextInt(2) % 2 == 0 ? 65 : 97;
                val += (char) (random.nextInt(26) + temp);
            } else if ("num".equalsIgnoreCase(charOrNum)) {
                val += String.valueOf(random.nextInt(10));
            }
        }
        return val;
    }


}