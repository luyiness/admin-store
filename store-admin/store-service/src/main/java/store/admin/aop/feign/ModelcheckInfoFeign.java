package store.admin.aop.feign;

import org.springframework.cloud.netflix.feign.FeignClient;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;
import java.util.Map;


@FeignClient(value="provider", name = "provider", fallbackFactory = ModelcheckInfoFeignFallback.class)
@RequestMapping("/modelcheckInfo")
public interface ModelcheckInfoFeign {

    @RequestMapping("/save")
    public void save(@RequestParam("className") String className, @RequestParam("methodName") String methodName, @RequestParam("inputStr") String inputStr, @RequestParam("jpaRetrunStr") String jpaRetrunStr, @RequestParam("jpaDoTime") long jpaDoTime);
    @RequestMapping("/get")
    public List<Map> get(@RequestParam("className") String className, @RequestParam("methodName") String methodName);
    @RequestMapping("/update")
    public void update(@RequestParam("mybitesRetrunStr") String mybitesRetrunStr, @RequestParam("mybitesDoTime") long mybitesDoTime, @RequestParam("id") String id);
}
