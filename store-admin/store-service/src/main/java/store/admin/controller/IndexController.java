package store.admin.controller;


import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import java.util.Map;

/**
 * Created by xiaoqian on 2016/10/12.
 */
@Controller
public class IndexController {

    @RequestMapping(value = {"","index.htm","index.html"},method = RequestMethod.GET)
    public String index(Map model){
        //if(true) throw new RuntimeException("sdfds");

        //payment.model.put("adminMenus",adminMenuService.getTopAdminMenus());
        return "index";
    }
}
