package store.admin.feign.fallback;


import aftersale.api.dto.aftersalemanage.AfterSaleManageDetailsResp;
import aftersale.api.dto.aftersalemanage.AfterSaleResp;
import aftersale.api.dto.aftersalemanage.req.ExportManageForStAReq;
import aftersale.api.dto.aftersalemanage.req.ExportManagerReq;
import aftersale.api.dto.aftersalemanage.req.ExportReq;
import com.alibaba.fastjson.JSON;
import feign.hystrix.FallbackFactory;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.RequestMapping;
import sinomall.config.response.RestfulBaseResponse;
import store.admin.feign.AfterSaleFeign;
import store.admin.vo.aftersale.req.AfterSaleManageForStAReq;
import store.admin.vo.aftersale.req.SupplierReceiveReq;
import store.admin.vo.aftersale.req.UpdateAfterSaleStatusCheckReq;
import store.admin.vo.aftersale.resp.AfterSaleExportForStAResp;
import store.admin.vo.aftersale.resp.AfterSaleManagerForStAResp;
import store.admin.vo.aftersale.resp.SupplierReceiveResp;
import utils.ExceptionCode;
import utils.sql.PageVo;

import java.util.List;


@Slf4j
@Component
@RequestMapping("fallback/afterSale")
public class AfterSaleFeignFallBack implements FallbackFactory<AfterSaleFeign> {

    @Override
    public AfterSaleFeign create(Throwable throwable) {
        return new AfterSaleFeign() {


            @Override
            public RestfulBaseResponse<AfterSaleManageDetailsResp> findByServiceNo(String serviceNo) {
                log.error("feign 运营后台-根据serviceNo查看详情 fallback 处理, 请求参数 = {}", serviceNo, throwable);
                return RestfulBaseResponse.fail(ExceptionCode.dataNotFound.getCode(),ExceptionCode.dataNotFound.getDescription(),ExceptionCode.dataNotFound.getDescription());
            }

            @Override
            public RestfulBaseResponse<AfterSaleResp> findByServiceNoForStA(String serviceNo) {
                log.error("feign 运营后台-根据serviceNo查看afterSale主表详情 fallback 处理, 请求参数 = {}", serviceNo, throwable);
                return RestfulBaseResponse.fail(ExceptionCode.dataNotFound.getCode(),ExceptionCode.dataNotFound.getDescription(),ExceptionCode.dataNotFound.getDescription());
            }



            @Override
            public RestfulBaseResponse<PageVo<AfterSaleManagerForStAResp>> findByConditionsForStA(AfterSaleManageForStAReq afterSaleManageForStAReq) {
                log.error("feign 运营后台-条件查询相关售后记录 fallback 处理, 请求参数 = {}", JSON.toJSONString(afterSaleManageForStAReq), throwable);
                return RestfulBaseResponse.fail(ExceptionCode.dataNotFound.getCode(),ExceptionCode.dataNotFound.getDescription(),ExceptionCode.dataNotFound.getDescription());
            }

            @Override
            public RestfulBaseResponse<Boolean> updateAfterSaleStatus(UpdateAfterSaleStatusCheckReq updateAfterSaleStatusCheckReq) {
                log.error("feign 运营后台-根据serviceNo修改审核状态 fallback 处理, 请求参数 = {}", JSON.toJSONString(updateAfterSaleStatusCheckReq), throwable);
                return RestfulBaseResponse.fail(ExceptionCode.dataNotFound.getCode(),ExceptionCode.dataNotFound.getDescription(),ExceptionCode.dataNotFound.getDescription());
            }

            @Override
            public RestfulBaseResponse<Boolean> updateAfterSaleForReceive(UpdateAfterSaleStatusCheckReq updateAfterSaleStatusCheckReq) {
                log.error("feign 运营后台-根据确认收货 fallback 处理, 请求参数 = {}", JSON.toJSONString(updateAfterSaleStatusCheckReq), throwable);
                return RestfulBaseResponse.fail(ExceptionCode.dataNotFound.getCode(),ExceptionCode.dataNotFound.getDescription(),ExceptionCode.dataNotFound.getDescription());
            }

            @Override
            public RestfulBaseResponse<List<SupplierReceiveResp>> findSupplierAddress(String storeId) {
                log.error("feign 运营后台-根据storeId查看供应商收货地址 fallback 处理, 请求参数 = {}", storeId, throwable);
                return RestfulBaseResponse.fail(ExceptionCode.dataNotFound.getCode(),ExceptionCode.dataNotFound.getDescription(),ExceptionCode.dataNotFound.getDescription());
            }

            @Override
            public RestfulBaseResponse<Boolean> deleteReceiveAddress(String id) {
                log.error("feign 运营后台-根据id删除供应商收货地址 fallback 处理, 请求参数 = {}", id, throwable);
                return RestfulBaseResponse.fail(ExceptionCode.dataNotFound.getCode(),ExceptionCode.dataNotFound.getDescription(),ExceptionCode.dataNotFound.getDescription());
            }

            @Override
            public RestfulBaseResponse<SupplierReceiveResp> saveOrUpdateReceiveAddress(SupplierReceiveReq supplierReceiveReq) {
                log.error("feign 运营后台-新增或者修改供应商收货地址 fallback 处理, 请求参数 = {}", JSON.toJSONString(supplierReceiveReq), throwable);
                return RestfulBaseResponse.fail(ExceptionCode.dataNotFound.getCode(),ExceptionCode.dataNotFound.getDescription(),ExceptionCode.dataNotFound.getDescription());
            }

            @Override
            public RestfulBaseResponse<List<AfterSaleExportForStAResp>> findByServiceNosForStA(ExportManageForStAReq exportManageForStAReq) {
                log.error("feign 运营后台-根据serviceNos查看所有的商品 fallback 处理, 请求参数 = {}", JSON.toJSONString(exportManageForStAReq), throwable);
                return RestfulBaseResponse.fail(ExceptionCode.dataNotFound.getCode(),ExceptionCode.dataNotFound.getDescription(),ExceptionCode.dataNotFound.getDescription());
            }
        };
    }
}
