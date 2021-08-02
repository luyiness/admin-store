package store.admin.service.localstore;


import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import sinomall.global.common.response.BaseResponse;
import store.admin.utils.StoreInfoUtil;
import store.api.dto.localstore.StoreFreightRuleDto;
import store.api.localstore.StoreFreightRuleApi;
import store.api.localstore.StoreFreightRuleRestApi;

import java.util.List;

/**
 * @author: taofeng
 * @create: 2019-12-04
 **/
@Slf4j
@Component
public class FreightRuleService {

    @Autowired
    StoreFreightRuleRestApi storeFreightRuleApi;

    public BaseResponse eidtFreightRule(List<StoreFreightRuleDto> storeFreightRuleDtos) {
        String storeId = StoreInfoUtil.getStoreId();
        storeFreightRuleDtos.stream().forEach(dto -> dto.setStoreId(storeId));
        return storeFreightRuleApi.save(storeFreightRuleDtos);
    }

    public BaseResponse delSpecialRule(List<StoreFreightRuleDto> storeFreightRuleDtos) {
        String storeId = StoreInfoUtil.getStoreId();
        storeFreightRuleDtos.stream().forEach(dto -> dto.setStoreId(storeId));
        return storeFreightRuleApi.delete(storeFreightRuleDtos);
    }

}
