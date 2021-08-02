package store.admin.service;

import com.alibaba.fastjson.JSON;

import lombok.extern.log4j.Log4j;
import order.definication.OrderAfterRefundType;
import order.definication.OrderAfterSaleStatus;
import order.definication.TrdSpOrderStatus;
import order.dto.aftersale.req.AllHaveAfterSaleReq;
import order.vo.query.OrderDetailQueryVo;
import org.apache.commons.lang3.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.streaming.SXSSFCell;
import org.apache.poi.xssf.streaming.SXSSFRow;
import org.apache.poi.xssf.streaming.SXSSFSheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFRichTextString;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.*;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;
import pool.commonUtil.MessageDictionary;
import pool.enums.NumberCommonUtils;
import provider.trdsp.api.SubOrderApi;
import provider.trdsp.api.SubOrderRestApi;
import shipping.api.dto.LogisticCompanyDto;
import sinomall.config.response.RestfulBaseResponse;
import sinomall.global.common.response.BaseResponse;
import store.admin.dto.OrderQueryDto;
import store.admin.dto.ShippingBatchImportDto;
import store.admin.exception.BusiErrorCode;
import store.admin.stub.LogisticsCompanyApiStub;
import store.admin.utils.ExcelUtils;
import store.admin.utils.StoreInfoUtil;
import store.admin.vo.BatchDealOrderVo;
import store.admin.vo.JqueryDataTablesVo;
import store.admin.vo.order.OrdersQueryVo;
import store.admin.vo.query.OrderBatchDealVo;
import store.api.MallShippingApi;
import store.api.MallShippingRestApi;
import store.api.vo.MallShippingVo;
import supplierapi.vo.order.SubOrderDto;
import utils.Lang;
import utils.collection.CollectionUtil;
import utils.date.DateUtils;
import utils.excel.ExcelUtil;
import utils.sql.JdbcTemplatePage;
import utils.sql.PageVo;

import javax.servlet.ServletOutputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.util.*;
import java.util.stream.Collectors;

/**
 * Created by xjw on 2018年8月25日 11:06:17.
 */
@Log4j
@Component
public class OrderService {

    private SXSSFWorkbook hwbBatch;
    private static final String[] titlesBatch = {"订单号", "物流公司", "物流单号"};
    private static final String[] titlesBatch2 = {"物流公司"};

    @Autowired
    SubOrderRestApi subOrderApi;
    //    @Autowired
//    OrderMainQueryApi orderMainQueryApi;
    /*@Autowired
    OrderMainQueryApi orderMainQueryApi;*/
    @Autowired
    MallShippingRestApi mallShippingApi;

    @Autowired
    LogisticsCompanyApiStub logisticsCompanyApi;
    @Autowired
    JdbcTemplatePage jdbcTemplatePage;
    @Autowired
    JdbcTemplate jdbcTemplate;
    @Autowired
    ExcelUtils excelUtils;

    @Value("${order.service.url}")
    private String orderServiceUrl;

    public static final RestTemplate restTemplate = new RestTemplate();


    public BaseResponse sureOrdersByOrderId(String orderId) {
        String storeId = StoreInfoUtil.getStoreId();
        if (Lang.isEmpty(orderId) || Lang.isEmpty(storeId)) {
            return new BaseResponse<>(false, MessageDictionary.RETURN_NULL_PARAM_ERROR_MESSAGE, "orderNo/storeId is null", MessageDictionary.RETURN_RUNTIME_CONDITION_MISSING_CODE);
        }
        List<SubOrderDto> subOrderDtos = subOrderApi.findSubOrderByOrderId(orderId);
        if (CollectionUtil.isEmpty(subOrderDtos)) {
            return new BaseResponse<>(false, MessageDictionary.RETURN_INTERNAL_ERROR_MESSAGE, "subOrderDtos is null", MessageDictionary.RETURN_INTERNAL_EXCEPTION_CODE);
        }
        String allHaveAfterSaleUrl = orderServiceUrl + "/orderMain/allHaveAfterSale";

        Boolean allHaveAfterSale = RestfulBaseResponse.get(restTemplate.exchange(allHaveAfterSaleUrl, HttpMethod.POST, new HttpEntity<>(new AllHaveAfterSaleReq(orderId)), new ParameterizedTypeReference<RestfulBaseResponse<Boolean>>() {
        }).getBody());

        if (allHaveAfterSale) {
            return new BaseResponse<>(false, MessageDictionary.ORDER_HAVE_AFTER_SALE, MessageDictionary.ORDER_HAVE_AFTER_SALE, MessageDictionary.RETURN_ERROR_CODE);
        }

        for (SubOrderDto subOrderDto : subOrderDtos) {
            BaseResponse response = subOrderApi.setSubOrderSured(subOrderDto.getSubOrderNo(), storeId);
            if (!response.isSuccess()) {
                return response;
            }
        }
        return new BaseResponse(true, MessageDictionary.RETURN_SUCCESS_MESSAGE, "success", MessageDictionary.RETURN_SUCCESS_CODE);
    }


