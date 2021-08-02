package store.admin.vo.aftersale.resp;

import com.alibaba.excel.annotation.ExcelProperty;
import com.alibaba.fastjson.annotation.JSONField;
import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
@EqualsAndHashCode(callSuper = false)
public class AfterSaleExportForStAResp implements Serializable {

    /**
     * 申请单号
     */
    @ExcelProperty(value = "申请单号")
    private String serviceNo;
    /**
     * 订单号
     */
    @ExcelProperty(value = "订单号")
    private String orderNo;
    /**
     * 申请时间
     */
    @ExcelProperty(value = "申请时间")
    @JSONField(format = "yyyy-MM-dd HH:mm:ss")
    @JsonFormat(locale = "zh", timezone = "GMT+8", pattern = "yyyy-MM-dd HH:mm:ss")
    private Date dateCreated;

    @ExcelProperty(value = "用户手机号")
    private String userPhone;
    /**
     * 商品名称
     */
    @ExcelProperty(value = "商品名称")
    private String title;
    /**
     * 商品编码
     */
    @ExcelProperty(value = "商品编码")
    private String sku;

    /**
     * 商品价格
     */
    @ExcelProperty(value = "商品价格")
    private BigDecimal salePrice;

    @ExcelProperty(value = "商品数量")
    private Integer count;

    @ExcelProperty(value = "积分抵扣金额")
    private BigDecimal scoreMoney;

    @ExcelProperty(value = "优惠券抵扣")
    private BigDecimal couponMoney;

    @ExcelProperty(value = "实付金额")
    private BigDecimal perMoney;

    @ExcelProperty(value = "退款金额")
    private BigDecimal refundAmount;

    @ExcelProperty(value = "实际退款金额")
    private BigDecimal actualRefundAmount;

    @ExcelProperty(value = "售后类型")
    private String afterSaleType;

    @ExcelProperty(value = "售后单状态")
    private String status;


}
