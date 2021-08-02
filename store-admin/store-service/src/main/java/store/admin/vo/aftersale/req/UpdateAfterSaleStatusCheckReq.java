package store.admin.vo.aftersale.req;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import java.io.Serializable;

@Data
@NoArgsConstructor
@AllArgsConstructor
@ApiModel(value = "UpdateAfterSaleStatusReq", description = "供应商后台-审核参数")
public class UpdateAfterSaleStatusCheckReq implements Serializable {

    @ApiModelProperty(value = "0.申请单号", position = 1, example = "po45678797")
    @NotNull
    private String serviceNo;

    @ApiModelProperty(value = "1、是否审核通过", position = 2, example = "true/false")
    @NotEmpty
    private Boolean flag;

    @ApiModelProperty(value = "2、审核备注", position = 3, example = "审核说明")
    private String remarks;

    @ApiModelProperty(value = "3、审核状态-前端无须在意此字段", position = 4, example = "审核说明")
    private String status;

    @ApiModelProperty(value = "5、afterSaleId-前端无须在意此字段", position = 5, example = "售后表id")
    private String id;

    @ApiModelProperty(value = "6、商家收货地址", position = 6, example = "商家收货地址")
    private String storeAddressId;



}
