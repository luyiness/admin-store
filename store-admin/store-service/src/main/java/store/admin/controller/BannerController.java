package store.admin.controller;

import cms.api.BannerApi;
import cms.api.BannerRestApi;
import cms.api.OrganizationApi;
import cms.api.OrganizationRestApi;
import cms.api.dto.BannerDto;
import cms.api.dto.OrganizationDto;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import sinomall.global.common.response.BaseResponse;
import store.admin.vo.JqueryDataTablesVo;
import utils.GlobalContants;
import utils.Lang;
import utils.data.Beans;
import utils.log.Log;
import utils.log.Logs;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by ChenGeng on 2016/10/28.
 */

@Controller
@RequestMapping("/banner")
public class BannerController {
    private final static Log log = Logs.getLog(BannerController.class.getName());

    @Autowired
    BannerRestApi bannerApi;

    @Autowired
    OrganizationRestApi organizationApi;

    @RequestMapping(value = {"", "list"}, method = RequestMethod.GET)
    public String index(Map model, HttpServletRequest request) {
        //将首页加载条件查询的 --合作伙伴-- 放入model
        model.put("ogList", organizationApi.findOrganizationAll());
        return "banner/index";
    }

    @RequestMapping(value = {"", "list"}, method = RequestMethod.POST)
    @ResponseBody
    public Map query(Map model, HttpServletRequest httpServletRequest,
                     JqueryDataTablesVo jqueryDataTablesVo) {
        //log前端分页请求参数
        if (log.isDebugEnabled()) {
            log.debug("jqueryDataTablesVo:{}", jqueryDataTablesVo);
        }
        List<BannerDto> bannerList = null;
        //获取前端请求中是否有合作伙伴的organization_id
        String organization_id = httpServletRequest.getParameter("organization");
        if (Lang.isEmpty(organization_id)) {
            //前端没有选择"合作伙伴"时，没有organization_id，查询全部banner列表
            bannerList = bannerApi.getAllBannerAtMall();
        } else {
            //前端选择"合作伙伴"时，传入了organization_id，通过合作伙伴查询banner列表
            OrganizationDto organizationDto = new OrganizationDto();
            organizationDto.setId(organization_id);
            bannerList = bannerApi.getBannerByOrganization(organizationDto);
        }

        List<BannerDto> banners = new ArrayList<>();
        for (BannerDto banner : bannerList) {
            //前端页面需要显示机构名称在此查询封装
            OrganizationDto organization = organizationApi.findOrganizationById(banner.getOrganization().getId());
            banner.setOrganization(organization);
            banners.add(banner);
        }

        //分页对象封装返回
        Map returnModel = new HashMap();
        long totalElement = banners.size();
        returnModel.putAll(jqueryDataTablesVo.toMap());
        returnModel.put("aaData", banners);
        returnModel.put("iTotalRecords", totalElement);
        returnModel.put("iTotalDisplayRecords", totalElement);
        return returnModel;
    }

    @RequestMapping(value = {"delete"}, method = RequestMethod.POST)
    @ResponseBody
    public Map delete(String id) {
        Map model = new HashMap();
        if (Lang.isEmpty(id)) {
            model.put(GlobalContants.ResponseString.STATUS, GlobalContants.ResponseStatus.ERROR);
            model.put(GlobalContants.ResponseString.MESSAGE, "数据删除失败");
        } else {
            bannerApi.deleteBanner(id);
            model.put(GlobalContants.ResponseString.STATUS, GlobalContants.ResponseStatus.SUCCESS);
            model.put(GlobalContants.ResponseString.MESSAGE, "数据删除成功");
        }
        return model;
    }

    @RequestMapping(value = {"edit"}, method = RequestMethod.GET)
    public String edit(String id, Map model, HttpServletRequest request) {
        BannerDto banner = null;
        if (Lang.isEmpty(id)) {
            //I.新增banner
            //返回空的banner对象
            banner = new BannerDto();
            //返回新增banner操作标志位
            model.put("isNew", true);
        } else {
            //II.修改banner
            //找到需要修改的banner
            banner = bannerApi.findBannerById(id);
            //返回需要修改的banner的organizationId
            model.put("ogId", banner.getOrganization().getId());
            //返回修改banner操作标志位
            model.put("isNew", false);
        }
        //返回所有的合作伙伴信息
        model.put("ogList", organizationApi.findOrganizationAll());
        //返回此次给页面操作的banner对象
        model.put("banner", banner);
        return "banner/edit";
    }

