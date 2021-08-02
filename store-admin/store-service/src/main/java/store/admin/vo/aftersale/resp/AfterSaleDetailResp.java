package store.admin.vo.aftersale.resp;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;


@Data
@ToString
@NoArgsConstructor
@AllArgsConstructor
@ApiModel(value = "AfterSaleDetailResp", description = "运营后台-售后详情")
public class AfterSaleDetailResp {

    @ApiModelProperty(value = "id", position = 1, example = "")
    private String id;

    /***
     * 售后服务单号
     */
    @ApiModelProperty(value = "2.售后服务单号", position = 2, example = "")
    private String servieNo;
    /**
     * 售后主表id
     */
    @ApiModelProperty(value = "3.售后主表id", position = 3, example = "")
    private String afterSaleId;
    /**
     * 关联订单项id;
     */
    @ApiModelProperty(value = "4.关联订单项id", position = 4, example = "")
    private String orderItemId;

    /***
     * 申请数量
     */
    @ApiModelProperty(value = "5.申请数量", position = 5, example = "")
    private Integer goodsCount;
    /**
     * 申请原因
     */
    @ApiModelProperty(value = "6.申请原因", position = 6, example = "")
    private String reasons;

    /**
     * 详细描述
     */
    @ApiModelProperty(value = "7.详细描述", position = 7, example = "")
    private String details;
    /**
     * 图片凭证
     */
    @ApiModelProperty(value = "8.图片凭证", position = 8, example = "")
    private String imageDetails;
    /**
     * 退款金额
     */
    @ApiModelProperty(value = "9.退款金额", position = 9, example = "")
    private String refundAmount;
    /**
     * 商家收货地址
     */
    @ApiModelProperty(value = "10.商家收货地址", position = 10, example = "")
    private String storeAddressId;
    /**
     * 实际退款金额
     */
    @ApiModelProperty(value = "11.实际退款金额", position = 11, example = "")
    private String actualRefundAmount;
    /**
     * 实退积分
     */
    @ApiModelProperty(value = "12.实退积分", position = 12, example = "")
    private String actualRefundScore;
    /***
     * 实退优惠券
     */
    @ApiModelProperty(value = "13.实退优惠券", position = 13, example = "")
    private String actualRefundCouponName;

}
