package store.admin.controller;


//import member.api.MemberApi;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.BoundValueOperations;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import store.admin.service.StoreNavService;
import store.admin.vo.StoreNavVo;
//import store.api.StoreApi;
import store.model.core.Store;
import store.model.core.StoreNav;
import utils.GlobalContants;
import utils.Lang;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by ChenGeng on 2016/12/21.
 */

@Controller
@RequestMapping("/navigate/")
public class NavigateController {
//
//    @Autowired(basicReferer = "motanClientBasicConfig")
//    MemberApi memberApi;
//
//    @Autowired(basicReferer = "motanClientBasicConfig")
//    StoreApi storeApi;

//    @Autowired(basicReferer = "motanClientBasicConfig")
//    ProductCategoryApi productCategoryApi;

    @Autowired
    StoreNavService storeNavService;

   @Autowired
   RedisTemplate redisTemplate;

    @RequestMapping(value = {"","list"}, method = RequestMethod.GET)
    public String index(Map model, HttpServletRequest request){
        HttpSession session = request.getSession();
      //  Store store = (Store) session.getAttribute("store");
        //List<ProductCategory> productCategoryList = productCategoryApi.findLevel1ProductCategoryByStore(store);
        BoundValueOperations boundValueOperations = redisTemplate.boundValueOps("admin:productCategoryAll");
        List<Object[]> productCategoryList = null;
        if(boundValueOperations != null && boundValueOperations.get()!=null){
           Map model1 = (Map)boundValueOperations.get();//缓存中获取直接返回
            List<Object[]> map1 =  (List<Object[]>)model1.get("categoryList");
          //  Map map2 = (Map)map1.get("categoryList");
            //model.clear();
            model.put("categoryList",map1);
            return "navigate/index";
        }else{
//            productCategoryList =  productCategoryApi.findCategoryDataListJpql();
            model.put("categoryList",productCategoryList);
            boundValueOperations.set(model);
            return "navigate/index";
        }
    }

    /**
     * 加载导航菜单列表
     */
    @RequestMapping(value = {"","list"},method = RequestMethod.POST)
    @ResponseBody
    public Map query(Map model, HttpServletRequest request){

        HttpSession session = request.getSession();
        Store store = (Store)session.getAttribute("store");

        List<StoreNavVo> storeNavVoList = storeNavService.findStoreNavVoByStore(store);
        Map returnModel = new HashMap();
        long totalElement = storeNavVoList.size();

        returnModel.put("aaData",storeNavVoList);
        returnModel.put("iTotalRecords",totalElement);
        returnModel.put("iTotalDisplayRecords",totalElement);

        return  returnModel;
    }

    /**
     * 删除导航菜单
     */
    @RequestMapping(value = {"delete"},method = RequestMethod.POST)
    @ResponseBody
    public Map delete(String id){
        Map model = new HashMap();
        if(Lang.isEmpty(id)){
            model.put(GlobalContants.ResponseString.STATUS,GlobalContants.ResponseStatus.ERROR);
            model.put(GlobalContants.ResponseString.MESSAGE,"数据删除失败");
        }else{
            storeNavService.deleteStoreNavi(id);
            model.put(GlobalContants.ResponseString.STATUS,GlobalContants.ResponseStatus.SUCCESS);
            model.put(GlobalContants.ResponseString.MESSAGE,"数据删除成功");
        }
        return model;
    }

    /**
     * 编辑、新增导航菜单
     * @param id 导航菜单id。若为新增，则id为new
     * @param categoryId
     * @param index 排序值
     * @return
     */
    @RequestMapping(value = {"update"},method = RequestMethod.POST)
    @ResponseBody
    public Map update(String id,String categoryId,int index,HttpServletRequest request){
        HttpSession session = request.getSession();
        Store store = (Store) session.getAttribute("store");
        Map model = new HashMap();
        StoreNav storeNav = null;
        if(!id.equals("new")){
            storeNav = storeNavService.findById(id);
        }else{
            storeNav = new StoreNav();
            storeNav.setStore(store);
        }
        storeNav.setSortIndex(index);
        storeNav.setProductCategoryId(categoryId);
        storeNavService.saveStoreNav(storeNav);
        model.put(GlobalContants.ResponseString.STATUS,GlobalContants.ResponseStatus.SUCCESS);
        model.put(GlobalContants.ResponseString.MESSAGE,"数据保存成功");
        return model;
    }

    @RequestMapping(value = {"checkNavigate"},method = RequestMethod.POST)
    @ResponseBody
    public Map checkNavagate(String id,String categoryId,int index,HttpServletRequest request){
        boolean sameCatogory = false;   //判断是否存在相同的category
        boolean sameIndex = false;      //判断是否存在相同的排序值
        Map<String,String> model = new HashMap<String,String>();
        HttpSession session = request.getSession();
        Store store = (Store) session.getAttribute("store");
        List<StoreNav> storeNavList = storeNavService.findStoreNavByStore(store);
        for(StoreNav storeNav:storeNavList){
            if(categoryId.equals(storeNav.getProductCategoryId())){
                if(!id.equals(storeNav.getId())){
                    sameCatogory = true;
                }
            }
            if(index==storeNav.getSortIndex()){
                if(!id.equals(storeNav.getId())){
                    sameIndex = true;
                }
            }
        }
        if(sameCatogory==true && sameIndex==false){
            model.put(GlobalContants.ResponseString.STATUS,GlobalContants.ResponseStatus.ERROR);
            model.put(GlobalContants.ResponseString.MESSAGE,"对不起，存在相同名称的导航菜单");
        }else if(sameCatogory==false && sameIndex==true){
            model.put(GlobalContants.ResponseString.STATUS,GlobalContants.ResponseStatus.ERROR);
            model.put(GlobalContants.ResponseString.MESSAGE,"对不起，存在相同排序的导航菜单");
        }else if(sameCatogory==true && sameIndex==true){
            model.put(GlobalContants.ResponseString.STATUS,GlobalContants.ResponseStatus.ERROR);
            model.put(GlobalContants.ResponseString.MESSAGE,"对不起，存在相同名称和相同排序的导航菜单");
        }else{
            model.put(GlobalContants.ResponseString.STATUS,GlobalContants.ResponseStatus.SUCCESS);
        }
        return model;
    }

}
