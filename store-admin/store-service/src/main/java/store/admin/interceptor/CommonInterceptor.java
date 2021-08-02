package store.admin.interceptor;


import admin.model.AdminMenu;
import admin.model.AdminRole;
import admin.model.AdminUser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.ui.ModelMap;
import org.springframework.web.context.request.RequestAttributes;
import org.springframework.web.context.request.WebRequest;
import org.springframework.web.context.request.WebRequestInterceptor;
import org.springframework.web.servlet.handler.DispatcherServletWebRequest;
import store.admin.service.AdminMenuService;
import store.admin.service.shiro.ShiroDbRealm;
import store.admin.utils.StoreInfoUtil;
import utils.Lang;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

/**
 * Created by xiaoqian on 2016/2/4.
 */
@Component
public class CommonInterceptor implements WebRequestInterceptor {

    @Autowired
    AdminMenuService adminMenuService;

    @Override
    public void preHandle(WebRequest request) throws Exception {
        if (request.getAttribute("loginPasswordKey", 3) == null) {
            request.setAttribute("loginPasswordKey", ShiroDbRealm.getStringRandom(16), 3);
        }
        if (request.getHeader("X-Requested-With") == null) {
            AdminUser user = (AdminUser) request.getAttribute(StoreInfoUtil.STORE_MANAGER, 3);
            List<AdminMenu> adminMenuList = new ArrayList<>();
            List<AdminMenu> adminMenuList2 = new ArrayList<>();
            if (!Lang.isEmpty(user)) {
                for (AdminRole userRole : user.getRoles()) {
                    for (AdminMenu permission : userRole.getAdminMenus()) {
                        if (!Lang.isEmpty(permission.getParentId())) {
                            permission.setActivStatus(false);
                            adminMenuList2.add(permission);
                        }
                    }
                    for (AdminMenu permission : userRole.getAdminMenus()){
                        List<AdminMenu> adminMenuList3 = new ArrayList<>();
                        if(!Lang.isEmpty(permission.getParentId())){
                            permission.setChilds(adminMenuList3);
                        }else {
                            for(AdminMenu am : adminMenuList2){
                                if(permission.getId().equals(am.getParentId())){
                                    adminMenuList3.add(am);
                                }
                            }
                            permission.setChilds(adminMenuList3);
                        }
                        permission.setActivStatus(false);
                        adminMenuList.add(permission);
                    }
                }
            }

            AdminMenu activeMenu = findActiveMenu(((DispatcherServletWebRequest) request).getRequest().getRequestURI(), adminMenuList);
            setActiveMenuFlag(activeMenu);

            /** 菜单排序 */
            sortMenu(adminMenuList);
            for(AdminMenu menu : adminMenuList) {
                if(!Lang.isEmpty(menu.getChilds())) {
                    sortMenu(menu.getChilds());
                }
            }

            request.setAttribute("adminMenus",adminMenuList , RequestAttributes.SCOPE_REQUEST);

        }
    }

    private void sortMenu(List<AdminMenu> menus) {
        Collections.sort(menus, new Comparator<AdminMenu>() {
            @Override
            public int compare(AdminMenu o1, AdminMenu o2) {
                if(o1.hasChild().equals(o2.hasChild())) { // 同级菜单，根据index排序
                    if(o1.getIndex() == null) {
                        return -1;
                    } else if(o2.getIndex() == null) {
                        return 1;
                    } else {
                        return o1.getIndex() == null && o2.getIndex() == null ? 0 : o1.getIndex().compareTo(o2.getIndex());
                    }
                } else {
                    return o1.hasChild() ? -1 : 1;
                }
            }
        });
    }

    AdminMenu findActiveMenu(String url,List<AdminMenu> menu){
        for (AdminMenu adminMenu : menu) {
//            if(url.indexOf(adminMenu.getUrl())>-1){
            if(url.equals(adminMenu.getUrl())){
                return adminMenu;
            }else{
                AdminMenu newMenu = findActiveMenu(url,adminMenu.getChilds());
                if(newMenu!=null){
                    return newMenu;
                }
            }
        }
        return null;
    }
    void setActiveMenuFlag(AdminMenu activeMenu){
        if(activeMenu!=null){
            activeMenu.setActivStatus(true);
            if(activeMenu.getParent()!=null){
                setActiveMenuFlag(activeMenu.getParent());
            }
        }
    }

    @Override
    public void postHandle(WebRequest request, ModelMap model) throws Exception {

    }

    @Override
    public void afterCompletion(WebRequest request, Exception ex) throws Exception {

    }
}