package store.admin.service;


//import member.api.CoreUserApi;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import store.admin.feign.StoreNavFeign;
import store.admin.vo.StoreNavVo;
import store.model.core.Store;
import store.model.core.StoreNav;
import store.model.repository.StoreNavRepos;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by ChenGeng on 2016/12/21.
 */
@Component
public class StoreNavService {

    @Autowired
    StoreNavFeign storeNavRepos;

//    @Autowired(basicReferer = "motanClientBasicConfig")
//    ProductCategoryApi productCategoryApi;
//    @Autowired
//    CoreUserApi coreUserApi;

   /* @PostConstruct
    public void testApi() {
        System.out.println("coreUserApi = " + coreUserApi);
    }*/

    /**
     * 根据店铺找到该店铺所有未删除的导航菜单
     *
     * @param store
     * @return
     */
    public List<StoreNav> findStoreNavByStore(Store store) {
        List<StoreNav> storeNavList = storeNavRepos.findByStoreOrderBySortIndexAsc(store);
        return storeNavList;
    }

    /**
     * 根据店铺找到该店铺所有未删除的导航菜单，并连同ProductCategory封装到一个Vo对象中
     *
     * @param store
     * @return
     */
    public List<StoreNavVo> findStoreNavVoByStore(Store store) {
        List<StoreNav> storeNavList = findStoreNavByStore(store);
        List<StoreNavVo> storeNavVoList = new ArrayList<StoreNavVo>();
        List<String> stringList = new ArrayList<>();
        for (StoreNav storeNav : storeNavList) {
            stringList.add(storeNav.getProductCategoryId());
        }
//        List<ProductCategoryDto> productCategoryList = productCategoryApi.findProductCategoryList(stringList);
//        for (int i = 0; i < storeNavList.size(); i++) {
//            StoreNavVo storeNavVo = new StoreNavVo();
//            storeNavVo.setProductCategory(productCategoryList.get(i));
//            storeNavVo.setStoreNav(storeNavList.get(i));
//            storeNavVoList.add(storeNavVo);
//        }
        return storeNavVoList;
    }

    public void deleteStoreNavi(String id) {
        storeNavRepos.delete(id);
    }

    public StoreNav findById(String id) {
        return storeNavRepos.findOne(id);
    }

    public void saveStoreNav(StoreNav storeNav) {
        storeNavRepos.save(storeNav);
    }

}
