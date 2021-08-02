package store.admin.config;

import org.springframework.boot.autoconfigure.ImportAutoConfiguration;
import org.springframework.context.annotation.Configuration;
import sinomall.config.common.CommonRedisConfig;
import sinomall.config.common.RabbitMqConfig;
import sinomall.config.common.SequenceConfig;


import sinomall.config.common.ShutDownHookConfig;
import sinomall.config.web.ApolloConfig;
import sinomall.config.web.NewCorsFilterConfig;
import sinomall.config.web.WebFreeMarkerConfig;
import sinomall.config.web.WebSpringMvcConfig;


/**
 * @author torvalds on 2018/9/29 14:54.
 * @version 1.0
 */
@ImportAutoConfiguration({
        ApolloConfig.class,
        CommonRedisConfig.class,
        WebFreeMarkerConfig.class,
        WebSpringMvcConfig.class,
        ShutDownHookConfig.class,
        SequenceConfig.class,
        NewCorsFilterConfig.class,
        RabbitMqConfig.class,
})
@Configuration
public class AutoImportConfig {
}
