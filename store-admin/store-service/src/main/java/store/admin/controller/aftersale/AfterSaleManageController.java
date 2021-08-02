package store.admin.controller.aftersale;

import aftersale.api.dto.aftersalemanage.AfterSaleManageDetailsResp;
import aftersale.api.dto.aftersalemanage.req.ExportManageForStAReq;
import com.alibaba.fastjson.JSON;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiOperationSupport;
import lombok.extern.slf4j.Slf4j;
//import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import sinomall.config.response.RestfulBaseResponse;
import store.admin.feign.AfterSaleFeign;
import store.admin.service.AfterSaleService;
import store.admin.utils.StoreInfoUtil;
import store.admin.vo.aftersale.req.AfterSaleManageForStAReq;
import store.admin.vo.aftersale.req.SupplierReceiveReq;
import store.admin.vo.aftersale.req.UpdateAfterSaleStatusCheckReq;
import store.admin.vo.aftersale.resp.AfterSaleExportForStAResp;
import store.admin.vo.aftersale.resp.AfterSaleManagerForStAResp;
import store.admin.vo.aftersale.resp.SupplierReceiveResp;
import utils.Lang;
import utils.date.DateUtils;
import utils.sql.PageVo;
import utils.string.StringUtils;

import java.util.List;


@RequestMapping("/afterSaleMange")
@Slf4j
@Api(value = "AfterSaleManageController", description = "供应商后台管理-售后管理", tags = "供应商后台管理-售后管理控制器")
@RestController
public class AfterSaleManageController {

    @Autowired
    AfterSaleFeign afterSaleFeign;
    @Autowired
    AfterSaleService afterSaleService;

    @ApiOperation(value = "条件查询售后记录", httpMethod = "POST")
    @PostMapping(value = "findByConditions/get", consumes = "application/json", produces = "application/json")
    @ApiOperationSupport(order = 1)
    RestfulBaseResponse<PageVo<AfterSaleManagerForStAResp>> findByConditions(@RequestBody AfterSaleManageForStAReq afterSaleManagerReq) {
        String storeId = StoreInfoUtil.getStoreId();
        if (StringUtils.isEmpty(storeId)
                || Lang.isEmpty(afterSaleManagerReq)) {
            return null;
        }
        afterSaleManagerReq.setStoreId(storeId);
        return afterSaleFeign.findByConditionsForStA(afterSaleManagerReq);
    }


    @ApiOperation(value = "根据serviceNo查看审核订单详情", httpMethod = "POST")
    @PostMapping(value = "findByServiceNo/get")
    RestfulBaseResponse<AfterSaleManageDetailsResp> findByServiceNo(@RequestParam(value = "serviceNo") String serviceNo) {
        return afterSaleFeign.findByServiceNo(serviceNo);
    }

    @ApiOperation(value = "根据serviceNo查确认审核", httpMethod = "POST")
    @PostMapping(value = "updateAfterSaleStatus/update", consumes = "application/json", produces = "application/json")
    RestfulBaseResponse<Boolean> updateAfterSaleStatus(@RequestBody UpdateAfterSaleStatusCheckReq updateAfterSaleStatusCheckReq) {
        return afterSaleService.updateAfterSaleStatus(updateAfterSaleStatusCheckReq);
    }


    @ApiOperation(value = "供应商确认收货", httpMethod = "POST")
    @PostMapping(value = "updateAfterSaleForReceive/update")
    RestfulBaseResponse<Boolean> updateAfterSaleForReceive(@RequestParam(value = "serviceNo") String serviceNo) {
        return afterSaleService.updateAfterSaleForReceive(serviceNo);
    }


    @ApiOperation(value = "供应商新增/修改收货地址", httpMethod = "POST")
    @PostMapping(value = "saveOrUpdateReceiveAddress/add", consumes = "application/json", produces = "application/json")
    RestfulBaseResponse<SupplierReceiveResp> saveOrUpdateReceiveAddress(@RequestBody SupplierReceiveReq supplierReceiveReq) {
        log.info("修改或保存的供应商收货地址==={}", JSON.toJSONString(supplierReceiveReq));
        String storeId = StoreInfoUtil.getStoreId();

        supplierReceiveReq.setStoreId(storeId);
        return afterSaleFeign.saveOrUpdateReceiveAddress(supplierReceiveReq);
    }


