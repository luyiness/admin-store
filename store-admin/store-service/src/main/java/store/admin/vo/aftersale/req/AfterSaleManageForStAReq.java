package store.admin.vo.aftersale.req;

import com.alibaba.fastjson.annotation.JSONField;
import com.fasterxml.jackson.annotation.JsonFormat;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.NonNull;

import javax.validation.constraints.NotNull;
import java.io.Serializable;
import java.util.Date;
import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
@ApiModel(value = "AfterSaleManagerReq", description = "供应商后台-售后管理条件查询请求参数")
public class AfterSaleManageForStAReq implements Serializable {
    /**
     * 订单号
     */
    @ApiModelProperty(value = "0.申请单号", position = 1, example = "po45678797")
    private String serviceNo;

    /**
     * 订单号
     */
    @ApiModelProperty(value = "1.订单号", position = 1, example = "po45678797")
    private String orderNo;

    /**
     * 售后单状态
     */
    @ApiModelProperty(value = "售后单状态状态", position = 5, example = "0 、1")
    private List<String>  applicationStatus;

    /**
     * 开始时间
     */
    @ApiModelProperty(value = "2.活动开始时间", position = 2, example = "2020-05-20 12:12:12")
    @JSONField(format = "yyyy-MM-dd HH:mm:ss")
    @JsonFormat(locale = "zh", timezone = "GMT+8", pattern = "yyyy-MM-dd HH:mm:ss")
    private Date beginTime;

    /**
     * 结束时间
     */
    @ApiModelProperty(value = "3.活动结束时间", position = 3, example = "2020-05-20 12:12:13")
    @JSONField(format = "yyyy-MM-dd HH:mm:ss")
    @JsonFormat(locale = "zh", timezone = "GMT+8", pattern = "yyyy-MM-dd HH:mm:ss")
    private Date endTime;

    @ApiModelProperty(value = "售后类型", position = 4, example = "0、1")
    private String afterSaleType;

    /**
     * 手机号
     */
    @ApiModelProperty(value = "手机号", position = 6, example = "13120564562")
    private String phoneNo;


    @ApiModelProperty(value = "店铺id", position = 7, example = "")
    private String storeId;

    /**
     * 页码
     */
    @ApiModelProperty(value = "页码", position = 8, example = "1")
    @NotNull
    private Integer page;
    /**
     * 每页多少条数据
     */
    @ApiModelProperty(value = "每页多少条数据", position = 9, example = "10")
    @NotNull
    private Integer pagSize;


}
