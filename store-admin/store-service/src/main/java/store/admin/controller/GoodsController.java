package store.admin.controller;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.zxing.BarcodeFormat;
import com.google.zxing.EncodeHintType;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.common.BitMatrix;

//import goods.api.goods.GoodsApi;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
//import pool.api.ProviderGoodsApi;
import pool.vo.ProviderGoodsVo;
import store.admin.vo.JqueryDataTablesVo;
import store.admin.vo.query.GoodsQueryVo;
//import store.api.StoreApi;
import store.api.dto.modeldto.core.StoreDto;
import utils.GlobalContants;
import utils.data.Jsons;
import utils.log.Log;
import utils.log.Logs;
import utils.picture.MatrixToImageWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by 31714 on 2016/12/21.
 */
@Controller
@RequestMapping("goods")
public class GoodsController {
    private final static Log log = Logs.getLog(GoodsController.class.getName());

//    @Autowired(basicReferer = "motanClientBasicConfig")
//    GoodsApi goodsApi;

//    @Autowired
//    ProductApi productApi;
//
//    @Autowired
//    ShareApi shareApi;
//
//    @Autowired
//    ProductFashionApi productFashionApi;
//
//    @Autowired
//    StoreApi storeApi;
//
//    @Autowired
//    ProviderGoodsApi providerGoodsApi;

    @Value("${server.context-path}")
    private String contextpPath;


    @RequestMapping(value = {"", "list"}, method = RequestMethod.GET)
    public String index(Map model, HttpServletRequest request) {

        HttpSession session = request.getSession();
        StoreDto store = (StoreDto) session.getAttribute("store");

        model.put("store", store);

        return "goods/index";
    }

    @RequestMapping(value = {"", "list"}, method = RequestMethod.POST)
    @ResponseBody
    public Map query(Map model, Pageable pageable, JqueryDataTablesVo jqueryDataTablesVo,
                     GoodsQueryVo goodsQueryVo, HttpServletRequest request) {

        HttpSession session = request.getSession();
        StoreDto store = (StoreDto) session.getAttribute("store");

        //获取前台额外传递过来的查询条件
        if (log.isDebugEnabled()) {
            log.debug("JqueryDataTablesVo:{}", jqueryDataTablesVo);
            log.debug("GoodsQueryVo:{}", goodsQueryVo);
        }

        Sort.Order order = new Sort.Order(Sort.Direction.ASC, "date_created");
        List<Sort.Order> sortList = new ArrayList<>();
        sortList.add(order);
        Sort sort = new Sort(sortList);
        int pageindex = jqueryDataTablesVo.getiDisplayStart() / jqueryDataTablesVo.getiDisplayLength();
        pageable = new PageRequest(pageindex, jqueryDataTablesVo.getiDisplayLength(), sort);

//        Page<GoodsDto> goodses;
//        List<GoodsDto> goodsList = new ArrayList<>();
//        if (goodsQueryVo.getGoods_name() == null || goodsQueryVo.getGoods_name().equals("")) {
//            if (goodsQueryVo.getGoods_state().equals("2")) {
//                goodses = goodsApi.findByParams(store.getId(), pageable);
//                for (GoodsDto goods : goodses.getContent()) {
//                    GoodsDto goods1 = CopyUtil.map(goods, GoodsDto.class);
//                    //  Copys.create().from(goods).excludes("product").excludes("goodsAttrs").excludes("goodsPictures").excludes("goodsFashions").to(goods1);
//                    goodsList.add(goods1);
//                }
//            } else {
//                goodses = goodsApi.findByParams(store.getId(), Integer.parseInt(goodsQueryVo.getGoods_state()), pageable);
//                for (GoodsDto goods : goodses.getContent()) {
//                    GoodsDto goods1 = CopyUtil.map(goods, GoodsDto.class);
//                    // Copys.create().from(goods).excludes("product").excludes("goodsAttrs").excludes("goodsPictures").excludes("goodsFashions").to(goods1);
//                    goodsList.add(goods1);
//                }
//            }
//        } else {
//            if (goodsQueryVo.getGoods_state().equals("2")) {
//                goodses = goodsApi.findByParams(store.getId(), "%" + goodsQueryVo.getGoods_name() + "%", pageable);
//                for (GoodsDto goods : goodses.getContent()) {
//                    GoodsDto goods1 = CopyUtil.map(goods, GoodsDto.class);
//                    // Copys.create().from(goods).excludes("product").excludes("goodsAttrs").excludes("goodsPictures").excludes("goodsFashions").to(goods1);
//                    goodsList.add(goods1);
//                }
//            } else {
//                goodses = goodsApi.findByParams(store.getId(), "%" + goodsQueryVo.getGoods_name() + "%", Integer.parseInt(goodsQueryVo.getGoods_state()), pageable);
//                for (GoodsDto goods : goodses.getContent()) {
//                    GoodsDto goods1 = CopyUtil.map(goods, GoodsDto.class);
//                    // Copys.create().from(goods).excludes("product").excludes("goodsAttrs").excludes("goodsPictures").excludes("goodsFashions").to(goods1);
//                    goodsList.add(goods1);
//                }
//            }
//        }
        Map returnModel = new HashMap();
        returnModel.putAll(jqueryDataTablesVo.toMap());

//        long totalElement = goodses.getTotalElements();
//        returnModel.put("aaData", goodsList);
//        returnModel.put("iTotalRecords", totalElement);
//        returnModel.put("iTotalDisplayRecords", totalElement);
        return returnModel;
    }

