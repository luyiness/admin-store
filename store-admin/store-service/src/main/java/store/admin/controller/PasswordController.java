package store.admin.controller;


import member.api.CoreUserApi;
import member.api.CoreUserRestApi;
import member.api.dto.core.CoreUserDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import store.admin.service.AdminAccountService;
import utils.GlobalContants;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by ChenGeng on 2016/12/23.
 */

@RequestMapping("/password")
@Controller
public class PasswordController {

    @Autowired
    private AdminAccountService adminAccountService;

    @Autowired
    CoreUserRestApi coreUserApi;

    @RequestMapping(value = {""}, method = RequestMethod.GET)
    public String index(Map model){
        return "password/edit";
    }

    @RequestMapping("/update")
    @ResponseBody
    public Map update(String oldPassword, String newPassword, HttpServletRequest request){
        Map<String,String> map = new HashMap<String,String>();
        HttpSession session = request.getSession();
        CoreUserDto coreUser = (CoreUserDto) session.getAttribute("user");
        String password = adminAccountService.entryptPassword(oldPassword,coreUser.getSalt());
        if(password.equals(coreUser.getPassword())){
            coreUser.setOld_password(coreUser.getPassword());
            String newPassword2 = adminAccountService.entryptPassword(newPassword,coreUser.getSalt());
            coreUser.setPassword(newPassword2);
            coreUserApi.saveCoreUser(coreUser);
            session.setAttribute("user",coreUser);
            map.put(GlobalContants.ResponseString.STATUS,GlobalContants.ResponseStatus.SUCCESS);
        }else{
            map.put(GlobalContants.ResponseString.STATUS,GlobalContants.ResponseStatus.ERROR);
            map.put(GlobalContants.ResponseString.MESSAGE,"旧密码输入有误，请重新输入。");
        }

        return map;
    }

}
