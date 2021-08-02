package store.admin.config;

import org.apache.shiro.authc.credential.HashedCredentialsMatcher;
import org.apache.shiro.mgt.DefaultSecurityManager;
import org.apache.shiro.realm.Realm;
import org.apache.shiro.spring.web.ShiroFilterFactoryBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.DependsOn;
import spring.boot.shiro.autoconfig.ShiroProperties;
import spring.boot.shiro.service.AccountService;
import store.admin.service.AdminService;
import store.admin.service.shiro.ShiroDbRealm;

/**
 * Created by xiaoqian on 2016/10/13.
 */
@Configuration
public class ShiroConfig {

    @Bean
    AdminService adminService() {
        AdminService adminService = new AdminService();
        return adminService;
    }

    @Bean
    ShiroDbRealm shiroDbRealm(AccountService accountService) {
        ShiroDbRealm shiroDbRealm = new ShiroDbRealm();
        shiroDbRealm.setAdminService(adminService());
        HashedCredentialsMatcher hashedCredentialsMatcher = new HashedCredentialsMatcher("SHA-1");
        hashedCredentialsMatcher.setHashIterations(AccountService.HASH_INTERATIONS);
        shiroDbRealm.setCredentialsMatcher(hashedCredentialsMatcher);
        return shiroDbRealm;
    }

    @Autowired
    private ShiroProperties properties;

    @Bean(name = "shiroFilter")
    @DependsOn("securityManager")
    public ShiroFilterFactoryBean getShiroFilterFactoryBean(DefaultSecurityManager securityManager, Realm realm) {
        securityManager.setRealm(realm);

        ShiroFilterFactoryBean shiroFilter = new ShiroFilterFactoryBean();
        shiroFilter.setSecurityManager(securityManager);
        shiroFilter.setLoginUrl(properties.getLoginUrl());
        shiroFilter.setSuccessUrl(properties.getSuccessUrl());
        shiroFilter.setUnauthorizedUrl(properties.getUnauthorizedUrl());
        //todo 把adminresurce 表的配置回到chaindefinitionMap中
        shiroFilter.setFilterChainDefinitionMap(properties.getFilterChainDefinitionsMap());

        return shiroFilter;
    }
}
