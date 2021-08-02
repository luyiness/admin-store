package store.admin.feign;

import aftersale.api.dto.aftersalemanage.AfterSaleManageDetailsResp;
import aftersale.api.dto.aftersalemanage.AfterSaleResp;
import aftersale.api.dto.aftersalemanage.req.ExportManageForStAReq;
import aftersale.api.dto.aftersalemanage.req.ExportManagerReq;
import aftersale.api.dto.aftersalemanage.req.ExportReq;
import org.springframework.cloud.netflix.feign.FeignClient;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import sinomall.config.response.RestfulBaseResponse;
import store.admin.feign.fallback.AfterSaleFeignFallBack;
import store.admin.vo.aftersale.req.AfterSaleManageForStAReq;
import store.admin.vo.aftersale.req.SupplierReceiveReq;
import store.admin.vo.aftersale.req.UpdateAfterSaleStatusCheckReq;
import store.admin.vo.aftersale.resp.AfterSaleExportForStAResp;
import store.admin.vo.aftersale.resp.AfterSaleManagerForStAResp;
import store.admin.vo.aftersale.resp.SupplierReceiveResp;
import utils.sql.PageVo;

import java.util.List;

@FeignClient(url = "${afterSale.server.url}", name = "AfterSaleFeign", fallbackFactory = AfterSaleFeignFallBack.class)
public interface AfterSaleFeign {

    /**
     * 根据条件分页查询相关信息
     * @param afterSaleManageForStAReq
     * @return
     */
    @RequestMapping(value = "/afterSaleForStA/findByConditionsForStA", method = RequestMethod.POST)
    RestfulBaseResponse<PageVo<AfterSaleManagerForStAResp>> findByConditionsForStA(@RequestBody AfterSaleManageForStAReq afterSaleManageForStAReq);

    /**
     * 根据serviceNo查看售后相关详情
     * @param serviceNo
     * @return
     */
    @RequestMapping(value = "/afterSaleForCad/findByServiceNo", method = RequestMethod.POST)
    RestfulBaseResponse<AfterSaleManageDetailsResp> findByServiceNo(@RequestParam(value = "serviceNo") String serviceNo);

    /**
     * 根据serviceNo查看售后主表信息
     * @param serviceNo
     * @return
     */
    @RequestMapping(value = "/afterSaleForStA/findByServiceNoForStA", method = RequestMethod.POST)
    RestfulBaseResponse<AfterSaleResp> findByServiceNoForStA(@RequestParam(value = "serviceNo") String serviceNo);


    @RequestMapping(value = "/afterSaleForStA/updateAfterSaleStatus", method = RequestMethod.POST)
    RestfulBaseResponse<Boolean> updateAfterSaleStatus(@RequestBody UpdateAfterSaleStatusCheckReq updateAfterSaleStatusCheckReq);

    @RequestMapping(value = "/afterSaleForStA/updateAfterSaleForReceive", method = RequestMethod.POST)
    RestfulBaseResponse<Boolean> updateAfterSaleForReceive(@RequestBody UpdateAfterSaleStatusCheckReq updateAfterSaleStatusCheckReq);

    /**
     * 根据storeId查看供应商的收货地址
     * @return
     */
    @RequestMapping(value = "/supplierReceiveAddress/findSupplierAddress", method = RequestMethod.POST)
    RestfulBaseResponse<List<SupplierReceiveResp>> findSupplierAddress(@RequestParam(value = "storeId") String storeId);

    @RequestMapping(value = "/supplierReceiveAddress/deleteReceiveAddress", method = RequestMethod.POST)
    RestfulBaseResponse<Boolean> deleteReceiveAddress(@RequestParam(value = "id") String id);

    /**
     * 修改或者新增收货地址
     * @param supplierReceiveReq
     * @return
     */
    @RequestMapping(value = "/supplierReceiveAddress/saveOrUpdateReceiveAddress", method = RequestMethod.POST)
    RestfulBaseResponse<SupplierReceiveResp> saveOrUpdateReceiveAddress(@RequestBody SupplierReceiveReq supplierReceiveReq);

    /***
     * 导出数据
     * @param exportManageForStAReq
     * @return
     */
    @RequestMapping(value = "/afterSaleForStA/findByServiceNosForStA", method = RequestMethod.POST)
    RestfulBaseResponse<List<AfterSaleExportForStAResp>> findByServiceNosForStA(@RequestBody ExportManageForStAReq exportManageForStAReq);


    }
