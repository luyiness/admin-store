package store.admin.stub;


import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.BoundValueOperations;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Component;
import shipping.api.LogisticsCompanyApi;
import shipping.api.LogisticsCompanyRestApi;
import shipping.api.dto.LogisticCompanyDto;
import utils.collection.CollectionUtil;

import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

/**
 * @author: taofeng
 * @create: 2019-11-04
 **/
@Slf4j
@Component
public class LogisticsCompanyApiStub {

    @Autowired
    LogisticsCompanyRestApi logisticsCompanyApi;

    @Autowired
    RedisTemplate redisTemplate;

    private String LOGISTICS_COMPANY_API_KEY = "store-admin-web:LOGISTICS_COMPANY_API_KEY";

    public Map<String, List<LogisticCompanyDto>> findUsAbleLogisticsCompanyNameKeyMap() {
        BoundValueOperations boundValueOperations = redisTemplate.boundValueOps(LOGISTICS_COMPANY_API_KEY);
        if (boundValueOperations != null && boundValueOperations.get() != null) {
            return (Map<String, List<LogisticCompanyDto>>) boundValueOperations.get();
        }
        log.info("LogisticsCompanyApiStub.findUsAbleLogisticsCompanyNameKeyMap没有走缓存");
        List<LogisticCompanyDto> usAbleLogisticsCompany = logisticsCompanyApi.findUsAbleLogisticsCompany();
        if (CollectionUtil.isEmpty(usAbleLogisticsCompany)) {
            return null;
        }
        Map<String, List<LogisticCompanyDto>> logisticCompanyNameMap = usAbleLogisticsCompany.stream()
                .collect(Collectors.groupingBy(LogisticCompanyDto::getName));
        boundValueOperations.set(logisticCompanyNameMap, 1, TimeUnit.DAYS);
        return logisticCompanyNameMap;
    }

}