    public BaseResponse batchWithOrders(OrderBatchDealVo orderBatchDealVo) {
        String storeId = StoreInfoUtil.getStoreId();
        if (Lang.isEmpty(orderBatchDealVo) || StringUtils.isEmpty(storeId)) {
            return new BaseResponse<>(false, MessageDictionary.RETURN_NULL_PARAM_ERROR_MESSAGE, "orderBatchDealVo/storeId is null", MessageDictionary.RETURN_RUNTIME_CONDITION_MISSING_CODE);
        }
        ArrayList<String> sucList = new ArrayList<>();
        ArrayList<String> timeList = new ArrayList<>();
        ArrayList<String> failList = new ArrayList<>();
        BatchDealOrderVo batchDealOrderVo = new BatchDealOrderVo();
        List<String> orderNos = orderBatchDealVo.getOrderNo();
        if (CollectionUtil.isEmpty(orderNos)) {
            return new BaseResponse<>(false, MessageDictionary.RETURN_NULL_PARAM_ERROR_MESSAGE, "orderNos is null", MessageDictionary.RETURN_RUNTIME_CONDITION_MISSING_CODE);
        }
        try {
            switch (orderBatchDealVo.getFlag()) {
                case "setSubOrderAccepted": {
                    //批量确认签收
                    for (String orderNo : orderNos) {
                        try {
                            subOrderApi.setSubOrderAcceptedForFifteenUse(orderNo, storeId);
                            sucList.add(orderNo);
                        } catch (Exception e) {
                            if (e.getMessage().equals(BusiErrorCode.IF_ABOVE_FIFTEEN_DAYS.toString())) {
                                timeList.add(orderNo);
                            } else {
                                failList.add(orderNo);
                            }
                        }
                    }
                    break;
                }
                case "setSubOrderRejected": {
                    //批量确认拒收
                    for (String orderNo : orderNos) {
                        try {
                            subOrderApi.setSubOrderRejectedForFifteenUse(orderNo, storeId);
                            sucList.add(orderNo);
                        } catch (Exception e) {
                            if (e.getMessage().equals(BusiErrorCode.IF_ABOVE_FIFTEEN_DAYS.toString())) {
                                timeList.add(orderNo);
                            } else {
                                failList.add(orderNo);
                            }
                        }
                    }
                    break;
                }
                case "setSubOrderDenied": {
                    //取消订单
                    for (String orderNo : orderNos) {
                        try {
                            subOrderApi.setSubOrderDenied(orderNo, storeId);
                            sucList.add(orderNo);
                        } catch (Exception e) {
                            failList.add(orderNo);
                        }
                    }
                    break;
                }
                case "setSubOrderSured": {
                    //批量确认订单(其中包括 单个确认订单)
                    for (String orderNo : orderNos) {
                        try {
                            subOrderApi.setSubOrderSured(orderNo, storeId);
                            sucList.add(orderNo);
                        } catch (Exception e) {
                            failList.add(orderNo);
                        }
                    }
                    break;
                }
            }
            batchDealOrderVo.setFailList(failList);
            batchDealOrderVo.setTimeList(timeList);
            batchDealOrderVo.setSucList(sucList);
            return new BaseResponse<>(true, MessageDictionary.RETURN_SUCCESS_MESSAGE, batchDealOrderVo, MessageDictionary.RETURN_SUCCESS_CODE);
        } catch (Exception e) {
            return new BaseResponse<>(false, MessageDictionary.RETURN_INTERNAL_ERROR_MESSAGE, e.getMessage(), MessageDictionary.RETURN_INTERNAL_EXCEPTION_CODE);
        }
    }


