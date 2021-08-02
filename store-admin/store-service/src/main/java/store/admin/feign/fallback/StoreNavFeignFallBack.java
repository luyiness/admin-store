package store.admin.feign.fallback;


import aftersale.api.dto.aftersalemanage.AfterSaleManageDetailsResp;
import aftersale.api.dto.aftersalemanage.AfterSaleResp;
import aftersale.api.dto.aftersalemanage.req.ExportManageForStAReq;
import com.alibaba.fastjson.JSON;
import feign.hystrix.FallbackFactory;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import sinomall.config.response.RestfulBaseResponse;
import store.admin.feign.AfterSaleFeign;
import store.admin.feign.StoreNavFeign;
import store.admin.vo.aftersale.req.AfterSaleManageForStAReq;
import store.admin.vo.aftersale.req.SupplierReceiveReq;
import store.admin.vo.aftersale.req.UpdateAfterSaleStatusCheckReq;
import store.admin.vo.aftersale.resp.AfterSaleExportForStAResp;
import store.admin.vo.aftersale.resp.AfterSaleManagerForStAResp;
import store.admin.vo.aftersale.resp.SupplierReceiveResp;
import store.model.core.Store;
import store.model.core.StoreNav;
import utils.ExceptionCode;
import utils.sql.PageVo;

import java.util.List;


@Slf4j
@Component
@RequestMapping("fallback/storeNav")
public class StoreNavFeignFallBack implements FallbackFactory<StoreNavFeign> {

    @Override
    public StoreNavFeign create(Throwable throwable) {
        return new StoreNavFeign() {

            @Override
            public List<StoreNav> findByStoreOrderBySortIndexAsc(@RequestBody Store store){
                return null;
            };


            @Override
            public void delete(@RequestParam(value = "id") String id){
            };

            @Override
            public StoreNav findOne(@RequestParam(value = "id") String id){
                return null;
            };


            /**
             * 根据storeId查看供应商的收货地址
             * @return
             */
            @Override
            public void save(@RequestBody StoreNav storeNav){

            };
        };
    }
}
