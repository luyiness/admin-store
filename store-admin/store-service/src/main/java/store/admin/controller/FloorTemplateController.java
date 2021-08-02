package store.admin.controller;

import cms.api.*;
import cms.api.dto.*;

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
@RequestMapping("floortemplate")
public class FloorTemplateController {

    private static final Log log = Logs.getLog(FloorTemplateController.class.getName());

    @Autowired
    public FloorTemplateRestApi floorTemplateApi;

    @Autowired
    public FloorRestApi floorApi;

    @Autowired
    OrganizationRestApi organizationApi;

    @RequestMapping(value = {"","list"}, method = RequestMethod.GET)
    public String index(Map model){
        return "floortemplate/index";
    }

    @RequestMapping(value = {"","list"}, method = RequestMethod.POST)
    @ResponseBody
    public Map query(Map model, Pageable pageable , JqueryDataTablesVo jqueryDataTablesVo,
                     String name , HttpServletRequest request) {

        if(log.isDebugEnabled()){
            log.debug("jqueryDataTablesVo:{}", jqueryDataTablesVo);
            log.debug("name:{}",name);
        }

        /**
         * 用于多条件排序
         */
        Sort.Order order = new Sort.Order(Sort.Direction.DESC, "date_created");
        List<Sort.Order> sortList=new ArrayList<>();
        sortList.add(order);
        Sort sort=new Sort(sortList);
        /**
         * 用于多条件排序
         */

        int pageindex = jqueryDataTablesVo.getiDisplayStart() / jqueryDataTablesVo.getiDisplayLength();
        pageable = new PageRequest(pageindex,  jqueryDataTablesVo.getiDisplayLength(),  sort);
        HttpSession session = request.getSession();
        StoreDto store = (StoreDto)session.getAttribute("store");
        String storeId =store==null?"":store.getId();
        FloorContentPageable floorContentPageable = new FloorContentPageable();
        floorContentPageable.setName(name);
        floorContentPageable.setStoreId(storeId);
        floorContentPageable.setPageableVo(new PageableVo(pageable));
        FeignPage<FloorTemplateDto> floorTemplatePage = floorTemplateApi.getFloorTemplates(floorContentPageable);

        Map returnModel = new HashMap();
        returnModel.putAll(jqueryDataTablesVo.toMap());

        List<FloorTemplateDto> list = new ArrayList<>();
        for (FloorTemplateDto floorTemplate1:floorTemplatePage.getContent()) {
           // FloorTemplateDto floorTemplate2 = new FloorTemplateDto();
            //Copys.create().from(floorTemplate1).excludes("floors").to(floorTemplate2);
            FloorTemplateDto floorTemplate2 =  CopyUtil.map(floorTemplate1,FloorTemplateDto.class);
            list.add(floorTemplate2);
        }

        returnModel.put("aaData",list);
        returnModel.put("iTotalRecords",floorTemplatePage.getTotalElements());
        returnModel.put("iTotalDisplayRecords",floorTemplatePage.getTotalElements()  );

        return  returnModel;
    }

    @RequestMapping(value = {"delete"},method = RequestMethod.POST)
    @ResponseBody
    public Map delete(String id){
        Map model = new HashMap();
        if(Lang.isEmpty(id)){
            model.put(GlobalContants.ResponseString.STATUS,GlobalContants.ResponseStatus.ERROR);
            model.put(GlobalContants.ResponseString.MESSAGE,"数据删除失败");
        }else{
            FloorTemplateDto floorTemplate = floorTemplateApi.findDataById(id);
            FloorTemplateResquestBody floorTemplateResquestBody = new FloorTemplateResquestBody();
            floorTemplateResquestBody.setDelete(false);
            floorTemplateResquestBody.setFloorTemplate(floorTemplate);
            List<FloorDto> list = floorApi.getFloorsByFloorTemplate(floorTemplateResquestBody);
            if (Lang.isEmpty(list)) {
                floorTemplateApi.deleteDataById(id);
                model.put(GlobalContants.ResponseString.STATUS,GlobalContants.ResponseStatus.SUCCESS);
                model.put(GlobalContants.ResponseString.MESSAGE,"数据删除成功");
            } else {
                model.put(GlobalContants.ResponseString.STATUS,GlobalContants.ResponseStatus.ERROR);
                model.put(GlobalContants.ResponseString.MESSAGE,"该楼层模板被使用中，删除数据失败");
            }
        }
        return model;
    }

    @RequestMapping(value = {"edit"},method = RequestMethod.GET)
    public String edit(String id,Map model){
        FloorTemplateDto floorTemplate = null;
        if(Lang.isEmpty(id)){//新增
            floorTemplate = new FloorTemplateDto();
        }else{
            floorTemplate = floorTemplateApi.findDataById(id);
        }
        model.put("floorTemplate",floorTemplate);
        return "floortemplate/edit";
    }

    @RequestMapping(value = {"update"},method = RequestMethod.POST)
    @ResponseBody
    public Map update(HttpServletRequest request,FloorTemplateDto template){
        FloorTemplateDto floorTemplate = null;
        String responseMessage="";
        if(Lang.isEmpty(template.getId())){
            floorTemplate=new FloorTemplateDto();
            String organizationId=request.getSession().getAttribute("organization_id").toString();
            OrganizationDto organization =organizationApi.findOrganizationById(organizationId);
            floorTemplate.setOrganization(organization);
            HttpSession session = request.getSession();
            StoreDto store = (StoreDto)session.getAttribute("store");
            if(!Lang.isEmpty(store)){
                floorTemplate.setStoreId(store.getId());
            }
            responseMessage="数据添加成功";
        }else{
            floorTemplate=floorTemplateApi.findDataById(template.getId());
            responseMessage="数据修改成功";
        }
        //Beans.from(template).excludes("floors").to(floorTemplate);

        floorTemplate= CopyUtil.map(template,FloorTemplateDto.class);
        floorTemplateApi.saveBean(floorTemplate);

        Map model=new HashMap();
        model.put(GlobalContants.ResponseString.STATUS,GlobalContants.ResponseStatus.SUCCESS);
        model.put(GlobalContants.ResponseString.MESSAGE,responseMessage);

        return model;
    }

}