    @ApiOperation(value = "供应商删除收货地址", httpMethod = "POST")
    @PostMapping(value = "deleteReceiveAddress/delete")
    RestfulBaseResponse<Boolean> deleteReceiveAddress(@RequestParam(value = "id") String id) {
        if (StringUtils.isEmpty(id)) {
            return RestfulBaseResponse.fail(RestfulBaseResponse.ILLEGAL_ARGUMENT_CODE, "删除供应商收货地址失败，id不能为空");
        }
        // todo 可能要新增一个判断 是否是当前登录店铺的
        return afterSaleFeign.deleteReceiveAddress(id);
    }


    @ApiOperation(value = "供应商查看所有的收货地址", httpMethod = "POST")
    @PostMapping(value = "findReceiveAddresses/get", produces = "application/json")
    RestfulBaseResponse<List<SupplierReceiveResp>> findReceiveAddresses() {
        String storeId = StoreInfoUtil.getStoreId();

        if (StringUtils.isEmpty(storeId)) {
            return null;
        }
        return afterSaleFeign.findSupplierAddress(storeId);
    }



    /**
     * @author taofeng
     * @date 2019/1/25
     * <p>
     * 导出
     */
    @ApiOperation(value = "导出结果", httpMethod = "GET")
    @RequestMapping(value = "downloadExcel/get")
    public ResponseEntity<byte[]> downloadExcel(@RequestParam(value = "serviceNo")String serviceNo, @RequestParam(value = "orderNo")String orderNo, @RequestParam(value = "applicationStatus[]")List<String> applicationStatus, @RequestParam(value = "beginTime")String beginTime,@RequestParam(value = "endTime")String endTime,@RequestParam(value = "afterSaleType")String afterSaleType, @RequestParam(value = "phoneNo")String phoneNo,@RequestParam(value = "serviceNos[]")List<String> serviceNos) {

        ExportManageForStAReq exportManageForStAReq=new ExportManageForStAReq();
        ResponseEntity<byte[]> responseEntity = null;
        String storeId = StoreInfoUtil.getStoreId();
        exportManageForStAReq.setStoreId(storeId);
        exportManageForStAReq.setServiceNo(serviceNo);
        exportManageForStAReq.setOrderNo(orderNo);
        exportManageForStAReq.setApplicationStatus(applicationStatus);

        if(!StringUtils.isEmpty(beginTime)){
            exportManageForStAReq.setBeginTime(beginTime);
        }
        if(!StringUtils.isEmpty(endTime)){
            exportManageForStAReq.setEndTime(endTime);
        }

        exportManageForStAReq.setPhoneNo(phoneNo);
        exportManageForStAReq.setAfterSaleType(afterSaleType);
        exportManageForStAReq.setServiceNos(serviceNos);
        RestfulBaseResponse<List<AfterSaleExportForStAResp>> resp=afterSaleFeign.findByServiceNosForStA(exportManageForStAReq);
        if (!RestfulBaseResponse.SUCCESS_CODE.equals(resp.getCode())) {
            throw new RuntimeException(resp.getMessage());
        }
        List<AfterSaleExportForStAResp> dataList = resp.getResult();
        try {
            if (!Lang.isEmpty(dataList) && dataList.size() > 0) {
                byte[] downloadExcel = afterSaleService.downloadExcel(dataList);

                String fileName = java.net.URLEncoder.encode("供应商售后表.xlsx", "UTF-8");
                //设置响应头让浏览器正确显示下载
                HttpHeaders headers = new HttpHeaders();
                headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
                headers.setContentDispositionFormData("attachment", fileName);
                responseEntity = new ResponseEntity<>(downloadExcel, headers, HttpStatus.OK);
            }
        } catch (Exception e) {
            log.error("售后记录报表导出异常", e);
        }
        return responseEntity;
    }








}