    public byte[] orderExportService(OrderQueryDto orderQueryDto) {
        Map<String, Object> sqlAndParams = orderExportSqlAndParams(orderQueryDto);
        String sql = (String) sqlAndParams.get("sql");
        List<Object> params = (List<Object>) sqlAndParams.get("params");
        List<Map<String, Object>> lists = jdbcTemplate.queryForList(sql, params.toArray());
        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
        List<String> title = Arrays.asList(new String[]{"序号", "供应商", "订单号", "订单状态", "是否售后中", "订单金额", "商品金额", "运费", "下单时间", "收货人", "收货人电话", "收货人地址", "商品编码", "商品名称", "商品单价", "数量"});
        Workbook workbook = null;
        try {
            workbook = new XSSFWorkbook();
            Sheet sheet = workbook.createSheet();
            ExcelUtil.createHeader(sheet, title);

            Integer showIndexStartRow = null, showIndexColumn = 0;
            Integer storeNameStartRow = null, storeNameColumn = 1;
            Integer orderNoStartRow = null, orderNoColumn = 2;
            Integer orderStatusStartRow = null, orderStatusColumn = 3;
            Integer afterSaleApplyingStartRow = null, afterSaleApplyingColumn = 4;
            Integer sumPriceStartRow = null, sumPriceColumn = 5;
            Integer sumNofreightPriceStartRow = null, sumNofreightPriceColumn = 6;
            Integer freightStartRow = null, freightColumn = 7;
            Integer createtimeStartRow = null, createtimeColumn = 8;
            Integer recipientNameStartRow = null, recipientNameColumn = 9;
            Integer recipientPhoneStartRow = null, recipientPhoneColumn = 10;
            Integer addressNameStartRow = null, addressNameColumn = 11;
            Integer productSkuStartRow = null, productSkuColumn = 12;
            Integer productNameStartRow = null, productNameColumn = 13;
            Integer finalPriceStartRow = null, finalPriceColumn = 14;
            Integer countStartRow = null, countColumn = 15;

            String showIndexPrevious = null;
            String storeNamePrevious = null;
            String orderNoPrevious = null;
            String orderStatusPrevious = null;
            String afterSaleApplyingPrevious = null;
            String sumPricePrevious = null;
            String sumNofreightPricePrevious = null;
            String freightPrevious = null;
            String createtimePrevious = null;
            String recipientNamePrevious = null;
            String recipientPhonePrevious = null;
            String addressNamePrevious = null;
            String productSkuPrevious = null;
            String productNamePrevious = null;
            String finalPricePrevious = null;
            String countPrevious = null;

            boolean baseOnOrderNo;
            CellStyle cellStyle = ExcelUtil.createValueCellStyle(workbook);
            //序号
            Integer index = 1;
            String orderNoForCount = null;
            for (int i = 0, rowIndex = 1; i < lists.size(); i++, rowIndex++) {
                Row row = sheet.createRow(rowIndex);
                row.setHeightInPoints(25);
                Map<String, Object> returnMap;
                Map<String, Object> rowMap = lists.get(i);
                String orderNo = (String) rowMap.get("ORDERNO");
                baseOnOrderNo = orderNo.equals(orderNoPrevious);
                //序号
                if (Lang.isEmpty(orderNoForCount)) {
                    orderNoForCount = orderNo;
                } else if (!orderNo.equals(orderNoForCount)) {
                    orderNoForCount = orderNo;
                    index++;
                }
                String showIndex = "" + index;
                returnMap = createOrMargedCell(sheet, row, cellStyle, rowIndex, showIndex, showIndexPrevious, showIndexStartRow, showIndexColumn, baseOnOrderNo);
                showIndexPrevious = (String) returnMap.get("previousValue");
                showIndexStartRow = (Integer) returnMap.get("startRow");

                //供应商 如果相同基于订单号合并
                String storeName = (String) rowMap.get("STORENAME");
                returnMap = createOrMargedCell(sheet, row, cellStyle, rowIndex, storeName, storeNamePrevious, storeNameStartRow, storeNameColumn, baseOnOrderNo);
                storeNamePrevious = (String) returnMap.get("previousValue");
                storeNameStartRow = (Integer) returnMap.get("startRow");

                //订单号 如果相同基于订单号合并
                returnMap = createOrMargedCell(sheet, row, cellStyle, rowIndex, orderNo, orderNoPrevious, orderNoStartRow, orderNoColumn, baseOnOrderNo);
                orderNoPrevious = (String) returnMap.get("previousValue");
                orderNoStartRow = (Integer) returnMap.get("startRow");
                //订单状态 如果相同基于订单号合并
                String status = Lang.isEmpty(rowMap.get("status")) ? "" : (String) rowMap.get("status");
//                String afterSaleStatus = Lang.isEmpty(rowMap.get("afterSaleStatus")) ? "" : (String) rowMap.get("afterSaleStatus");
//                String afterSaleType = Lang.isEmpty(rowMap.get("afterSaleType")) ? "" : (String) rowMap.get("afterSaleType");
                String afterSaleRefundType = Lang.isEmpty(rowMap.get("afterSaleRefundType")) ? "" : (String) rowMap.get("afterSaleRefundType");
                String orderStatus = "";

                if (StringUtils.isNotBlank(afterSaleRefundType)) {
                    if (OrderAfterRefundType.PART_REFUND.getValue().equalsIgnoreCase(afterSaleRefundType)) {
                        orderStatus = "部分退款";
                    }else  if (OrderAfterRefundType.FULL_REFUND.getValue().equalsIgnoreCase(afterSaleRefundType)) {
                        orderStatus = "已退款";
                    }
                }else{
                    switch (status) {
                        case "1":
                            orderStatus = "已发货";
                            break;
                        case "2":
                            orderStatus = "已签收";
                            break;
                        case "3":
                            orderStatus = "已取消";
                            break;
                        case "4":
                            orderStatus = "已拒收";
                            break;
                        case "5":
                            orderStatus = "待付款";
                            break;
                        case "6":
                            orderStatus = "待确认";
                            break;
                        case "7":
                            orderStatus = "已确认";
                            break;
                        case "8":
                            orderStatus = "卖家已取消";
                            break;
                        case "9":
                            orderStatus = "系统已取消";
                            break;
                        default:
                            orderStatus = "";
                    }
                }
                returnMap = createOrMargedCell(sheet, row, cellStyle, rowIndex, orderStatus, orderStatusPrevious, orderStatusStartRow, orderStatusColumn, baseOnOrderNo);
                orderStatusPrevious = (String) returnMap.get("previousValue");
                orderStatusStartRow = (Integer) returnMap.get("startRow");

                String afterSaleStatus = (String) rowMap.get("afterSaleStatus");
                String afterSaleApplyingValue = "否";
                if (StringUtils.isNotBlank(afterSaleStatus) && OrderAfterSaleStatus.APPLYING.getValue().equals(afterSaleStatus)) {
                    afterSaleApplyingValue = "是";
                }
                returnMap = createOrMargedCell(sheet, row, cellStyle, rowIndex, afterSaleApplyingValue, afterSaleApplyingPrevious, afterSaleApplyingStartRow, afterSaleApplyingColumn, baseOnOrderNo);
                afterSaleApplyingPrevious = (String) returnMap.get("previousValue");
                afterSaleApplyingStartRow = (Integer) returnMap.get("startRow");

                //订单金额 如果相同基于订单号合并
                BigDecimal sumPrice = (BigDecimal) rowMap.get("SUMPRICE");
                String sumPriceValue = Lang.isEmpty(sumPrice) ? "0" : sumPrice.toString();
                returnMap = createOrMargedCell(sheet, row, cellStyle, rowIndex, sumPriceValue, sumPricePrevious, sumPriceStartRow, sumPriceColumn, baseOnOrderNo);
                sumPricePrevious = (String) returnMap.get("previousValue");
                sumPriceStartRow = (Integer) returnMap.get("startRow");

                //订单不含运费金额
                BigDecimal sumNofreightPrice = (BigDecimal) rowMap.get("SUMNOFREIGHTPRICE");
                String sumNofreightPriceValue = Lang.isEmpty(sumNofreightPrice) ? "0" : sumNofreightPrice.toString();
                returnMap = createOrMargedCell(sheet, row, cellStyle, rowIndex, sumNofreightPriceValue, sumNofreightPricePrevious, sumNofreightPriceStartRow, sumNofreightPriceColumn, baseOnOrderNo);
                sumNofreightPricePrevious = (String) returnMap.get("previousValue");
                sumNofreightPriceStartRow = (Integer) returnMap.get("startRow");

                //运费 如果相同基于订单号合并
                BigDecimal freight = (BigDecimal) rowMap.get("FREIGHT");
                String freightValue = Lang.isEmpty(freight) ? "0" : freight.toString();
                returnMap = createOrMargedCell(sheet, row, cellStyle, rowIndex, freightValue, freightPrevious, freightStartRow, freightColumn, baseOnOrderNo);
                freightPrevious = (String) returnMap.get("previousValue");
                freightStartRow = (Integer) returnMap.get("startRow");

                //下单时间 如果相同基于订单号合并
                Date createtime = (Date) rowMap.get("CREATETIME");
                String createtimeValue = Lang.isEmpty(createtime) ? "" : createtime.toString();
                returnMap = createOrMargedCell(sheet, row, cellStyle, rowIndex, createtimeValue, createtimePrevious, createtimeStartRow, createtimeColumn, baseOnOrderNo);
                createtimePrevious = (String) returnMap.get("previousValue");
                createtimeStartRow = (Integer) returnMap.get("startRow");

                //收货人 如果相同基于订单号合并
                String recipientName = (String) rowMap.get("RECIPIENTNAME");
                String recipientNameValue = Lang.isEmpty(recipientName) ? "" : recipientName;
                returnMap = createOrMargedCell(sheet, row, cellStyle, rowIndex, recipientNameValue, recipientNamePrevious, recipientNameStartRow, recipientNameColumn, baseOnOrderNo);
                recipientNamePrevious = (String) returnMap.get("previousValue");
                recipientNameStartRow = (Integer) returnMap.get("startRow");

                //收货人电话 如果相同基于订单号合并
                String recipientPhone = (String) rowMap.get("RECIPIENTPHONE");
                String recipientPhoneValue = Lang.isEmpty(recipientPhone) ? "" : recipientPhone;
                returnMap = createOrMargedCell(sheet, row, cellStyle, rowIndex, recipientPhoneValue, recipientPhonePrevious, recipientPhoneStartRow, recipientPhoneColumn, baseOnOrderNo);
                recipientPhonePrevious = (String) returnMap.get("previousValue");
                recipientPhoneStartRow = (Integer) returnMap.get("startRow");

                //收货人地址 如果相同基于订单号合并
                String addressName = (String) rowMap.get("ADDRESSNAME");
                String addressNameValue = Lang.isEmpty(addressName) ? "" : addressName;
                returnMap = createOrMargedCell(sheet, row, cellStyle, rowIndex, addressNameValue, addressNamePrevious, addressNameStartRow, addressNameColumn, baseOnOrderNo);
                addressNamePrevious = (String) returnMap.get("previousValue");
                addressNameStartRow = (Integer) returnMap.get("startRow");

                //商品编码 不合并
                String productSku = (String) rowMap.get("sku");
                String productSkuValue = Lang.isEmpty(productSku) ? "" : productSku;
                returnMap = createOrMargedCell(sheet, row, cellStyle, rowIndex, productSkuValue, productSkuPrevious, productSkuStartRow, productSkuColumn, false);
                productSkuPrevious = (String) returnMap.get("previousValue");
                productSkuStartRow = (Integer) returnMap.get("startRow");

                //商品名称 不合并
                String productName = (String) rowMap.get("PRODUCTNAME");
                String productNameValue = Lang.isEmpty(productName) ? "" : productName;
                returnMap = createOrMargedCell(sheet, row, cellStyle, rowIndex, productNameValue, productNamePrevious, productNameStartRow, productNameColumn, false);
                productNamePrevious = (String) returnMap.get("previousValue");
                productNameStartRow = (Integer) returnMap.get("startRow");

                //商品单价 不合并
                BigDecimal finalPrice = (BigDecimal) rowMap.get("FINALPRICE");
                String finalPriceValue = Lang.isEmpty(finalPrice) ? "" : finalPrice.toString();
                returnMap = createOrMargedCell(sheet, row, cellStyle, rowIndex, finalPriceValue, finalPricePrevious, finalPriceStartRow, finalPriceColumn, false);
                finalPricePrevious = (String) returnMap.get("previousValue");
                finalPriceStartRow = (Integer) returnMap.get("startRow");

                //数量 不合并
            //    BigDecimal count = (BigDecimal) rowMap.get("COUNT");
                Integer count =  (Integer) rowMap.get("COUNT");
                String countValue = Lang.isEmpty(count) ? "" : count.toString();
                returnMap = createOrMargedCell(sheet, row, cellStyle, rowIndex, countValue, countPrevious, countStartRow, countColumn, false);
                countPrevious = (String) returnMap.get("previousValue");
                countStartRow = (Integer) returnMap.get("startRow");
            }
            for (int i = 0; i < title.size(); i++) {
                sheet.autoSizeColumn(i, true);
            }
            workbook.write(byteArrayOutputStream);
            byteArrayOutputStream.flush();
            byteArrayOutputStream.close();
        } catch (Exception e) {
            log.info("订单导出异常", e);
        } finally {
            try {
                if (Lang.isEmpty(workbook)) {
                    workbook.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return byteArrayOutputStream.toByteArray();
    }

    private Map<String, Object> createOrMargedCell(Sheet sheet, Row row, CellStyle cellStyle, int currentRow, String currentValue, String previousValue, Integer startRow, int column, boolean merge) {
        Map<String, Object> map = new HashMap<>();
        if (currentRow > 0 && currentValue.equals(previousValue) && merge) {
            if (Lang.isEmpty(startRow)) {
                startRow = currentRow - 1;
            } else {
                List<CellRangeAddress> cellRangeAddresseList = sheet.getMergedRegions();
                for (int margedIndex = 0; margedIndex < cellRangeAddresseList.size(); margedIndex++) {
                    CellRangeAddress marged = cellRangeAddresseList.get(margedIndex);
                    if (marged.getFirstRow() == startRow && marged.getLastRow() == currentRow - 1 && marged.getFirstColumn() == column) {
                        sheet.removeMergedRegion(margedIndex);
                        break;
                    }
                }
            }
            sheet.addMergedRegion(new CellRangeAddress(startRow, currentRow, column, column));
        } else {
            Cell cell = row.createCell(column, Cell.CELL_TYPE_STRING);
            cell.setCellValue(currentValue);
            cell.setCellStyle(cellStyle);
            previousValue = currentValue;
            startRow = currentRow;
        }
        map.put("startRow", startRow);
        map.put("previousValue", previousValue);
        return map;
    }

    private Map<String, Object> orderExportSqlAndParams(OrderQueryDto orderQueryDto) {
        if (Lang.isEmpty(orderQueryDto.getStoreId())) {
            return null;
        }
        Map<String, Object> sqlAndParams = new HashMap<>();
        List<Object> params = new ArrayList<>();
        StringBuilder sql = new StringBuilder();

        sql.append("SELECT " +
                " om.store_name AS storeName, " +
                " om.order_no AS orderNo, " +
                " (select distinct so.trd_order_state from mall_order.sub_order so where so.order_id = om.id) AS status, " +
                " om.after_sale_status as afterSaleStatus, " +
                " om.sum_price AS sumPrice, " +
                " om.freight AS freight, " +
                " om.sum_nofreight_price AS sumNofreightPrice, " +
                " om.create_time AS createtime, " +
                " om.recipient_name AS recipientName, " +
                " om.recipient_phone AS recipientPhone, " +
                " om.address_name AS addressName, " +
                " om.after_sale_status AS afterSaleStatus, " +
                " om.after_sale_type AS afterSaleType, " +
                " om.after_sale_refund_type AS afterSaleRefundType, " +
                " OI.product_name AS productName, " +
                " OI.sku AS sku, " +
                " OI.final_price AS finalPrice, " +
                " OI.count AS count " +
                "FROM " +
                " mall_order.order_main om " +
                "LEFT JOIN " +
                " mall_order.order_item OI " +
                "ON " +
                " om.id = OI.order_id " +
                "WHERE " +
                " 1 = 1 " +
                "and om.is_delete = '0' ");
        //供应商
        sql.append("and om.store_id = ? ");
        params.add(orderQueryDto.getStoreId());
        //订单状态
        if (Lang.isEmpty(orderQueryDto.getTrdOrderState())) {
            sql.append("and om.id in (select so.order_id from mall_order.sub_order so where so.trd_order_state in ('1','2','3','4','5','6','7','8')) ");
        } else {
            if (TrdSpOrderStatus.PART_RETURN.getCode().equalsIgnoreCase(orderQueryDto.getTrdOrderState())){
                sql.append(" and om.after_sale_refund_type = ? ");
                params.add(OrderAfterRefundType.PART_REFUND.getValue());
//                sql.append(" AND OM.AFTER_SALE_STATUS = ?  AND  OM.AFTER_SALE_TYPE not in( "+OrderAfterSaleType.FULL_APPLY.getValue()+" )");
//                params.add(OrderAfterSaleStatus.COMPLETE.getValue());
            }else if (TrdSpOrderStatus.RETURN.getCode().equalsIgnoreCase(orderQueryDto.getTrdOrderState())){
                sql.append(" and om.after_sale_refund_type = ? ");
                params.add(OrderAfterRefundType.FULL_REFUND.getValue());
//                sql.append(" AND OM.AFTER_SALE_STATUS = ?  AND  OM.AFTER_SALE_TYPE = "+ OrderAfterSaleType.FULL_APPLY.getValue());
//                params.add(OrderAfterSaleStatus.COMPLETE.getValue());
            }else{
                sql.append("and om.id in (select so.order_id from mall_order.sub_order so where so.trd_order_state = ?) ");
                params.add(orderQueryDto.getTrdOrderState());
            }
        }
        //订单号
        if (!Lang.isEmpty(orderQueryDto.getOrderNo())) {
            sql.append("and om.order_no = ? ");
            params.add(orderQueryDto.getOrderNo());
        }
        //下单时间
        if (!Lang.isEmpty(orderQueryDto.getBeginTime())) {
            sql.append("and str_to_date(om.create_time, '%Y-%m-%d %H:%i:%s') >= ? ");
            params.add(DateUtils.formatDate(orderQueryDto.getBeginTime(), "yyyy-MM-dd HH:mm:ss"));
        }
        if (!Lang.isEmpty(orderQueryDto.getEndTime())) {
            sql.append("and str_to_date(om.create_time, '%Y-%m-%d %H:%i:%s') <= ? ");
            params.add(DateUtils.formatDate(orderQueryDto.getEndTime(), "yyyy-MM-dd HH:mm:ss"));
        }
        //排序
        sql.append("order by om.create_time desc");
        sqlAndParams.put("sql", sql.toString());
        sqlAndParams.put("params", params);
        return sqlAndParams;
    }

    private Map<String, Object> orderListSqlAndParams(OrderQueryDto orderQueryDto) {
        if (Lang.isEmpty(orderQueryDto.getStoreId())) {
            return null;
        }
        Map<String, Object> params = new HashMap();
        StringBuffer sql = new StringBuffer();
        sql.append(" select ");
        sql.append(" o.order_no as orderno, ");
        sql.append(" so.sub_order_no as suborderno, ");
        sql.append(" o.create_time as createdtime, ");
        sql.append(" o.sum_price as sumcostprice, ");
        sql.append(" o.sum_nofreight_price as sumnofreightprice, ");
        sql.append(" o.recipient_name as recipientname, ");
        sql.append(" o.freight as freight, ");
        sql.append(" o.address_name as addressname, ");
        sql.append(" (select group_concat( ms.shipping_no, ',' ) from mall_goods.mall_shipping ms where ms.order_no = o.order_no group by ms.order_no order by ms.order_no) as logisticsno, ");
        sql.append(" so.trd_order_state as trdorderstate, ");
        sql.append(" o.after_sale_type as aftersaletype, ");
        sql.append(" o.after_sale_status as aftersalestatus , ");
        sql.append(" o.after_sale_refund_type as aftersalerefundtype ");
        sql.append(" from ");
        sql.append(" mall_order.sub_order so left join mall_order.order_main o on so.order_id= o.id  ");
      //  sql.append(" mall_order.order_main o ");
        sql.append(" where ");
       // sql.append(" so.order_id = o.id (+) ");
        // sql.append(" AND 1=1 ");

        //供应商
        sql.append("  o.store_id = :storeid ");
        params.put("storeid", orderQueryDto.getStoreId());
        //订单状态
        if (StringUtils.isNoneEmpty(orderQueryDto.getTrdOrderState())) {
            if (TrdSpOrderStatus.PART_RETURN.getCode().equalsIgnoreCase(orderQueryDto.getTrdOrderState())){

                sql.append(" and o.after_sale_refund_type = :aftersalerefundtype  ");
                params.put("aftersalerefundtype",OrderAfterRefundType.PART_REFUND.getValue());
//                sql.append(" AND o.AFTER_SALE_STATUS = :aftrersalestatus  AND  o.AFTER_SALE_TYPE not in(:aftersaletype)");
//                params.put("aftrersalestatus",OrderAfterSaleStatus.COMPLETE.getValue());
//                params.put("aftersaletype",OrderAfterSaleType.FULL_APPLY.getValue());

            }else if (TrdSpOrderStatus.RETURN.getCode().equalsIgnoreCase(orderQueryDto.getTrdOrderState())){
                sql.append(" and o.after_sale_refund_type = :aftersalerefundtype  ");
                params.put("aftersalerefundtype",OrderAfterRefundType.FULL_REFUND.getValue());
//                sql.append(" AND o.AFTER_SALE_STATUS = :aftrersalestatus  AND  o.AFTER_SALE_TYPE = :aftersaletype ");
//                params.put("aftrersalestatus",OrderAfterSaleStatus.COMPLETE.getValue());
//                params.put("aftersaletype",OrderAfterSaleType.FULL_APPLY.getValue());

            }else{
                sql.append(" and so.trd_order_state = :trdorderstate ");
                params.put("trdorderstate", orderQueryDto.getTrdOrderState());
            }
        }
        //订单号
        if (StringUtils.isNoneEmpty(orderQueryDto.getOrderNo())) {
            sql.append("and o.order_no = :orderno ");
            params.put("orderno", orderQueryDto.getOrderNo());
        }
        //下单时间
        if (!Lang.isEmpty(orderQueryDto.getBeginTime())) {
            sql.append("and str_to_date(o.create_time, '%Y-%m-%d %H:%i:%s') >= :begintime ");
            params.put("begintime", DateUtils.formatDate(orderQueryDto.getBeginTime(), "yyyy-MM-dd HH:mm:ss"));
        }
        if (!Lang.isEmpty(orderQueryDto.getEndTime())) {
            sql.append("and str_to_date(o.create_time, '%Y-%m-%d %H:%i:%s') <= :endtime ");
            params.put("endtime", DateUtils.formatDate(orderQueryDto.getEndTime(), "yyyy-MM-dd HH:mm:ss"));
        }
        //排序
        sql.append(" and o.is_delete='0' order by o.create_time desc");
        Map<String, Object> sqlAndParams = new HashMap<>();
        sqlAndParams.put("sql", String.valueOf(sql));
        sqlAndParams.put("params", params);
        return sqlAndParams;
    }


    public BaseResponse<OrderDetailQueryVo> queryProviderOrdersDetails(String orderNo) {
//        return orderMainQueryApi.queryProviderOrdersDetails(orderNo);
        String BASE_URI = orderServiceUrl + "/orderMain/queryProviderOrdersDetails";
        MultiValueMap<String, String> paramMap = new LinkedMultiValueMap<>();
        paramMap.add("orderNo", orderNo);
        BaseResponse response = restTemplate.postForObject(BASE_URI, paramMap, BaseResponse.class);
        BaseResponse response1 = JSON.parseObject(JSON.toJSONString(response.getResult()), BaseResponse.class);
        OrderDetailQueryVo orderDetailQueryVo = JSON.parseObject(JSON.toJSONString(response1.getResult()), OrderDetailQueryVo.class);
        String BASE_URI2 = orderServiceUrl + "/orderMain/findOrderMainDtoByOrderNo";
        MultiValueMap<String, String> paramMap2 = new LinkedMultiValueMap<>();
        paramMap2.add("orderNo", orderNo);
        RestfulBaseResponse restfulBaseResponse = restTemplate.postForObject(BASE_URI2, paramMap2, RestfulBaseResponse.class);
        if (Lang.isEmpty(restfulBaseResponse) || Lang.isEmpty(restfulBaseResponse.getResult())) {
            throw new IllegalArgumentException("未查询到订单");
        }
        order.dto.OrderMainDto omd;
        try {
            omd = JSON.parseObject(JSON.toJSONString(restfulBaseResponse.getResult()), order.dto.OrderMainDto.class);
        } catch (Exception e) {
            throw new IllegalArgumentException("订单查询异常");
        }
        orderDetailQueryVo.setFeight(omd.getFreight());
        orderDetailQueryVo.setTotalPrice(omd.getSumPrice());
        orderDetailQueryVo.setSumCostPrice(omd.getSumNofreightPrice());
        response.setResult(orderDetailQueryVo);
        response.setSuccess(true);
        return response;

    }

    public BaseResponse<PageVo<OrdersQueryVo>> queryProviderOrdersPage(JqueryDataTablesVo jqueryDataTablesVo, OrderQueryDto orderQueryDto) {
        int pageindex = jqueryDataTablesVo.getiDisplayStart() / jqueryDataTablesVo.getiDisplayLength();
        Pageable pageable = new PageRequest(pageindex, jqueryDataTablesVo.getiDisplayLength());
        int size = pageable.getPageSize();
        int number = pageable.getPageNumber();
        try {
            Map<String, Object> sqlAndParams = orderListSqlAndParams(orderQueryDto);
            PageVo<OrdersQueryVo> ordersQueryVoPageVo = jdbcTemplatePage
                    .query((String) sqlAndParams.get("sql"), OrdersQueryVo.class, ++number, size, (Map<String, Object>) sqlAndParams.get("params"));
            for (OrdersQueryVo ordersQueryVo : ordersQueryVoPageVo.getResult()) {
                if(StringUtils.isNotBlank(ordersQueryVo.getLogisticsNo())) {
                    if(ordersQueryVo.getLogisticsNo().lastIndexOf(",") == ordersQueryVo.getLogisticsNo().length() - 1) {
                        ordersQueryVo.setLogisticsNo(ordersQueryVo.getLogisticsNo().substring(0, ordersQueryVo.getLogisticsNo().length() - 1));
                    }
                }
              if (StringUtils.isNotBlank(ordersQueryVo.getAfterSaleRefundType())) {
                    String afterSaleStatusName = null;
                    if (OrderAfterRefundType.PART_REFUND.getValue().equalsIgnoreCase(ordersQueryVo.getAfterSaleRefundType())) {
                        afterSaleStatusName = "部分退款";
                    }else if (OrderAfterRefundType.FULL_REFUND.getValue().equalsIgnoreCase(ordersQueryVo.getAfterSaleRefundType())) {
                        afterSaleStatusName = "已退款";
                    }
                    ordersQueryVo.setAfterSaleStatusName(afterSaleStatusName);
                }

                ordersQueryVo.setIfAfterSaling(StringUtils.isNotBlank(ordersQueryVo.getAfterSaleStatus()) ? (OrderAfterSaleStatus.APPLYING.getValue().equals(ordersQueryVo.getAfterSaleStatus()) ? "是" : "否") : "否");
            }
            return new BaseResponse(true, "成功", ordersQueryVoPageVo);
        } catch (Exception e) {
            log.error("列表查询异常", e);
            return new BaseResponse(false, "失败");
        }
    }

    public PageVo findOrderInfo(Pageable pageable, Map<String, Object> map) {
        return null;
    }

    public void checkBatchExcelOut(ServletOutputStream out) {
        try {
            hwbBatch = new SXSSFWorkbook();
            hwbBatch = checkDownBatch();
            hwbBatch.write(out);
            out.flush();
            out.close();
            hwbBatch.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public SXSSFWorkbook checkDownBatch() {
        SXSSFWorkbook hwb = new SXSSFWorkbook();
        //sheet1
        SXSSFSheet sheet = hwb.createSheet("订单批量添加物流模板");
        //创建第一行并设置行高
        SXSSFRow row = sheet.createRow(0);
        row.setHeight((short) 600);
        //设置字体
        Font font = hwb.createFont();
        font.setFontName("宋体");
        font.setFontHeightInPoints((short) 12);
        DataFormat format = hwb.createDataFormat();
        //设置单元格格式
        CellStyle style = hwb.createCellStyle();
        style.setFont(font);
        style.setDataFormat(format.getFormat("@"));  //设置输入格式为文本格式
        style.setAlignment(HorizontalAlignment.CENTER);
        style.setVerticalAlignment(VerticalAlignment.CENTER);
        style.setWrapText(true);
        //设置单元格内容
        int columnCount = titlesBatch.length;
        for (int i = 0; i < columnCount; i++) {
            SXSSFCell cell = row.createCell(i);
            cell.setCellStyle(style);
            cell.setCellValue(new XSSFRichTextString(titlesBatch[i]));
            sheet.setColumnWidth(i, 8000);
            sheet.setDefaultColumnStyle(i, style);
        }

        //sheet2
        SXSSFSheet sheet2 = hwb.createSheet("物流公司列表");
        //创建第一行并设置行高
        SXSSFRow row2 = sheet2.createRow(0);
        row2.setHeight((short) 600);
        //设置单元格内容
        int columnCount2 = titlesBatch2.length;
        for (int i = 0; i < columnCount2; i++) {
            SXSSFCell cell2 = row2.createCell(i);
            cell2.setCellStyle(style);
            cell2.setCellValue(new XSSFRichTextString(titlesBatch2[i]));
            sheet2.setColumnWidth(i, 8000);
            sheet2.setDefaultColumnStyle(i, style);
        }
        Map<String, List<LogisticCompanyDto>> logisticsCompanyNameKeyMap = logisticsCompanyApi.findUsAbleLogisticsCompanyNameKeyMap();
        List<String> logisticsCompanyName = new ArrayList<>(logisticsCompanyNameKeyMap.keySet());
        int size = logisticsCompanyName.size();
        for (int i = 1; i <= size; i++) {
            SXSSFRow row2_1 = sheet2.createRow(i);
            SXSSFCell cell2 = row2_1.createCell(0);
            cell2.setCellStyle(style);
            cell2.setCellValue(new XSSFRichTextString(logisticsCompanyName.get(i - 1)));
            sheet2.setColumnWidth(i, 8000);
            sheet2.setDefaultColumnStyle(i, style);
        }

        return hwb;
    }

    public List<ShippingBatchImportDto> batchImportExcel(List<ShippingBatchImportDto> importDtos, String storeId) {
        if (CollectionUtil.isEmpty(importDtos)) {
            return null;
        }
        Map<String, List<ShippingBatchImportDto>> collect = importDtos.stream()
                .filter(importDto -> StringUtils.isNoneEmpty(importDto.getOrderNo()))
                .collect(Collectors.groupingBy(ShippingBatchImportDto::getOrderNo));

        List<ShippingBatchImportDto> collectOrderNoNull = importDtos.stream()
                .filter(importDto -> StringUtils.isEmpty(importDto.getOrderNo()))
                .collect(Collectors.toList());

        List<ShippingBatchImportDto> returnList = new ArrayList<>();
        returnList.addAll(collectOrderNoNull);

        collectOrderNoNull.forEach(dto -> {
            dto.setSuccess(false);
            dto.setMsg("请填写订单号");
        });

        List<String> orderNos = new ArrayList<>(collect.keySet());
        List<String> orderNoParams = Collections.synchronizedList(new ArrayList<>());
        orderNos.parallelStream().forEach(o -> {
            StringBuffer sb = new StringBuffer();
            sb.append("'").append(o).append("'");
            orderNoParams.add(sb.toString());
        });
        //校验订单状态是否是已确认
        if (CollectionUtil.isEmpty(orderNoParams)) {
            return returnList;
        }

        StringBuffer successSql = new StringBuffer();
        StringBuffer errorSql = new StringBuffer();
        successSql.append(" select distinct om.order_no ");
        successSql.append(" from mall_order.order_main om, mall_order.sub_order so ");
        successSql.append(" where om.id = so.order_id ");
        successSql.append(" and so.trd_order_state = 7 ");
        //订单全部售后成功[退款成功] 不能导入物流信息。
//        successSql.append(" and ( om.AFTER_SALE_TYPE  not in (2) )");
        successSql.append(" and om.order_no in (" + String.join(",", orderNoParams) + ") ");
        errorSql.append(" select distinct om.order_no ");
     /*   errorSql.append(" from mall_order.order_main om, mall_order.sub_order so ");
        errorSql.append(" where om.id = so.order_id(+) ");
        //订单全部售后成功[退款成功] 不能导入物流信息。
//        errorSql.append(" and ( om.AFTER_SALE_TYPE in (2) )");
        errorSql.append(" and (so.trd_order_state != 7 or so.id is null ) ");*/
        errorSql.append(" from mall_order.order_main om left join mall_order.sub_order so  on om.id = so.order_id");
        errorSql.append(" where ( so.trd_order_state != 7 OR so.id IS NULL ) ");
        errorSql.append(" and om.order_no in (" + String.join(",", orderNoParams) + ") ");
        List<String> successOrderNo = jdbcTemplate.queryForList(successSql.toString(), String.class);
        List<String> errorOrderNo = jdbcTemplate.queryForList(errorSql.toString(), String.class);
        List<ShippingBatchImportDto> successOrderNoImportDtos = Collections.synchronizedList(new ArrayList<>());
        successOrderNo.forEach(orderNo -> {
            successOrderNoImportDtos.addAll(collect.get(orderNo));
        });
        List<ShippingBatchImportDto> errorOrderNoImportDtos = Collections.synchronizedList(new ArrayList<>());
        errorOrderNo.forEach(orderNo -> {
            errorOrderNoImportDtos.addAll(collect.get(orderNo));
        });
        List<ShippingBatchImportDto> errorOrderNoReturnList = Collections.synchronizedList(new ArrayList<>());
        errorOrderNoImportDtos.parallelStream().forEach(dto -> {
            dto.setSuccess(false);
            dto.setMsg("此订单非已确认状态");
            errorOrderNoReturnList.add(dto);
        });
        //获取物流公司详情
        Map<String, List<LogisticCompanyDto>> logisticCompanyNameMap = logisticsCompanyApi.findUsAbleLogisticsCompanyNameKeyMap();
        List<ShippingBatchImportDto> successOrderNoReturnList = Collections.synchronizedList(new ArrayList<>());
        successOrderNoImportDtos.parallelStream().forEach(dto -> {
            if (StringUtils.isEmpty(dto.getLogisticCompanyName())) {
                dto.setSuccess(false);
                dto.setMsg("请填写物流公司");
                errorOrderNoReturnList.add(dto);
                return;
            }
            String logisticCompanyName = dto.getLogisticCompanyName();
            List<LogisticCompanyDto> logisticCompanyDtoList = logisticCompanyNameMap.get(logisticCompanyName);
            if (CollectionUtil.isEmpty(logisticCompanyDtoList)) {
                dto.setSuccess(false);
                dto.setMsg("未查询到物流公司");
                errorOrderNoReturnList.add(dto);
                return;
            }
            LogisticCompanyDto logisticCompanyDto = logisticCompanyDtoList.get(NumberCommonUtils.ZERO.getValue());
            MallShippingVo mallShippingVo = new MallShippingVo();
            if (StringUtils.isEmpty(dto.getOrderNo())) {
                dto.setSuccess(false);
                dto.setMsg("请填写订单号");
                errorOrderNoReturnList.add(dto);
                return;
            }
            mallShippingVo.setOrderNo(dto.getOrderNo());
            mallShippingVo.setShippingType("快递");
            if (StringUtils.isEmpty(logisticCompanyDto.getFullName())) {
                dto.setSuccess(false);
                dto.setMsg("系统数据异常,未获取到物流公司全称");
                errorOrderNoReturnList.add(dto);
                return;
            } else if (StringUtils.isEmpty(logisticCompanyDto.getSimpleName())) {
                dto.setSuccess(false);
                dto.setMsg("系统数据异常,未获取到物流公司简称");
                errorOrderNoReturnList.add(dto);
                return;
            }
            mallShippingVo.setShippingCompany(logisticCompanyDto.getFullName());
            mallShippingVo.setShippingCode(logisticCompanyDto.getSimpleName());
            if (StringUtils.isEmpty(dto.getShippingNo())) {
                dto.setSuccess(false);
                dto.setMsg("请填写物流单号");
                errorOrderNoReturnList.add(dto);
                return;
            }
            mallShippingVo.setShippingNo(dto.getShippingNo());
            //mallShippingVo.setRemark();
            BaseResponse response;
            try {
                response = mallShippingApi.addMallShipping(mallShippingVo);
            } catch (Exception e) {
                log.info("OrderService.batchImportExcel--", e);
                dto.setSuccess(false);
                dto.setMsg("导入失败！系统异常！");
                errorOrderNoReturnList.add(dto);
                return;
            }
            dto.setSuccess(response.isSuccess());
            if (response.isSuccess()) {
                dto.setMsg("导入成功！");
                successOrderNoReturnList.add(dto);
            } else {
                dto.setMsg("导入失败！系统异常！");
                errorOrderNoReturnList.add(dto);
            }
        });
        List<String> sOrderNo = successOrderNoReturnList.stream()
                .filter(dto -> StringUtils.isNoneEmpty(dto.getOrderNo()))
                .map(dto -> dto.getOrderNo())
                .collect(Collectors.toList());
        setSubOrderDelivered(sOrderNo, storeId);

        returnList.addAll(successOrderNoReturnList);
        returnList.addAll(errorOrderNoReturnList);
        List<ShippingBatchImportDto> errorList = importDtos.stream()
                .filter(dto -> Lang.isEmpty(dto.getSuccess()) && StringUtils.isEmpty(dto.getMsg()))
                .collect(Collectors.toList());
        errorList.forEach(dto -> {
            dto.setSuccess(false);
            dto.setMsg("未查询到该订单");
        });
        returnList.addAll(errorList);
        return returnList;
    }

    private void setSubOrderDelivered(List<String> orderNos, String storeId) {
        if (CollectionUtil.isEmpty(orderNos)) {
            return;
        }
        List<String> orderNoParams = Collections.synchronizedList(new ArrayList<>());
        orderNos.parallelStream().forEach(o -> {
            StringBuffer sb = new StringBuffer();
            sb.append("'").append(o).append("'");
            orderNoParams.add(sb.toString());
        });
        StringBuffer sql = new StringBuffer();
        sql.append(" select distinct so.sub_order_no ");
        sql.append(" from mall_order.order_main om, mall_order.sub_order so ");
        sql.append(" where om.id = so.order_id ");
        sql.append(" and om.order_no in (" + String.join(",", orderNoParams) + ") ");
        List<String> subOrderNos = jdbcTemplate.queryForList(sql.toString(), String.class);
        subOrderNos.forEach(subOrderNo -> {
            subOrderApi.setSubOrderDelivered(subOrderNo, storeId);
        });
    }

    public ResponseEntity<byte[]> downloadReturnList(List<ShippingBatchImportDto> shippingBatchImportDtos) {
        ResponseEntity<byte[]> responseEntity = null;
        try {
            List<List<Object>> rows = getRows(shippingBatchImportDtos);
            String fileName = "store_admin_addMallShipping.xlsx";
            ByteArrayOutputStream byteArrayOutputStream = excelUtils.excelForSXSSFWorkbook(fileName, rows);
            String downFileName = java.net.URLEncoder.encode("订单批量添加物流导入结果.xlsx", "UTF-8");
            //设置响应头让浏览器正确显示下载
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
            headers.setContentDispositionFormData("attachment", downFileName);
            responseEntity = new ResponseEntity<>(byteArrayOutputStream.toByteArray(), headers, HttpStatus.OK);
        } catch (UnsupportedEncodingException e) {
            log.info("OrderService.downloadReturnList", e);
        }
        return responseEntity;
    }

    private List<List<Object>> getRows(List<ShippingBatchImportDto> shippingBatchImportDtos) {
        //EXCEL列
        List<List<Object>> rows = new ArrayList<>();
        //从给定数据获取指定列作为EXCEL列数据
        for (ShippingBatchImportDto importDto : shippingBatchImportDtos) {
            List<Object> row = new ArrayList<>();
            //订单号
            row.add(importDto.getOrderNo());
            //物流公司
            row.add(importDto.getLogisticCompanyName());
            //物流单号
            row.add(importDto.getShippingNo());
            //导入结果
            row.add(importDto.getMsg());
            rows.add(row);
        }
        return rows;
    }

}
