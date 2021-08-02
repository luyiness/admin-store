package store.admin.controller;

import cms.api.*;
import cms.api.dto.FloorContentDto;
import cms.api.dto.FloorContentPageable;
import cms.api.dto.FloorDto;
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
import org.springframework.web.bind.annotation.ResponseBody;
import store.admin.vo.JqueryDataTablesVo;
import store.api.dto.modeldto.core.StoreDto;
import utils.GlobalContants;
import utils.Lang;
import utils.data.CopyUtil;
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
@RequestMapping("floorcontent")
public class FloorContentController {

    private final static Log log = Logs.getLog(FloorContentController.class.getName());

    @Autowired
    public FloorContentRestApi floorContentApi;

    @Autowired
    public FloorRestApi floorApi;

    @Autowired
    OrganizationRestApi organizationApi;

    @RequestMapping(value = {"", "list"}, method = RequestMethod.GET)
    public String index(Map model, HttpServletRequest request) {
        HttpSession session = request.getSession();
        CoreUserDto coreUser = (CoreUserDto) session.getAttribute("user");
        StoreDto store = (StoreDto) session.getAttribute("store");

        List<FloorDto> list = floorApi.getListByUserId(coreUser.getId());
        model.put("list", list);
        return "floorcontent/index";
    }

    //post方法的楼层内容列表查询
    @RequestMapping(value = {"", "list"}, method = RequestMethod.POST)
    @ResponseBody
    public Map getFloorList(Map model, Pageable pageable, JqueryDataTablesVo jqueryDataTablesVo,
                            HttpServletRequest request, String floorId) {

        if (log.isDebugEnabled()) {
            log.debug("jqueryDataTablesVo:{}", jqueryDataTablesVo);
            log.debug("floorId:{}", floorId);
        }

        //Sort.Order order1 = new Sort.Order(Sort.Direction.ASC, "floor.showIndex");
        Sort.Order order2 = new Sort.Order(Sort.Direction.ASC, "show_index");
        List<Sort.Order> sortList = new ArrayList<>();
        //sortList.add(order1);
        sortList.add(order2);
        Sort sort = new Sort(sortList);

        int pageindex = jqueryDataTablesVo.getiDisplayStart() / jqueryDataTablesVo.getiDisplayLength();
        pageable = new PageRequest(pageindex, jqueryDataTablesVo.getiDisplayLength(), sort);

        HttpSession session = request.getSession();
        CoreUserDto coreUser = (CoreUserDto) session.getAttribute("user");
        StoreDto store = (StoreDto) session.getAttribute("store");

        Page<FloorContentDto> floorContents = null;
        Map returnModel = new HashMap();
        returnModel.putAll(jqueryDataTablesVo.toMap());
        FloorContentPageable floorContentPageable = new FloorContentPageable();
        floorContentPageable.setPageableVo(new PageableVo(pageable));
        floorContentPageable.setUserId(coreUser.getId());
        if (Lang.isEmpty(floorId)) {
            floorContents = floorContentApi.getFloorContentByFloor(floorContentPageable);
        } else {
            floorContentPageable.setFloorId(floorId);
            floorContents = floorContentApi.getFloorContentByFloorChoice(floorContentPageable);
        }

        List<FloorContentDto> list = new ArrayList<>();
        for (FloorContentDto floorContent1 : floorContents.getContent()) {
            FloorContentDto floorContent2 = CopyUtil.map(floorContent1, FloorContentDto.class);
            FloorDto floor = CopyUtil.map(floorContent1.getFloor(), FloorDto.class);

            if (Lang.isEmpty(floor.getName())) {
                floor.setName(" ");
            }
            floorContent2.setFloor(floor);
            list.add(floorContent2);
        }
        returnModel.put("aaData", list);
        returnModel.put("iTotalRecords", floorContents.getTotalElements());
        returnModel.put("iTotalDisplayRecords", floorContents.getTotalElements());
        return returnModel;
    }

