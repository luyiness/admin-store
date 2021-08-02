package store.admin.vo.goods;

import goods.api.goods.dto.response.GoodsDto;
import goods.api.goods.dto.response.ProductStandardDto;
import lombok.Data;
import store.api.vo.StoreVo;

import java.io.Serializable;
import java.util.List;

/**
 * Created by Roney on 2016/11/2.
 */
@Data
public class GoodsDetailsVo implements Serializable {

    private GoodsDto goodsDto;//商品的信息
    private StoreVo storeVo;//店铺的信息
    private List<ProductStandardDto> productStandards;//商品的规格

}
