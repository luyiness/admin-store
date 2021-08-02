package store.admin.service;

import admin.model.AdminRole;
import admin.model.AdminUser;
import admin.model.repository.AdminUserRepos;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Example;
import org.springframework.data.domain.ExampleMatcher;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Component;
import store.admin.vo.query.AdminUserQueryVo;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by xiaoqian on 2016/10/13.
 */
@Component
public class AdminService {

    @Autowired
    AdminUserRepos adminUserRepos;

//    @Autowired
//    AdminUserApi adminUserApi;

    public AdminUser findUserByUsername(String username) {
//        return adminUserApi.findByUsername(username);
        return adminUserRepos.findByUsername(username);
    }

    public Page<AdminUser> findPage(Pageable pageable) {
//        return adminUserApi.findByIsDelete(false, pageable);
        return adminUserRepos.findByIsDelete(false, pageable);
    }

    public void deleteDataById(String id) {
        //AdminUserDto adminUser=adminUserApi.findOne(id);
        /*AdminUser adminUser = adminUserRepos.findOne(id);
        adminUser.setIsDelete(true);
        //adminUserApi.save(adminUser);
        adminUserRepos.save(adminUser);*/
        adminUserRepos.delete(id);
    }

    public AdminUser findDataById(String id) {
//        AdminUserDto adminUser=adminUserApi.findOne(id);
        AdminUser adminUser = adminUserRepos.findOne(id);
        return adminUser;
    }

    public void saveBean(AdminUser adminUser) {
//        adminUserApi.save(adminUser);
        adminUserRepos.save(adminUser);
    }

    public AdminUser saveBean2(AdminUser adminUser) {
//        return adminUserApi.save(adminUser);
        return adminUserRepos.save(adminUser);
    }

    public Page<AdminUser> findPageByParams(String username, Boolean validFlag, Pageable pageable) {
        AdminUser adminUser = new AdminUser();
        adminUser.setUsername(username);
        adminUser.setValidFlag(validFlag);
        adminUser.setIsDelete(false);

//        ExampleMatcher matcher = ExampleMatcher.matching()
//                //.withIgnorePaths("roles")
//                .withIgnoreNullValues()
//                //.withNullHandler()
//                .withMatcher("username", ExampleMatcher.GenericPropertyMatcher.of(ExampleMatcher.StringMatcher.CONTAINING, true))
//                .withMatcher("validFlag", ExampleMatcher.GenericPropertyMatcher.of(ExampleMatcher.StringMatcher.CONTAINING, true));
//
//        Example<AdminUser> example = Example.of(adminUser, matcher);
//        return adminUserApi.findAll(example,pageable);
        return adminUserRepos.findAll(username,validFlag, pageable);
    }

    public Page<AdminUser> findPageByParams(AdminUserQueryVo adminUserQueryVo, Pageable pageable) {
        AdminUser adminUser = new AdminUser();
        adminUser.setUsername(adminUserQueryVo.getUsername());
        if (StringUtils.isNoneEmpty(adminUserQueryVo.getValidFlag())) {
            adminUser.setValidFlag(Boolean.valueOf(adminUserQueryVo.getValidFlag()));
        }
        if (StringUtils.isNoneEmpty(adminUserQueryVo.getSystemId())) {
            adminUser.setSystemId(adminUserQueryVo.getSystemId());
        }
        adminUser.setIsDelete(false);

//        ExampleMatcher matcher = ExampleMatcher.matching()
//                //.withIgnorePaths("roles")
//                .withIgnoreNullValues()
//                //.withNullHandler()
//                .withMatcher("username", ExampleMatcher.GenericPropertyMatcher.of(ExampleMatcher.StringMatcher.CONTAINING, true));
//
//        Example<AdminUser> example = Example.of(adminUser, matcher);
//        return adminUserApi.findAll(example,pageable);
        return adminUserRepos.findAll(adminUser.getUsername(), pageable);
    }

    /**
     * 找到所有角色为AdminRole，且未被删除的管理员账户
     */
    public List<AdminUser> findUserByAdminRole(AdminRole adminRole) {
        List<AdminRole> adminRoleList = new ArrayList<AdminRole>();
        adminRoleList.add(adminRole);
//        return adminUserApi.findByIsDeleteAndRoles(false,adminRoleList);
        return adminUserRepos.findByIsDeleteAndRoles(false, adminRoleList);
    }

    public Page<AdminUser> findByValidFlagAndIdNotIn(Boolean validFlag, Object[] ids, Pageable pageable) {
//        return adminUserApi.findByValidFlagAndIdNotIn(validFlag,ids,pageable);
        return adminUserRepos.findByValidFlagAndIdNotIn(validFlag, ids, pageable);
    }

    public AdminUser findUserByUsernameAndSystem(String loginName, String adminSystemCode) {
        return adminUserRepos.findByUsernameAndSystemCode(loginName, adminSystemCode);
    }
}
