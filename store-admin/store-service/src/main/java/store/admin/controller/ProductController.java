package store.admin.controller;//package store.admin.controller;
//
///**
// * Created by xjw on 2018年8月20日 16:09:29.
// */
//@SuppressWarnings("ALL")
//@Slf4j
//@Controller
//@RequestMapping("/product")
//public class ProductController {
//
//    @Autowired
//    CategoryApi categoryApi;
//    @Autowired
//    ProviderGoodsApi providerGoodsApi;
//    @Autowired
//    StoreExtApi storeExtApi;
//    @Autowired
//    ProviderProductBrandApi providerProductBrandApi;
//
//    @Autowired
//    ProductService productService;
//
//
//@RequestMapping(value = {"", "list"}, method = RequestMethod.GET)
//    public String index(Map model, HttpServletRequest request) {
//
//        HttpSession session = request.getSession();
//        StoreDto store = (StoreDto) session.getAttribute("store");
//
//        model.put("store", store);
//
//        return "goods/index";
//    }
//
//}
