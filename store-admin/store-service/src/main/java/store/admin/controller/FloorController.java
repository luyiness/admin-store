package store.admin.controller;

import cms.api.FloorApi;
//import cms.api.FloorContentApi;
import cms.api.FloorRestApi;
import cms.api.OrganizationApi;
import cms.api.OrganizationRestApi;
import cms.api.dto.FloorDto;
import cms.api.dto.FloorTemplateDto;
import cms.api.dto.FloorTemplateResquestBody;
import cms.api.dto.OrganizationDto;

import member.api.dto.core.CoreUserDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import store.admin.vo.JqueryDataTablesVo;
import store.api.dto.modeldto.core.StoreDto;
import utils.GlobalContants;
import utils.Lang;
import utils.data.CopyUtil;
import utils.jpa.FeignPage;

import utils.jpa.PageableVo;
import utils.log.Log;
import utils.log.Logs;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by JIM on 2016/12/19.
 */

@Controller
@RequestMapping("floor")
public class FloorController {

    private final static Log log = Logs.getLog(FloorController.class.getName());

    @Autowired
    public FloorRestApi floorApi;

//    @Autowired(basicReferer = "motanClientBasicConfig")
//    public FloorContentApi floorContentApi;

    @Autowired
    OrganizationRestApi organizationApi;

    @RequestMapping(value = {"", "list"}, method = RequestMethod.GET)
    public String index(Map model, HttpServletRequest request) {
        HttpSession session = request.getSession();
        CoreUserDto coreUser = (CoreUserDto) session.getAttribute("user");
        StoreDto store = (StoreDto) session.getAttribute("store");
        String storeId = store == null ? "" : store.getId();
        List<FloorTemplateDto> list = floorApi.getFloorTemplateInfoByStore(storeId);
        model.put("temList", list);
        return "floor/index";
    }

    @RequestMapping(value = {"", "list"}, method = RequestMethod.POST)
    @ResponseBody
    public Map query(Pageable pageable, JqueryDataTablesVo jqueryDataTablesVo,
                     HttpServletRequest request) {

        /**
         * 用于多条件排序
         */
        Sort.Order order1 = new Sort.Order(Sort.Direction.ASC, "show_index");
        Sort.Order order2 = new Sort.Order(Sort.Direction.DESC, "date_created");
        List<Sort.Order> sortList = new ArrayList<>();
        sortList.add(order1);
        sortList.add(order2);
        Sort sort = new Sort(sortList);
        /**
         * 用于多条件排序
         */

        int pageindex = jqueryDataTablesVo.getiDisplayStart() / jqueryDataTablesVo.getiDisplayLength();
        pageable = new PageRequest(pageindex, jqueryDataTablesVo.getiDisplayLength(), sort);

        HttpSession session = request.getSession();
        CoreUserDto coreUser = (CoreUserDto) session.getAttribute("user");
        StoreDto store = (StoreDto) session.getAttribute("store");
        FloorTemplateResquestBody floorTemplateResquestBody = new FloorTemplateResquestBody();
        floorTemplateResquestBody.setUserId(coreUser.getId());
        floorTemplateResquestBody.setStoreId(store.getId());
        floorTemplateResquestBody.setPageableVo(new PageableVo(pageable));
        FeignPage<FloorDto> floors = floorApi.getFloorListInfo(floorTemplateResquestBody);

        Map returnModel = new HashMap();
        returnModel.putAll(jqueryDataTablesVo.toMap());

        List<FloorDto> list = new ArrayList<>();
        for (FloorDto floor1 : floors.getContent()) {
         /*   FloorDto floor2 = new FloorDto();
            FloorTemplateDto floorTemplate = new FloorTemplateDto();*/
            /*Copys.create().from(floor1).excludes("floorTemplate").to(floor2).clear();
            Copys.create().from(floor1.getFloorTemplate()).excludes("floors").to(floorTemplate).clear();*/

            FloorDto floor2 = CopyUtil.map(floor1, FloorDto.class);
            FloorTemplateDto floorTemplate = CopyUtil.map(floor1.getFloorTemplate(), FloorTemplateDto.class);
            floor2.setFloorTemplate(floorTemplate);
            list.add(floor2);
        }

        returnModel.put("aaData", list);
        returnModel.put("iTotalRecords", floors.getTotalElements());
        returnModel.put("iTotalDisplayRecords", floors.getTotalElements());

        return returnModel;
    }

    //删除楼层信息
    @ResponseBody
    @RequestMapping(value = {"delete"}, method = RequestMethod.POST)
    public Map deleteFloor(String id) {
        Map result = floorApi.deleteFloor(id);
        return result;
    }

    //通过ID获取楼层信息
    @ResponseBody
    @RequestMapping(value = {"queryID"}, method = RequestMethod.POST)
    public Map queryFloorId(String id) {
        Map model = new HashMap();
        if (Lang.isEmpty(id)) {
            model.put(GlobalContants.ResponseString.STATUS, GlobalContants.ResponseStatus.ERROR);
            model.put(GlobalContants.ResponseString.MESSAGE, "楼层查询失败");
        } else {
            FloorDto floor = floorApi.getFloorInfo(id);
            if (!Lang.isEmpty(floor)) {
                model.put(GlobalContants.ResponseString.STATUS, GlobalContants.ResponseStatus.SUCCESS);
                model.put(GlobalContants.ResponseString.MESSAGE, "楼层查询成功!");
                model.put("floor", floor);
                model.put("floorTemplate", floor.getFloorTemplate());
            } else {
                model.put(GlobalContants.ResponseString.STATUS, GlobalContants.ResponseStatus.ERROR);
                model.put(GlobalContants.ResponseString.MESSAGE, "楼层查询失败!");
            }
        }
        return model;
    }

    //保存楼层信息
    @ResponseBody
    @RequestMapping(value = {"save"}, method = RequestMethod.POST)
    public Map saveFloor(HttpServletRequest request, FloorDto floor, @RequestParam String floorTemplateId) {
        HttpSession session = request.getSession();
        CoreUserDto coreUser = (CoreUserDto) session.getAttribute("user");
        StoreDto store = (StoreDto) session.getAttribute("store");
        String organizationId = session.getAttribute("organization_id").toString();
        OrganizationDto organization = organizationApi.findOrganizationById(organizationId);
        FloorTemplateDto floorTemplate = floorApi.getFloorTemplateInfo(floorTemplateId);

        floor.setUserId(coreUser.getId());//用户id
        floor.setType(2);//供应商
        floor.setStoreId(store.getId());
        floor.setFloorTemplate(floorTemplate);
        floor.setOrganization(organization);
        Map result = floorApi.saveFloor(floor);
        return result;
    }
}
