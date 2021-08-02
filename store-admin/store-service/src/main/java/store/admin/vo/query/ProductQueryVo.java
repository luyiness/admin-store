package store.admin.vo.query;

import lombok.Data;

import java.io.Serializable;

/**
 *
 * @author 31714
 * @date 2016/12/21
 */
@Data
public class ProductQueryVo implements Serializable {
    private String modelSku;    //商品模型编码
    private String categoryId;  //分类id
    private String storeId;     //供应商id
    /**
     * 添加部分查询参数
     */

    private String storeName;   //供应商名字
    private String productSku;  //产品sku
    private String productName;   //产品名字
    private String productBrand;   //产品品牌
    // private Integer             //产品审核状态
    private Integer providerSaleStatus;          //1已上架 0已下架 //未上架状态 是?


    private String categoryName;              //分类名称
    private String provideName;              //供应商名称

    //是否包邮
    private String isFreeFreight;
}