    //删除楼层内容信息
    @RequestMapping(value = {"delete"}, method = RequestMethod.POST)
    @ResponseBody
    public Map deleteContent(String id) {
        return floorContentApi.deleteContent(id);
    }

    //修改楼层内容信息页面
    @RequestMapping(value = {"contentupdate"}, method = RequestMethod.GET)
    public String contentUpdate(HttpServletRequest request, Map model) {
        HttpSession session = request.getSession();
        CoreUserDto coreUser = (CoreUserDto) session.getAttribute("user");
        StoreDto store = (StoreDto) session.getAttribute("store");

        String id = request.getParameter("id");
        FloorContentDto floorContent = floorContentApi.getFloorContent(id);
        List<FloorDto> list = floorApi.getListByUserId(coreUser.getId());
        model.put("floorContent", floorContent);
        model.put("floorId", floorContent.getFloor().getId());
        model.put("list", list);
        model.put("linkSourceMap", FloorContentDto.LINK_SOURCE_MAP);
        return "floorcontent/content-update";
    }

    //get方法的楼层内容列表查询
    @RequestMapping(value = {"contentadd"}, method = RequestMethod.GET)
    public String addContent(Map model, HttpServletRequest request) {
        //获取楼层菜单信息
        HttpSession session = request.getSession();
        CoreUserDto coreUser = (CoreUserDto) session.getAttribute("user");
        StoreDto store = (StoreDto) session.getAttribute("store");

        List<FloorDto> list = floorApi.getListByUserId(coreUser.getId());
        model.put("list", list);
        model.put("linkSourceMap", FloorContentDto.LINK_SOURCE_MAP);
        return "floorcontent/content-add";
    }

    //save方法保存楼层内容
    @RequestMapping(value = {"save"}, method = RequestMethod.POST)
    @ResponseBody
    public Map saveContent(HttpServletRequest request, FloorContentDto floorContent) {
        String floorId = request.getParameter("floorId");
        Map<String, Object> map = new HashMap<>();
        List<FloorContentDto> floorContentsList = floorContentApi.findFlorrContentByFloorId(floorId);
        for (FloorContentDto fc : floorContentsList) {
           /*if(fc.getName().equals(floorContent.getName()) &&  !fc.getId().equals(floorContent.getId())){
               map.put(GlobalContants.ResponseString.STATUS,GlobalContants.ResponseStatus.ERROR);
               map.put(GlobalContants.ResponseString.MESSAGE,"保存失败：同一楼层存在相同的楼层内容名称");
               return map;
           }*/
            if (fc.getShowIndex().intValue() == floorContent.getShowIndex().intValue() && !fc.getId().equals(floorContent.getId())) {
                map.put(GlobalContants.ResponseString.STATUS, GlobalContants.ResponseStatus.ERROR);
                map.put(GlobalContants.ResponseString.MESSAGE, "保存失败：同一楼层存在相同的楼层内容排序,冲突楼层内容名称：" + fc.getName());
                return map;
            }
        }
        HttpSession session = request.getSession();
        CoreUserDto coreUser = (CoreUserDto) session.getAttribute("user");
        String organizationId = session.getAttribute("organization_id").toString();
        OrganizationDto organization = organizationApi.findOrganizationById(organizationId);
        //获取楼层菜单信息
        FloorDto floor = floorApi.getFloorInfo(floorId);
        floorContent.setUserId(coreUser.getId());
        floorContent.setFloor(floor);
        floorContent.setOrganization(organization);

        //清空非选定内容
        if (0 == floorContent.getType()) {
            floorContent.setLinkUrl("");
            floorContent.setPicSearchContent("");
            floorContent.setLinkSource("");
        } else if (1 == floorContent.getType()) {
            floorContent.setPicSearchContent("");
        } else if (2 == floorContent.getType()) {
            floorContent.setLinkUrl("");
            floorContent.setLinkSource("");
        }
        Map result = floorContentApi.saveContent(floorContent);
        return result;
    }
}
