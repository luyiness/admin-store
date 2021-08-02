package store.admin.service;

import aftersale.api.difinication.AfterSaleStatus;
import aftersale.api.dto.aftersalemanage.AfterSaleResp;
import aftersale.api.dto.orderaftersale.req.UpdateOrderAfterSaleStatusReq;
import aftersale.model.aftersalemanage.AfterSale;
import lombok.extern.slf4j.Slf4j;
import order.dto.financialvoucher.VoucherInfoEnum;
import order.dto.financialvoucher.VoucherInfosReq;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import sinomall.config.response.RestfulBaseResponse;
import store.admin.feign.AfterSaleFeign;
import store.admin.feign.OrderAfterSaleServiceFeign;
import store.admin.vo.aftersale.req.UpdateAfterSaleStatusCheckReq;
import store.admin.vo.aftersale.resp.AfterSaleExportForStAResp;
import utils.Lang;
import utils.date.DateUtils;
import utils.excel.ExcelUtil;
import utils.jms.ActiveMqUtil;

import java.io.ByteArrayOutputStream;
import java.util.*;

@Component
@Slf4j
public class AfterSaleService {

    @Autowired
    AfterSaleFeign afterSaleFeign;

    @Autowired
    OrderAfterSaleServiceFeign orderAfterSaleServiceFeign;
    @Autowired
    private ActiveMqUtil rabbitMqUtil;
    /**
     * 确认审核
     *
     * @param updateAfterSaleStatusCheckReq
     * @return
     */
    public RestfulBaseResponse<Boolean> updateAfterSaleStatus(UpdateAfterSaleStatusCheckReq updateAfterSaleStatusCheckReq) {

        RestfulBaseResponse<AfterSaleResp> afterSaleResp = afterSaleFeign.findByServiceNoForStA(updateAfterSaleStatusCheckReq.getServiceNo());
        if (RestfulBaseResponse.SUCCESS_CODE.equals(afterSaleResp.getCode()) && afterSaleResp.getResult() != null && AfterSaleStatus.NEW.getCode().equals(afterSaleResp.getResult().getStatus())) {
            AfterSaleResp afterSale = afterSaleResp.getResult();
            updateAfterSaleStatusCheckReq.setId(afterSale.getId());
            //退款
            if (AfterSale.AFTERSALE_REFUND.equals(afterSale.getType())) {
                if (updateAfterSaleStatusCheckReq.getFlag()) {
                    //退款:同意退款，变成待退款状态
                    updateAfterSaleStatusCheckReq.setStatus(AfterSaleStatus.WAIT_REFUND.getCode());
                } else {
                    //供应商拒绝
                    updateAfterSaleStatusCheckReq.setStatus(AfterSaleStatus.CLOSE_SUPPLIER_REFUSED.getCode());
                }
            }
            //退货退款/换货
            if (!(AfterSale.AFTERSALE_REFUND.equals(afterSale.getType()))) {
                if (updateAfterSaleStatusCheckReq.getFlag()) {
                    //退货退款/换货--->供应商同意 变成用户待寄出状态
                    updateAfterSaleStatusCheckReq.setStatus(AfterSaleStatus.WAIT_USER_SEND_OUT.getCode());
                } else {
                    //退货退款/换货-->供应商拒绝 售后单关闭
                    updateAfterSaleStatusCheckReq.setStatus(AfterSaleStatus.CLOSE_SUPPLIER_REFUSED.getCode());
                }
            }

            RestfulBaseResponse<Boolean> restfulBaseResponse = afterSaleFeign.updateAfterSaleStatus(updateAfterSaleStatusCheckReq);

            if (RestfulBaseResponse.SUCCESS_CODE.equals(restfulBaseResponse.getCode()) && restfulBaseResponse.getResult() != null && restfulBaseResponse.getResult()) {
                //调用小胖的接口 修改订单的状态 执行的前提就是在前面执行之后
                UpdateOrderAfterSaleStatusReq updateOrderAfterSaleStatusReq = new UpdateOrderAfterSaleStatusReq();
                updateOrderAfterSaleStatusReq.setAfterSaleNo(updateAfterSaleStatusCheckReq.getServiceNo());
                orderAfterSaleServiceFeign.updateOrderAfterSaleStatus(updateOrderAfterSaleStatusReq);
            }
            return restfulBaseResponse;
        }
        return RestfulBaseResponse.success(false);
    }

