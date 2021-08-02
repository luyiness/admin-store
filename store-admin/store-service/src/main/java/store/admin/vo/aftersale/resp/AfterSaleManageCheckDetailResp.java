package store.admin.vo.aftersale.resp;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@Data
@AllArgsConstructor
@NoArgsConstructor
@ApiModel(value = "AfterSaleManagerResp", description = "运营后台-售后管理条件查询返回参数")
public class AfterSaleManageCheckDetailResp implements Serializable {
    @ApiModelProperty(value = "1.售后申请主表", position = 1, example = "")
    private AfterSaleResp afterSaleResp;

    @ApiModelProperty(value = "2.售后申请详情表", position = 2, example = "")
    private AfterSaleDetailResp afterSaleDetailResp;






}