    @RequestMapping(value = {"updategoods"}, method = RequestMethod.POST)
    @ResponseBody
    public Map updateGoods(String id) {
//        Map result = goodsApi.updateGoods(id);
//        return result;
        return null;
    }


    /**
     * 商品基本信息
     *
     * @param providerGoodsVo
     * @param model
     */
    public void base(ProviderGoodsVo providerGoodsVo, Map<String, Object> model) {
        long methodStartTime = System.currentTimeMillis();
        log.info("### 开始加载商品详情基本数据... ###");
//        /*查看用户是否登陆*/
//        String userMemberId = request.getSession().getAttribute(GlobalContants.SESSION_MEMBER_ID_ITAIPING) + "";
//        String addres = "310115";
//        if (!Lang.isEmpty(userMemberId) && !userMemberId.equals("null")) {
//            long defaultAddressTime = System.currentTimeMillis();
//            MemberAddressDto memberAddress = memberAddressApi.defaultAddress(userMemberId);
//            log.info("查询用户默认地址耗时 {} ms", System.currentTimeMillis() - defaultAddressTime);
//            if (memberAddress != null) {
//                addres = memberAddress.getMinumAreaCode();
//                String DetailedAddress = "";
//                if (!"".equals(memberAddress.getProvinceName()) && memberAddress.getProvinceName() != null) {
//                    DetailedAddress += memberAddress.getProvinceName();
//                }
//                if (!"".equals(memberAddress.getCityName()) && memberAddress.getCityName() != null) {
//                    DetailedAddress += memberAddress.getCityName();
//                }
//                if (!"".equals(memberAddress.getAreaName()) && memberAddress.getAreaName() != null) {
//                    DetailedAddress += memberAddress.getAreaName();
//                }
//                if (!"".equals(memberAddress.getTownName()) && memberAddress.getTownName() != null) {
//                    DetailedAddress += memberAddress.getTownName();
//                }
//
//                model.put("DetailedAddress", DetailedAddress);
//            }
//        }
//        model.put("addres", addres);
//        long goodsTime = System.currentTimeMillis();
//        Goods goodsPO = goodsRepos.findOne(goodsId);
//        log.info("查询 goods 耗时 {} ms", System.currentTimeMillis() - goodsTime);
//
//        if (Lang.isEmpty(goodsPO)) {
//            throw new RuntimeException("无法找到 goodsId 对应的数据");
//        }
//
//        GoodsDto goods = new GoodsDto();
//        Copys.create().from(goodsPO).excludes("product", "goodsAttrs", "goodsPictures", "goodsFashions", "goodsParams", "productFashion").to(goods);
//        ProductDto productDTO = new ProductDto();
//        Copys.create().from(goodsPO.getProduct()).excludes("productCategory", "productStandards", "goodses", "productAttrs", "productFashions", "productParameters").to(productDTO);
//        ProductDto productDTO = productApi.findById(providerGoodsVo.getProductId());
//        // 依次获取上级分类
//        ProductCategoryDto productCategoryDTO = productDTO.getProductCategory();
//        ProductCategoryDto lastProductCategory = null;
//        // 防止无限循环
//        int maxLoop = 5;
//        while (!Lang.isEmpty(productCategoryDTO) && maxLoop > 0) {
////            ProductCategoryDto productCategoryDTO = new ProductCategoryDto();
////            Copys.create().findByIdrom(productCategory).excludes("parent", "child", "productModel", "productBrands", "productStandards", "productExtendPropertys").to(productCategoryDTO);
//            if (!Lang.isEmpty(lastProductCategory)) {
//                lastProductCategory.setParent(productCategoryDTO);
//            }
//            lastProductCategory = productCategoryDTO;
//            if (Lang.isEmpty(productDTO.getProductCategory())) {
//                productDTO.setProductCategory(productCategoryDTO);
//            }
//            productCategoryDTO = productCategoryDTO.getParent();
//            maxLoop--;
//        }

//        goods.setProduct(productDTO);

//        model.put("goodsId", goodsId);
//        model.put("goods", goods);
//        if (Lang.isEmpty(productDTO)) {
//            model.put(GlobalContants.ResponseString.MESSAGE, "商品ID未关联产品，无法确定分类，请联系管理员");
//        } else {
//            model = getGoodsDetails(model, providerGoodsVo);
//        }

//        Boolean hasCollect = false;
//        Object memberId = request.getSession().getAttribute(GlobalContants.SESSION_MEMBER_ID_ITAIPING);
//        if (!Lang.isEmpty(memberId)) {
//            String collectProductId = model.get("productId").toString();
//
//            long memberFavoritesTime = System.currentTimeMillis();
//            List<MemberFavoriteDto> memberFavorites = memberFavoriteApi.listHasFavoriteProducts(memberId.toString(), collectProductId);
//            log.info("查询用户收藏耗时 {} ms", System.currentTimeMillis() - memberFavoritesTime);
//
//            if (!Lang.isEmpty(memberFavorites) && memberFavorites.size() > 0) {
//                hasCollect = true;
//            }
//        }

//        String fromStore = request.getParameter("from");  //区分从店铺页面 页面头部
//        model.put("fromStore", fromStore);
//        model.put("hasCollect", hasCollect);

        log.info("### 加载商品详情基本数据总耗时 {} ms ###", System.currentTimeMillis() - methodStartTime);
    }

