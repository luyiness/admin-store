package store.admin.dto;

import lombok.Data;

import java.io.Serializable;

/**
 *
 * @author Jian
 * @date 2019-12-17
 */
@Data
public class FreeFreightGoodsBatchImportDto implements Serializable {

    private String sku;
    private String storeId;
    //导入结果
    private Boolean success;
    private String msg;
}
