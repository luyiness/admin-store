package store.admin.controller.localstore;


import goods.api.goods.dto.response.GoodsDto;
import goods.api.goods.dto.response.GoodsPictureDto;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import pool.api.ProviderGoodsApi;
import pool.api.ProviderGoodsRestApi;
import pool.vo.FashionPicVo;
import pool.vo.ProviderGoodsVo;
import sinomall.global.common.response.BaseResponse;
import store.admin.vo.goods.GoodsDetailsVo;
import utils.Lang;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequestMapping("/productPreView")
public class ProductPreViewController {

    @Autowired
    ProviderGoodsRestApi providerGoodsApi;

    /**
     * 产品详情页
     */
    @RequestMapping(value = "preview", method = RequestMethod.GET)
    public String preview(String sku, String storeId, Map<String, Object> model) {
        long methodStartTime = System.currentTimeMillis();
        if (Lang.isEmpty(storeId)) {
            log.error("productPreView storeId为空");
            return null;
        }
        log.info("### productPreView 开始加载商品详情页 ... ###");
        log.info("productPreView 请求参数 goodsId = {}", sku);
        log.info("productPreView 请求参数 productId = {}", storeId);
        try {
            BaseResponse<ProviderGoodsVo> providerGoods = providerGoodsApi.queryProviderGoods(sku, storeId);
            if (!Lang.isEmpty(providerGoods)) {
                ProviderGoodsVo providerGoodsVo = providerGoods.getResult();
                Long getGoodsDetailsVoTime = System.currentTimeMillis();
                GoodsDetailsVo goodsDetailsVo = new GoodsDetailsVo();
                GoodsDto goodsVo = new GoodsDto();
                log.info("productPreView 获取 GoodsDetailsVo 耗时 {} ms", System.currentTimeMillis() - getGoodsDetailsVoTime);
                long salePriceTime = System.currentTimeMillis();
                goodsVo.setSalePrice(providerGoodsVo.getCostPrice());
                goodsVo.setName(providerGoodsVo.getName());
                goodsVo.setIntroduction(providerGoodsVo.getIntroduction());
                goodsVo.setParam(providerGoodsVo.getParam());
                goodsVo.setSku(providerGoodsVo.getSku());
                List<GoodsPictureDto> goodsPictures = new ArrayList<>();
                if (!Lang.isEmpty(providerGoodsVo.getFashionPics())) {
                    for (FashionPicVo fashionPicVo : providerGoodsVo.getFashionPics()) {
                        GoodsPictureDto goodsPictureDto = new GoodsPictureDto();
                        goodsPictureDto.setBigPicturePath(fashionPicVo.getPath());
                        goodsPictures.add(goodsPictureDto);
                    }
                }
                goodsVo.setGoodsPictures(goodsPictures);
                goodsDetailsVo.setGoodsDto(goodsVo);
                log.info("productPreView 获取商品售价耗时 {} ms", System.currentTimeMillis() - salePriceTime);
                model.put("goodsDetailsVo", goodsDetailsVo);
                model.put("productId", providerGoodsVo.getProductId());
                model.put("storeId", providerGoodsVo.getStoreId());
                log.info("### productPreView 封装商品详情数据总耗时 {} ms ###", System.currentTimeMillis() - methodStartTime);
            }
        } catch (Exception e) {
            log.error("商品详情加载错误", e);
            return null;
        }
        log.info("### 加载商品详情页总耗时 {} ms", System.currentTimeMillis() - methodStartTime);
        return "goods/goodsDetail";
    }

}
