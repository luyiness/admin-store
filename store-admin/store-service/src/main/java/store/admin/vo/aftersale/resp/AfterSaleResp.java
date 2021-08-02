package store.admin.vo.aftersale.resp;

import com.alibaba.fastjson.annotation.JSONField;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.util.Date;

//售后主表
@Data
@ToString
@NoArgsConstructor
@AllArgsConstructor
@ApiModel(value = "AfterSaleResp", description = "运营后台-售后主表")
public class AfterSaleResp {
    @ApiModelProperty(value = "id", position = 0, example = "")
    private String id;

    /**
     * 申请售后服务单号
     */
    @ApiModelProperty(value = "1.申请售后服务单号", position = 1, example = "")
    private String serviceNo;
    /**
     * 售后服务类型
     */
    @ApiModelProperty(value = "2.售后服务类型", position = 2, example = "")
    private String type;
    /**
     * 订单号
     */
    @ApiModelProperty(value = "3.订单号", position = 3, example = "")
    private String orderNo;

    /**
     * 用户id
     */
    @ApiModelProperty(value = "3.用户id", position = 3, example = "")
    private String userId;

    /**
     * 下一状态截止时间
     */
    @ApiModelProperty(value = "4.下一状态截止时间", position = 4, example = "")
    @JSONField(format="yyyy-MM-dd HH:mm:ss")
    private Date lastStatusDeadline;

    /**
     * 用户手机号
     */
    @ApiModelProperty(value = "5.用户手机号", position = 5, example = "")
    private String userPhone;
    /**
     * 售后服务状态
     */
    @ApiModelProperty(value = "6.售后服务状态", position = 6, example = "")
    private String  status;



}
