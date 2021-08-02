package store.admin;



import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.netflix.feign.EnableFeignClients;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.scheduling.annotation.EnableAsync;

/**
 * Created by xiaoqian on 2016/9/27.
 */
@SpringBootApplication()
@EnableAsync
@EnableFeignClients(basePackages = {"supplierapi.api","cms.api","store","utils","goods.api","provider","member.api","pool.api","shipping.api"})
@ComponentScan({"admin.model","utils.sql", "store.admin"})
public class StoreServiceApp {

    public static void main(String []args){
        SpringApplication.run(StoreServiceApp.class,args);


    }
}