    /**
     * 封装商品详情数据
     *
     * @param model 页面 Map
     * @return Map 页面 Map
     */
    private Map<String, Object> getGoodsDetails(Map<String, Object> model, ProviderGoodsVo providerGoodsVo) {
        long methodStartTime = System.currentTimeMillis();
        log.info("### 开始封装商品详情数据 ... ###");

//        long upCheckTime = System.currentTimeMillis();
//        boolean isUp = goodsConfigApi.isUpSku(goods.getSku(), organizationCode);
//        log.info("上下架检查耗时 {} ms", System.currentTimeMillis() - upCheckTime);
//        if(!isUp) {
//            throw new RuntimeException("商品已下架");
//        }

//        List<ProductCommentSummarysVO> ProductCommentSummarysVOs = jdProductApi.getProductCommentSummarys(Collections.singletonList(Long.valueOf(goods.getSku())));
//        model.put("ProductCommentSummarysVOs", ProductCommentSummarysVOs);

//        ProductDto product = goods.getProduct();
//        ProductDto productDto = productApi.findById(providerGoodsVo.getProductId());
//        ProductCategoryDto productCategory = productDto.getProductCategory();

//        long storeCodeTime = System.currentTimeMillis();
//        String storeCode = storeApi.findStoreCodeById(goods.getStoreId());
//        log.info("查询店铺代码耗时 {} ms", System.currentTimeMillis() - storeCodeTime);

        List<Map<String, String>> categoryList = new ArrayList<>();
        Map<String, String> map = Maps.newHashMap();
//        map.put(productCategory.getId(), productCategory.getName());
//        categoryList.add(map);
//        while (productCategory.getParent() != null && !productCategory.getParent().getId().equals(productCategory.getId())) {
//            productCategory = productCategory.getParent();
//            Map<String, String> mapt = Maps.newHashMap();
//            mapt.put(productCategory.getId(), productCategory.getName());
//            categoryList.add(mapt);
//        }
        categoryList = Lists.reverse(categoryList);


//        long productFashionTime = System.currentTimeMillis();
//        String productFasionId = productFashionApi.findIdByGoodsId(goods.getId());
//        log.info("获取 ProductFashionId 耗时 {} ms", System.currentTimeMillis() - productFashionTime);
//        if (Lang.isEmpty(productFasionId)) {
//            List<String> productFashionIds = productFashionApi.findIdsByProductId(product.getId());
//            productFasionId = productFashionIds.get(0);
//        }
        long productFashionTime = System.currentTimeMillis();
//        ProductFashionDto productFashionDto = productFashionApi.findBySkuAndStoreId(providerGoodsVo.getSku(), providerGoodsVo.getStoreId());
//        log.info("获取 ProductFashionId 耗时 {} ms", System.currentTimeMillis() - productFashionTime);
//
//        model.put("categoryList", categoryList);
//        model.put("productCategory", productCategory);

        return model;
    }

