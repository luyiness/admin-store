package store.admin.vo.aftersale.resp;

import com.alibaba.fastjson.annotation.JSONField;
import com.fasterxml.jackson.annotation.JsonFormat;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
@ApiModel(value = "AfterSaleManagerResp", description = "运营后台-售后管理条件查询返回参数")
public class AfterSaleManagerForStAResp implements Serializable {
    /**
     * 申请单号
     */
    @ApiModelProperty(value = "1.申请单号", position = 1, example = "")
    private  String serviceNo;
    /**
     * 订单号
     */
    @ApiModelProperty(value = "2.订单号", position = 2, example = "")
    private String orderNo;
    /**
     * 申请时间
     */
    @ApiModelProperty(value = "3.申请时间", position = 3, example = "2020-05-20 12:12:12")
    @JSONField(format = "yyyy-MM-dd HH:mm:ss")
    @JsonFormat(locale = "zh", timezone = "GMT+8", pattern = "yyyy-MM-dd HH:mm:ss")
    private Date dateCreated;

    @ApiModelProperty(value = "4.手机号", position = 4, example = "13100562356")
    private String userPhone;
    /**
     * 商品名称
     */
    @ApiModelProperty(value = "5.商品名称", position = 5, example = "樱花气泡水")
    private String title;
    /**
     * 商品编码
     */
    @ApiModelProperty(value = "6.商品编码", position = 6, example = "10555688977")
    private String sku;

    /**
     * 商品价格
     */
    @ApiModelProperty(value = "7.商品价格", position = 7, example = "236.30")
    private BigDecimal salePrice;

    @ApiModelProperty(value = "8. 商品数量", position = 7, example = "236.30")
    private Integer count;

    @ApiModelProperty(value = "9.积分抵扣金额", position = 9, example = "236.30")
    private BigDecimal scoreMoney;

    @ApiModelProperty(value = "10.优惠券抵扣", position = 10, example = "236.30")
    private BigDecimal couponMoney;

    @ApiModelProperty(value = "11.实付金额", position = 11, example = "236.30")
    private BigDecimal perMoney;

    @ApiModelProperty(value = "12.退款金额", position = 12, example = "236.30")
    private BigDecimal refundAmount;

    @ApiModelProperty(value = "13.实际退款金额", position = 13, example = "236.30")
    private BigDecimal actualRefundAmount;


    @ApiModelProperty(value = "14.售后类型", position = 14, example = "0、1")
    private String afterSaleType;

    @ApiModelProperty(value = "15.售后单状态", position = 14, example = "0、1")
    private String status;









}