    /**
     * 页面保存时验证表单的ajax
     *
     * @param bannerName 传入的banner名称
     * @param showIndex  传入的显示序号
     * @param bannerId   banner的编号
     * @return 0：通过 1：有相同名称的banner 2：有相同序号的banner 3：名称和序号都有相同的banner
     */
    @RequestMapping("check")
    @ResponseBody
    public String check(String bannerName, int showIndex, String bannerId, String organizationId) {
        BannerDto banner1 = bannerApi.findBannerByNameAtMall(organizationId, bannerName);
        BannerDto banner2 = bannerApi.findBannerByShowIndexAtMall(organizationId, showIndex);
        if (null == bannerId || bannerId.equals("")) {
            if (banner1 != null && banner2 == null) {
                return "1";
            } else if (banner1 == null && banner2 != null) {
                return "2";
            } else if (banner1 != null && banner2 != null) {
                return "3";
            } else {
                return "0";
            }
        } else {
            if (banner1 != null && banner2 == null && !banner1.getId().equals(bannerId)) {
                return "1";
            } else if (banner1 == null && banner2 != null && !banner2.getId().equals(bannerId)) {
                return "2";
            } else if (banner1 != null && banner2 != null && !banner1.getId().equals(bannerId) && banner2.getId().equals(bannerId)) {
                return "1";
            } else if (banner1 != null && banner2 != null && banner1.getId().equals(bannerId) && !banner2.getId().equals(bannerId)) {
                return "2";
            } else if (banner1 != null && banner2 != null && !banner1.getId().equals(bannerId) && !banner2.getId().equals(bannerId)) {
                return "3";
            } else {
                return "0";
            }
        }
    }

    /**
     * banner名称输入框失去焦点时校验是否存在相同的banner名称
     *
     * @param bannerId   banner的编号
     * @param bannerName 输入的banner名称
     * @return true: 通过, 即不存在相同的banner名称;    false: 不通过, 即存在相同的banner名称
     */
    @RequestMapping("checkName")
    @ResponseBody
    public String checkName(String bannerId, String bannerName, String organizationId) {
        BannerDto banner = bannerApi.findBannerByNameAtMall(organizationId, bannerName);
        if (banner == null) {
            return "true";
        } else if (banner.getId().equals(bannerId)) {
            return "true";
        } else {
            return "false";
        }
    }

    /**
     * banner排序值输入框失去焦点时校验是否存在相同的排序值
     *
     * @param bannerId  banner的编号
     * @param showIndex 输入的排序值
     * @return true: 通过, 即不存在相同的排序值;    false: 不通过, 即存在相同的排序值
     */
    @RequestMapping("checkShowIndex")
    @ResponseBody
    public String checkShowIndex(String bannerId, String showIndex, String organizationId) {
        int index = 0;
        try {
            index = Integer.parseInt(showIndex);
        } catch (Exception e) {
            return "error";
        } finally {
            BannerDto banner = bannerApi.findBannerByShowIndexAtMall(organizationId, index);
            if (banner == null) {
                return "true";
            } else if (banner.getId().equals(bannerId)) {
                return "true";
            } else {
                return "false";
            }
        }
    }

    @RequestMapping("update")
    @ResponseBody
    public Map update(BannerDto banner, Map model, String organizationId) {
        Map model1 = new HashMap();
        BannerDto banner2 = null;
        if (banner.getId() != null && !banner.getId().equals("")) {
            banner2 = bannerApi.findBannerById(banner.getId());
            banner2.setLinkValue(banner.getLinkValue());
        } else {
            banner2 = new BannerDto();
            banner2.setType(1);
            banner.setId(null);
        }
        OrganizationDto organization = organizationApi.findOrganizationById(organizationId);
        Beans.from(banner).to(banner2);
        //banner2= CopyUtil.map(banner2,BannerDto.class);

        banner2.setOrganization(organization);
        bannerApi.saveBanner(banner2);
        model1.put(GlobalContants.ResponseString.STATUS, GlobalContants.ResponseStatus.SUCCESS);
        model1.put(GlobalContants.ResponseString.MESSAGE, "Banner保存成功！");
        return model1;
    }

    /*@ResponseBody
    @RequestMapping("getReleaseTerminal")
    public BaseResponse<GetReleaseTerminalResp> getReleaseTerminal() {
        List<GetReleaseTerminalResp.ReleaseTerminalVo> releaseTerminalList = new ArrayList<>();
        releaseTerminalList.add(new GetReleaseTerminalResp.ReleaseTerminalVo(Terminal.ALL.getDescription(), Terminal.ALL.getValue()));
        releaseTerminalList.add(new GetReleaseTerminalResp.ReleaseTerminalVo(Terminal.PC.getDescription(), Terminal.PC.getValue()));
        releaseTerminalList.add(new GetReleaseTerminalResp.ReleaseTerminalVo(Terminal.MOBILE.getDescription(), Terminal.MOBILE.getValue()));
        return new BaseResponse<>(true, "请求成功", new GetReleaseTerminalResp(releaseTerminalList), GlobalContants.REQUERST_SUCCESS);
    }*/

    /**
     * 获取自动填充展示顺序
     *
     * @param organizationId
     * @return
     */
    @ResponseBody
    @RequestMapping("getAutoShowIndex")
    public BaseResponse<Integer> getAutoShowIndex(String organizationId) {
        if (Lang.isEmpty(organizationId)) {
            return new BaseResponse<>("param must not null", "organizationId is null");
        }
        Integer autoShowIndex = bannerApi.getAutoShowIndex(organizationId);
        return new BaseResponse<>(true, "请求成功", autoShowIndex, GlobalContants.REQUERST_SUCCESS);
    }

}
