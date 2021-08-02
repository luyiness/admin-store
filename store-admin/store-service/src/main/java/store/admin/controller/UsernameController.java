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
import java.util.List;
import java.util.Map;

/**
 * Created by ChenGeng on 2016/12/23.
 */

@RequestMapping("/username")
@Controller
public class UsernameController {

    @Autowired
    private AdminAccountService adminAccountService;

    @Autowired
    CoreUserRestApi coreUserApi;

    @RequestMapping(value = {""}, method = RequestMethod.GET)
    public String index(Map model){
        return "username/edit";
    }

    @RequestMapping("/update")
    @ResponseBody
    public Map update(String newUsername, HttpServletRequest request){
        Map<String,String> map = new HashMap<String,String>();
        HttpSession session = request.getSession();
        CoreUserDto coreUser = (CoreUserDto) session.getAttribute("user");

        if(coreUser.getUsername().equals(newUsername)){
            map.put(GlobalContants.ResponseString.STATUS,GlobalContants.ResponseStatus.ERROR);
            map.put(GlobalContants.ResponseString.MESSAGE,"新旧用户名一致，无需修改。");
        }else{
            List<CoreUserDto> coreUserList = coreUserApi.findCoreUserByUsername(newUsername,false);
            if(coreUserList==null || coreUserList.size()==0){
                //新用户名不重复
                coreUser.setOld_username(coreUser.getUsername());
                coreUser.setUsername(newUsername);
                coreUserApi.saveCoreUser(coreUser);
                session.setAttribute("user",coreUser);
                map.put(GlobalContants.ResponseString.STATUS,GlobalContants.ResponseStatus.SUCCESS);
            }else{
                //已存在相同的用户名
                map.put(GlobalContants.ResponseString.STATUS,GlobalContants.ResponseStatus.ERROR);
                map.put(GlobalContants.ResponseString.MESSAGE,"已存在相同的用户名，请重新输入。");
            }
        }
        return map;
    }

}
