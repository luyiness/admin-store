package store.admin.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;

/**
 * @author drury
 * @date 2019/6/27
 */
@Data
@ConfigurationProperties(prefix = "swagger2")
public class Swagger2Properties {
    /**
     * swagger2注解包扫描路径
     */
   private String basePackage;
    /**
     * 当前项目名称
     */
    private String title;
    /**
     * 项目描述
     */
    private  String description;
    /**
     * 版本号
     */
    private  String version;
}
