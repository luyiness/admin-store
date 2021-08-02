package store.admin.aop;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Component;
import store.admin.aop.feign.ModelcheckInfoFeign;

import static utils.data.Jsons.toJson;

@ConditionalOnProperty("sinomall.aop.isopen")
//非生产环境使用
@Profile("!prod")
@Component
@Aspect
public class MethodAspect {
    private Logger logger = LoggerFactory.getLogger(MethodAspect.class);

    @Autowired
    private ModelcheckInfoFeign modelcheckInfoRepos;
    /**
     * 定义Pointcut，Pointcut的名称 就是simplePointcut，此方法不能有返回值，该方法只是一个标示
     */
    @Pointcut("(execution(* *..*Repos.*(..)) || execution(* *..*Repo.*(..))) && !execution(* org.springframework..*.*(..))")
    public void caltimes() {
    }

    @Around("caltimes()")
    public Object aroundLogCall(ProceedingJoinPoint jp) throws Throwable {
        String className = "";
        String methodName = "";
        String inputStr = "";
        long time = 0L;
        try {
            time = System.currentTimeMillis();
            className = jp.getSignature().getDeclaringTypeName();
            methodName = jp.getSignature().getName(); // 获得方法名
            Object[] args = jp.getArgs();
            inputStr =toJson(jp.getArgs());
            for(int i=0; i<args.length; i++) {
                if(args[i] != null) {
                    methodName = methodName +","+ args[i].getClass().toString().replace("class ","");
                }else {
                    methodName = methodName +","+ "null";
                }
            }
        } catch (Exception e) {
            logger.error("[AOP]监控类名称.方法名称为:{}.{},调用异常", className, methodName);
       } finally {
            Object proceed = jp.proceed();
            try {
                modelcheckInfoRepos.save(className,methodName,inputStr,toJson(proceed),System.currentTimeMillis() - time);
                logger.info("[AOP]监控类名称.方法名称为:{}.{},调用耗时:{}ms", className, methodName, System.currentTimeMillis() - time);
            } catch (Exception e){
                logger.info("[AOP]监控类名称.方法名称为:{}.{} 发生异常", className, methodName, e);
            }
            return proceed;
        }
    }

}