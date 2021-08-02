package store.admin.service;

import admin.model.AdminMenu;
import admin.model.repository.AdminMenuRepos;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * Created by xiaoqian on 2016/10/17.
 */
@Component
public class AdminMenuService {
    @Autowired
    AdminMenuRepos adminMenuRepos;

//    @Autowired
//    AdminMenuApi adminMenuApi;

    public List<AdminMenu> getTopAdminMenus(){
        //return adminMenuApi.findAllByParent(null);
        return adminMenuRepos.findAllByParent(null);
    }

    public List<AdminMenu> getAllAdminMenus(){
        //return adminMenuApi.findByIsDelete(false);
        return adminMenuRepos.findByIsDelete(false);
    }

    public AdminMenu findOne(String id){
        //return adminMenuApi.findOne(id);
        return adminMenuRepos.findOne(id);
    }
}
