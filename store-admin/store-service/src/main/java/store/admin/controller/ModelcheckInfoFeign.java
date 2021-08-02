package store.admin.controller;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.lang.reflect.Method;
import java.util.List;
import java.util.Map;

import static utils.data.Jsons.toJson;

@RestController
@RequestMapping("/modelcheckInfo")
public class ModelcheckInfoFeign {
    @Autowired
    private store.admin.aop.feign.ModelcheckInfoFeign modelcheckInfoRepos;
    @Autowired
    private ApplicationContext applicationContext;

    @RequestMapping("/check")
    public void check(@RequestParam("className") String className, @RequestParam("methodName") String methodName)throws  Exception{
        List<Map> modelcheckInfos = modelcheckInfoRepos.get(className,methodName);
        for(int i=0;i<modelcheckInfos.size();i++){
            Map modelcheckInfo =modelcheckInfos.get(i);
            doMeath(modelcheckInfo);
        }
    };


    public void doMeath(Map modelcheckInfo) throws  Exception{
        Class clz = Class.forName(modelcheckInfo.get("className").toString());
        //
        Object obj = applicationContext.getBean(clz);
        String[] methodNames = modelcheckInfo.get("meathName").toString().split(",");
        Class[] parameterTypes = new Class[methodNames.length-1];
        JSONArray args = (JSONArray)JSON.parse(modelcheckInfo.get("inputStr").toString());
        Object[] argstemp = new Object[methodNames.length-1];
        for(int i=1;i<methodNames.length;i++){
            if(methodNames[i]!=null&&!"null".equals(methodNames[i])) {
                parameterTypes[i - 1] = Class.forName(methodNames[i]);
                argstemp[i - 1] = JSONObject.parseObject(toJson(args.get(i-1)),parameterTypes[i - 1]);
            }
        }
        //获取方法
        Method m = obj.getClass().getDeclaredMethod(methodNames[0], parameterTypes);
        m.setAccessible(true);
        //调用方法
        long time = System.currentTimeMillis();
        String  result = toJson(m.invoke(obj, argstemp));
        modelcheckInfoRepos.update(result,System.currentTimeMillis()-time,modelcheckInfo.get("id").toString());
    }
}
