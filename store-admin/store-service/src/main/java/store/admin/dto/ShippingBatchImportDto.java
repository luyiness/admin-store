package store.admin.dto;

import lombok.Data;

import java.io.Serializable;

/**
 * @author: taofeng
 * @create: 2019-11-04
 **/
@Data
public class ShippingBatchImportDto implements Serializable {

    //订单号
    private String orderNo;

    //物流公司
    private String logisticCompanyName;

    //物流单号
    private String shippingNo;

    //导入结果
    private Boolean success;
    private String msg;

}
