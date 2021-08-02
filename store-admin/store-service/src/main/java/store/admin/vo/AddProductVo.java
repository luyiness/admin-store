package store.admin.vo;

import lombok.Data;
import pool.dto.ProductModelDto;
import pool.dto.ProviderGoodsDto;
import pool.dto.goodsmng.GMProviderProductDTO;
import pool.dto.goodsmng.GMProviderProductFashionDTO;

import java.io.Serializable;
import java.util.List;

@Data
public class AddProductVo implements Serializable {

    private ProductModelDto productModel;

    private List<ProviderGoodsDto> providerGoodses;

    private List<String> delGoodses;

}
