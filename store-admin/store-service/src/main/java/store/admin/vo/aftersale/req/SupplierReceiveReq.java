package store.admin.vo.aftersale.req;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;
import org.hibernate.validator.constraints.NotBlank;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;

@Data
@ToString
@NoArgsConstructor
@AllArgsConstructor
@ApiModel(value = "SupplierReceiveReq", description = "供应山后台-保存收货地址")
public class SupplierReceiveReq {

    @ApiModelProperty(value = "1.id", position = 1, example = "265689789414547577946")
    @NotNull
    private String id;
    /**
     * 收货人
     */
    @ApiModelProperty(value = "2.收货人", position = 2, example = "木头")
    @NotNull
    private String receiveName;
    /**
     * 省ID
     */
    @NotBlank(message = "省ID [provinceId] 不能为空")
    @ApiModelProperty(value = "省ID", required = true, example = "310000", position = 3)
    private String provinceId;

    /**
     * 省
     */
    @ApiModelProperty(value = "3.省", position = 3, example = "浙江")
    @NotNull
    private String provinceName;


    /**
     * 市ID
     */
    @NotBlank(message = "市ID [cityId] 不能为空")
    @ApiModelProperty(value = "市ID", required = true, example = "310100", position = 5)
    private String cityId;

    /**
     * 市
     */
    @ApiModelProperty(value = "4.市", position = 4, example = "温州")
    @NotNull
    private String cityName;

    /**
     * 区ID
     */
    @NotBlank(message = "区ID [areaId] 不能为空")
    @ApiModelProperty(value = "区ID", required = true, example = "310115", position = 7)
    private String areaId;


    /**
     * 区
     */
    @ApiModelProperty(value = "5.区", position = 5, example = "xx区")
    @NotNull
    private String areaName;

    /**
     * 县ID
     */
    @ApiModelProperty(value = "县ID", position = 9)
    private String townId;

    /**
     * 县名称
     */
    @ApiModelProperty(value = "县名称", position = 10)
    private String townName;


    /**
     * 详细地址
     */
    @ApiModelProperty(value = "6.详细地址", position = 6, example = "")
    private String detailedAddress;
    /**
     * 手机号码
     */
    @ApiModelProperty(value = "7.手机号码", position = 7, example = "13152068956")
    private String phone;
    /**
     * 固定电话
     */
    @ApiModelProperty(value = "8.固定电话", position = 8 , example = "85614887444")
    private String ftelephone;

    /**
     * 店铺id
     */
    @ApiModelProperty(value = "8.店铺id", position = 8 , example = "85614887444")
    private String storeId;

}
