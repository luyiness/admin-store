package store.admin.service;

import org.apache.shiro.authc.AuthenticationToken;
import org.apache.shiro.subject.Subject;
import org.springframework.stereotype.Component;
import spring.boot.shiro.service.AccountService;
import utils.data.Encodes;
import utils.security.Digests;

import javax.servlet.http.HttpServletRequest;

/**
 * Created by xiaoqian on 2016/10/14.
 */
@Component
public class AdminAccountService implements AccountService {
    @Override
    public void saveLoginHis(AuthenticationToken token, Subject subject, HttpServletRequest request) {

    }

    /**
     * 设定安全的密码，生成随机的salt并经过1024次 sha-1 hash
     */
    public String entryptPassword(String password,String salt) {
        byte[] hashPassword = Digests.sha1(password.getBytes(), salt.getBytes(), HASH_INTERATIONS);
        return Encodes.encodeHex(hashPassword);
    }

}
