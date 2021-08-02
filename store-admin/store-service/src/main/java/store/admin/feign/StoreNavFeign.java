package store.admin.feign;

import aftersale.api.dto.aftersalemanage.AfterSaleManageDetailsResp;
import aftersale.api.dto.aftersalemanage.AfterSaleResp;
import aftersale.api.dto.aftersalemanage.req.ExportManageForStAReq;
import org.springframework.cloud.netflix.feign.FeignClient;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import sinomall.config.response.RestfulBaseResponse;
import store.admin.feign.fallback.AfterSaleFeignFallBack;
import store.admin.feign.fallback.StoreNavFeignFallBack;
import store.admin.vo.aftersale.req.AfterSaleManageForStAReq;
import store.admin.vo.aftersale.req.SupplierReceiveReq;
import store.admin.vo.aftersale.req.UpdateAfterSaleStatusCheckReq;
import store.admin.vo.aftersale.resp.AfterSaleExportForStAResp;
import store.admin.vo.aftersale.resp.AfterSaleManagerForStAResp;
import store.admin.vo.aftersale.resp.SupplierReceiveResp;
import store.model.core.Store;
import store.model.core.StoreNav;
import utils.sql.PageVo;

import java.util.List;

@FeignClient(value = "goods", fallbackFactory = StoreNavFeignFallBack.class)
public interface StoreNavFeign {

    /**
     * 根据serviceNo查看售后主表信息
     * @return
     */
    @RequestMapping(value = "/goods/storeNavFeign/findByStoreOrderBySortIndexAsc", method = RequestMethod.POST)
    List<StoreNav> findByStoreOrderBySortIndexAsc(@RequestBody Store store);


    @RequestMapping(value = "/goods/storeNavFeign/delete", method = RequestMethod.POST)
    void delete(@RequestParam(value = "id") String id);

    @RequestMapping(value = "/goods/storeNavFeign/findOne", method = RequestMethod.POST)
    StoreNav findOne(@RequestParam(value = "id") String id);

    /**
     * 根据storeId查看供应商的收货地址
     * @return
     */
    @RequestMapping(value = "/goods/storeNavFeign/save", method = RequestMethod.POST)
    void save(@RequestBody StoreNav storeNav);

    }
