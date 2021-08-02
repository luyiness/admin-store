package store.admin.aop.feign;

import feign.hystrix.FallbackFactory;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;
import java.util.Map;

/**
 * @author: 陈然然 on 2020/4/27 21:14.
 * @description:
 * @version: 1.0
 */
@Slf4j
@Component
@RequestMapping("/fallback/bannerFeign")
public class ModelcheckInfoFeignFallback implements FallbackFactory<ModelcheckInfoFeign> {
    @Override
    public ModelcheckInfoFeign create(Throwable throwable) {
        return new ModelcheckInfoFeign(){
            @Override
            public void save(@RequestParam("className") String className, @RequestParam("methodName") String methodName, @RequestParam("inputStr") String inputStr, @RequestParam("jpaRetrunStr") String jpaRetrunStr, @RequestParam("jpaDoTime") long jpaDoTime){

            };
            @Override
            public List<Map> get(@RequestParam("className") String className, @RequestParam("methodName") String methodName){
                return null;
            };
            @Override
            public void update( @RequestParam("mybitesRetrunStr") String mybitesRetrunStr, @RequestParam("mybitesDoTime") long mybitesDoTime,@RequestParam("id") String id){

            };
        };
    }
}