    public RestfulBaseResponse<Boolean> updateAfterSaleForReceive(String serviceNo) {
        RestfulBaseResponse<AfterSaleResp> afterSaleResp = afterSaleFeign.findByServiceNoForStA(serviceNo);
        if (RestfulBaseResponse.SUCCESS_CODE.equals(afterSaleResp.getCode()) && afterSaleResp.getResult() != null && AfterSaleStatus.WAIT_SUPPLIER_RECEIVE.getCode().equals(afterSaleResp.getResult().getStatus())) {
            AfterSaleResp afterSale = afterSaleResp.getResult();

            UpdateAfterSaleStatusCheckReq updateAfterSaleStatusCheckReq = new UpdateAfterSaleStatusCheckReq();
            updateAfterSaleStatusCheckReq.setServiceNo(serviceNo);
            updateAfterSaleStatusCheckReq.setId(afterSale.getId());

            //退货
            if ("1".equals(afterSale.getType())) {
                //待客服退款
                updateAfterSaleStatusCheckReq.setStatus(AfterSaleStatus.WAIT_REFUND.getCode());
            }
            //换货
            if ("2".equals(afterSale.getType())) {
                //待供应商寄出商品  暂时没有此状态  ======二期做
//                updateAfterSaleStatusCheckReq.setStatus(AfterSale.TO_BE_SENT_BY_BUSINESS);
            }
            RestfulBaseResponse<Boolean> restfulBaseResponse = afterSaleFeign.updateAfterSaleForReceive(updateAfterSaleStatusCheckReq);
            if (RestfulBaseResponse.SUCCESS_CODE.equals(restfulBaseResponse.getCode()) && restfulBaseResponse.getResult() != null && restfulBaseResponse.getResult()) {
                //调用小胖的接口 修改订单的状态 执行的前提就是在前面执行之后
                UpdateOrderAfterSaleStatusReq updateOrderAfterSaleStatusReq = new UpdateOrderAfterSaleStatusReq();
                updateOrderAfterSaleStatusReq.setAfterSaleNo(updateAfterSaleStatusCheckReq.getServiceNo());
                orderAfterSaleServiceFeign.updateOrderAfterSaleStatus(updateOrderAfterSaleStatusReq);
                // 财务凭证埋点 发送MQ消息，记录凭证
                log.info("商城凭证-财务凭证埋点发送MQ消息记录凭证,serviceNos={}",updateAfterSaleStatusCheckReq.getServiceNo());
                List<String> serviceNos=new ArrayList<>(16);
                serviceNos.add(updateAfterSaleStatusCheckReq.getServiceNo());
                rabbitMqUtil.senQueue(VoucherInfosReq.MALL_VOUCHER_CREATE, VoucherInfosReq.voucherInfosReqForServiceNos(new Date(),
                        VoucherInfoEnum.SCENE_VOUCHER_RETURNREFUND.getCode(),serviceNos));
            }
            return restfulBaseResponse;
        }
        return RestfulBaseResponse.success(false);
    }


