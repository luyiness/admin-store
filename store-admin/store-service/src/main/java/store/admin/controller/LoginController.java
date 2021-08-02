package store.admin.controller;

import org.apache.commons.lang3.BooleanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import store.admin.service.shiro.ShiroDbRealm;
import utils.string.StringUtils;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;

/**
 * Created by xiaoqian on 2016/10/13.
 */
@Controller
@RequestMapping("/login")
public class LoginController {

    @RequestMapping(value = {""},method = RequestMethod.GET)
    public String index() {
        return "login";
    }


    @RequestMapping(value = "", method = RequestMethod.POST)
    public String login() {
        System.out.println("+++++++++++++++++++++++++");
        return null;
    }

    @Autowired
    private RedisTemplate redisTemplate;

    @ResponseBody
    @GetMapping("accountLock")
    public Map<String, Integer> accountLock(Boolean remove, String username) {
        String allAccountLockKey = ShiroDbRealm.getAccountLockKey("*");
        Set<String> keys = redisTemplate.keys(allAccountLockKey);
        if (BooleanUtils.isTrue(remove) && StringUtils.isNotBlank(username)) {
            String accountLockKey = ShiroDbRealm.getAccountLockKey(username);
            if (keys.contains(accountLockKey)) {
                redisTemplate.delete(accountLockKey);
                keys.remove(accountLockKey);
            }
        }
        Map<String, Integer> map = new HashMap<>();
        for (String key : keys) {
            map.put(key.substring(key.lastIndexOf(":") + 1), (Integer) redisTemplate.boundValueOps(key).get());
        }
        return map;
    }

    @ResponseBody
    @GetMapping("ipLock")
    public Map<String, Integer> ipLock(Boolean remove, String ip) {
        String allIpLockKey = ShiroDbRealm.getIpLockKey("*");
        Set<String> keys = redisTemplate.keys(allIpLockKey);
        if (BooleanUtils.isTrue(remove) && StringUtils.isNotBlank(ip)) {
            String ipLockKey = ShiroDbRealm.getIpLockKey(ip);
            if (keys.contains(ipLockKey)) {
                redisTemplate.delete(ipLockKey);
                keys.remove(ipLockKey);
            }
        }
        Map<String, Integer> map = new HashMap<>();
        for (String key : keys) {
            map.put(key.substring(key.lastIndexOf(":") + 1), (Integer) redisTemplate.boundValueOps(key).get());
        }
        return map;
    }
}
