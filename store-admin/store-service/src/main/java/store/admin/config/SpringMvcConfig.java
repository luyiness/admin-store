package store.admin.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.AutoConfigureOrder;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;
import store.admin.interceptor.CommonInterceptor;
import store.admin.interceptor.ServletInterceptor;

/**
 * Created by xiaoqian on 2016/10/12.
 */
@Configuration
public class SpringMvcConfig {


    @Configuration
    @AutoConfigureOrder()
    protected static class MvcConfigurerAdapter extends WebMvcConfigurerAdapter {

        @Autowired
        CommonInterceptor commonInterceptor;

        @Autowired
        ServletInterceptor servletInterceptor;

        @Override
        public void addInterceptors(InterceptorRegistry registry) {
            registry.addInterceptor(servletInterceptor).addPathPatterns("/**").excludePathPatterns("*.js", "*.css", "*.jpg", "*.png", "*.gif", "*.webp", "*.");
            registry.addWebRequestInterceptor(commonInterceptor).addPathPatterns("/**").excludePathPatterns("*.js", "*.css", "*.jpg", "*.png", "*.gif", "*.webp", "*.");
        }


    };

}