    //下载
    public byte[] downloadExcel(List<AfterSaleExportForStAResp> afterSaleExportForStAResps) {

        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
        List<String> title = Arrays.asList(new String[]{"序号", "申请单号", "订单号", "申请时间", "用户手机号", "商品名称", "商品编码", "商品价格", "商品数量", "积分抵扣金额", "优惠券抵扣", "实付金额", "应退金额", "实际退款金额", "售后类型", "售后状态"});
        Workbook workbook = null;
        try {
            workbook = new XSSFWorkbook();
            Sheet sheet = workbook.createSheet();
            ExcelUtil.createHeader(sheet, title);

            Integer gindexStartRow = null, gindexColumn = 0;
            Integer serviceNoStartRow = null, serviceNoColumn = 1;
            Integer orderNoStartRow = null, orderNoColumn = 2;
            Integer dateCreatedStartRow = null, dateCreatedColumn = 3;
            Integer userPhoneStartRow = null, userPhoneColumn = 4;
            Integer nameStartRow = null, nameColumn = 5;
            Integer skuStartRow = null, skuColumn = 6;
            Integer salePriceStartRow = null, salePriceColumn = 7;
            Integer countStartRow = null, countColumn = 8;
            Integer scoreMoneyStartRow = null, scoreMoneyColumn = 9;
            Integer couponMoneyStartRow = null, couponMoneyColumn = 10;
            Integer perMoneyStartRow = null, perMoneyColumn = 11;
            Integer refundAmountStartRow = null, refundAmountColumn = 12;
            Integer actualRefundAmountStartRow = null, actualRefundAmountColumn = 13;
            Integer afterSaleTypeStartRow = null, afterSaleTypeColumn = 14;
            Integer statusStartRow = null, statusColumn = 15;

            String gindexPrevious = null;
            String serviceNoPrevious = null;
            String orderNoPrevious = null;
            String dateCreatedPrevious = null;
            String userPhonePrevious = null;
            String namePrevious = null;
            String skuPrevious = null;
            String salePricePrevious = null;
            String countPrevious = null;
            String scoreMoneyPrevious = null;
            String couponMoneyPrevious = null;
            String perMoneyPrevious = null;
            String refundAmountPrevious = null;
            String actualRefundAmountPrevious = null;
            String afterSaleTypePrevious = null;
            String statusPrevious = null;

            CellStyle cellStyle = ExcelUtil.createValueCellStyle(workbook);
            for (int i = 0, rowIndex = 1; i < afterSaleExportForStAResps.size(); i++, rowIndex++) {
                Row row = sheet.createRow(rowIndex);
                row.setHeightInPoints(25);
                Map<String, Object> returnMap;
                AfterSaleExportForStAResp productBrandDto = afterSaleExportForStAResps.get(i);

                //序号
                returnMap = createOrMargedCell(sheet, row, cellStyle, rowIndex, rowIndex + "", gindexPrevious, gindexStartRow, gindexColumn, false);
                gindexPrevious = (String) returnMap.get("previousValue");
                gindexStartRow = (Integer) returnMap.get("startRow");

                //serviceNo
                String serviceNo = lang(productBrandDto.getServiceNo());
                returnMap = createOrMargedCell(sheet, row, cellStyle, rowIndex, serviceNo, serviceNoPrevious, serviceNoStartRow, serviceNoColumn, false);
                serviceNoPrevious = (String) returnMap.get("previousValue");
                serviceNoStartRow = (Integer) returnMap.get("startRow");

                //orderNo
                String orderNo = lang(productBrandDto.getOrderNo());
                returnMap = createOrMargedCell(sheet, row, cellStyle, rowIndex, orderNo, orderNoPrevious, orderNoStartRow, orderNoColumn, false);
                orderNoPrevious = (String) returnMap.get("previousValue");
                orderNoStartRow = (Integer) returnMap.get("startRow");

                //申请时间
                String dateCreated = DateUtils.toString(productBrandDto.getDateCreated(), "yyyy-MM-dd HH:mm:ss");
                returnMap = createOrMargedCell(sheet, row, cellStyle, rowIndex, dateCreated, dateCreatedPrevious, dateCreatedStartRow, dateCreatedColumn, false);
                dateCreatedPrevious = (String) returnMap.get("previousValue");
                dateCreatedStartRow = (Integer) returnMap.get("startRow");

                //用户手机号
                String userPhone = productBrandDto.getUserPhone();
                returnMap = createOrMargedCell(sheet, row, cellStyle, rowIndex, userPhone, userPhonePrevious, userPhoneStartRow, userPhoneColumn, false);
                userPhonePrevious = (String) returnMap.get("previousValue");
                userPhoneStartRow = (Integer) returnMap.get("startRow");

                //商品titile
                String name = productBrandDto.getTitle();
                returnMap = createOrMargedCell(sheet, row, cellStyle, rowIndex, name, namePrevious, nameStartRow, nameColumn, false);
                namePrevious = (String) returnMap.get("previousValue");
                nameStartRow = (Integer) returnMap.get("startRow");

                //商品sku
                String sku = productBrandDto.getSku();
                returnMap = createOrMargedCell(sheet, row, cellStyle, rowIndex, sku, skuPrevious, skuStartRow, skuColumn, false);
                skuPrevious = (String) returnMap.get("previousValue");
                skuStartRow = (Integer) returnMap.get("startRow");

                //商品salePrice
                String salePrice = productBrandDto.getSalePrice() == null ? "" : productBrandDto.getSalePrice() + "";
                returnMap = createOrMargedCell(sheet, row, cellStyle, rowIndex, salePrice, salePricePrevious, salePriceStartRow, salePriceColumn, false);
                salePricePrevious = (String) returnMap.get("previousValue");
                salePriceStartRow = (Integer) returnMap.get("startRow");

                //商品count
                String count = productBrandDto.getCount() + "";
                returnMap = createOrMargedCell(sheet, row, cellStyle, rowIndex, count, countPrevious, countStartRow, countColumn, false);
                countPrevious = (String) returnMap.get("previousValue");
                countStartRow = (Integer) returnMap.get("startRow");

                //商品scoreMoney
                String scoreMoney = productBrandDto.getScoreMoney() == null ? "" : productBrandDto.getScoreMoney() + "";
                returnMap = createOrMargedCell(sheet, row, cellStyle, rowIndex, scoreMoney, scoreMoneyPrevious, scoreMoneyStartRow, scoreMoneyColumn, false);
                scoreMoneyPrevious = (String) returnMap.get("previousValue");
                scoreMoneyStartRow = (Integer) returnMap.get("startRow");

                //优惠券金额couponMoney
                String couponMoney = productBrandDto.getCouponMoney() == null ? "" : productBrandDto.getCouponMoney() + "";
                returnMap = createOrMargedCell(sheet, row, cellStyle, rowIndex, couponMoney, couponMoneyPrevious, couponMoneyStartRow, couponMoneyColumn, false);
                couponMoneyPrevious = (String) returnMap.get("previousValue");
                couponMoneyStartRow = (Integer) returnMap.get("startRow");


                //perMoney
                String perMoney = productBrandDto.getPerMoney() == null ? "" : productBrandDto.getPerMoney() + "";
                returnMap = createOrMargedCell(sheet, row, cellStyle, rowIndex, perMoney, perMoneyPrevious, perMoneyStartRow, perMoneyColumn, false);
                perMoneyPrevious = (String) returnMap.get("previousValue");
                perMoneyStartRow = (Integer) returnMap.get("startRow");

                //refundAmount
                String refundAmount = productBrandDto.getRefundAmount() == null ? "" : productBrandDto.getRefundAmount() + "";
                returnMap = createOrMargedCell(sheet, row, cellStyle, rowIndex, refundAmount, refundAmountPrevious, refundAmountStartRow, refundAmountColumn, false);
                refundAmountPrevious = (String) returnMap.get("previousValue");
                refundAmountStartRow = (Integer) returnMap.get("startRow");

                //actualRefundAmount
                String actualRefundAmount = productBrandDto.getActualRefundAmount() == null ? "" : productBrandDto.getActualRefundAmount() + "";
                returnMap = createOrMargedCell(sheet, row, cellStyle, rowIndex, actualRefundAmount, actualRefundAmountPrevious, actualRefundAmountStartRow, actualRefundAmountColumn, false);
                actualRefundAmountPrevious = (String) returnMap.get("previousValue");
                actualRefundAmountStartRow = (Integer) returnMap.get("startRow");

                //售后类型afterSaleType
                String type = lang(productBrandDto.getAfterSaleType());
                String afterSaleType = "";
                if (!Lang.isEmpty(type)) {
                    if ("0".equals(type)) {
                        afterSaleType = "退款";
                    } else if ( "1".equals(type)) {
                        afterSaleType = "退货退款";
                    } else if ("2".equals(type)) {
                        afterSaleType = "换货";
                    }
                }
                returnMap = createOrMargedCell(sheet, row, cellStyle, rowIndex, afterSaleType, afterSaleTypePrevious, afterSaleTypeStartRow, afterSaleTypeColumn, false);
                afterSaleTypePrevious = (String) returnMap.get("previousValue");
                afterSaleTypeStartRow = (Integer) returnMap.get("startRow");

                //售后单状态
                String status = lang(productBrandDto.getStatus());
                String afterStatus = "";
                if (!Lang.isEmpty(status)) {
                    afterStatus = AfterSaleStatus.afterSaleStatusMap.get(status).getDescription();
                }
                returnMap = createOrMargedCell(sheet, row, cellStyle, rowIndex, afterStatus, statusPrevious, statusStartRow, statusColumn, false);
                statusPrevious = (String) returnMap.get("previousValue");
                statusStartRow = (Integer) returnMap.get("startRow");

            }
            for (int i = 0; i < title.size(); i++) {
                sheet.autoSizeColumn(i, true);
            }
            workbook.write(byteArrayOutputStream);
            byteArrayOutputStream.flush();
            byteArrayOutputStream.close();
        } catch (Exception e) {
            log.error("导出异常", e);
        } finally {
            try {
                if (Lang.isEmpty(workbook)) {
                    workbook.close();
                }
            } catch (Exception e) {
                log.error(String.valueOf(e));
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

    private String lang(String s) {
        return Lang.isEmpty(s) ? "" : s;
    }


}