    /**
     * 加載商品規格數據
     *
     * @param productId
     * @return
     */
    @ResponseBody
    @RequestMapping(value = {"loadProductSpecifications"}, method = RequestMethod.POST)
    public String loadPproductSpecifications(String productId) {
        Map<String, Object> map = new HashMap<>();
        long start = System.currentTimeMillis();
//        ProductSpecificationsVo productSpecificationsVo;
//        productSpecificationsVo = productSpecigicationsApi.getProductSpecificationsVo(productId);
        log.info("查询商品规格耗时 {} ms", System.currentTimeMillis() - start);
//        map.put("productSpecificationsVo", productSpecificationsVo);
        map.put(GlobalContants.ResponseString.STATUS, GlobalContants.ResponseStatus.SUCCESS);
        return Jsons.map2json(map);
    }

//    @RequestMapping(value = "toPage")
//    public String addShipping(String orderNo,Map model) {
//        model.put("orderNo",orderNo);
//        return "order/addShipping";
//    }


    @RequestMapping("/paymentQRCode")
    public void getQRCode(String url, HttpSession session, HttpServletResponse response, HttpServletRequest request) {
        try {
            // String url="http://10.236.69.12:6071/store-admin/goods/index?sku=2018090615000061";
            //每次刷新验证码附上uuid使其变化

            String ipAddress;

            if ("80".equals(request.getServerPort()) || "8080".equals(request.getServerPort())) {
                ipAddress = request.getScheme() + "://" + request.getServerName() + contextpPath;
            } else {
                ipAddress = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + contextpPath;
            }

            log.info("getQRCode pay url :{}", url);
            String content = ipAddress + url;
            MultiFormatWriter multiFormatWriter = new MultiFormatWriter();
            Map hints = new HashMap();
            hints.put(EncodeHintType.CHARACTER_SET, "UTF-8");
            BitMatrix bitMatrix = multiFormatWriter.encode(content, BarcodeFormat.QR_CODE, 400, 400, hints);
            response.setContentType("image/png");
            OutputStream os = response.getOutputStream();
            MatrixToImageWriter.writeToStream(bitMatrix, "png", os);
            os.flush();
            os.close();
            log.info("获取支付二维码成功");
        } catch (Exception e) {
            log.info("获取二维码失败");
            log.error(e.getMessage(), e);
        }
    }

}
