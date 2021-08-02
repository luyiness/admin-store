package store.admin.controller.localstore;

import com.alibaba.fastjson.JSON;

import lombok.extern.slf4j.Slf4j;
import member.api.AddressCommonApi;
import member.api.AddressCommonRestApi;
import member.api.vo.AddressVo;
import member.api.vo.CommonAddressReq;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import pool.api.ProviderGoodsApi;
import pool.api.ProviderGoodsRestApi;
import pool.dto.ProviderGoodsDto;
import sinomall.global.common.response.BaseResponse;
import store.admin.service.localstore.FreightRuleService;
import store.admin.utils.StoreInfoUtil;
import store.admin.vo.AddFreightRuleVo;
import store.api.StoreExtApi;
import store.api.StoreExtRestApi;
import store.api.dto.localstore.StoreFreightRuleDto;
import store.api.dto.modeldto.core.StoreExtDto;
import store.api.localstore.StoreFreightRuleApi;
import store.api.localstore.StoreFreightRuleRestApi;
import utils.Lang;
import utils.collection.CollectionUtil;
import utils.web.ResponseMapUtils;

import java.util.*;
import java.util.stream.Collectors;

/**
 * @author cuizhen
 * @date 2019/11/15
 * 运费管理
 */
@Slf4j
@Controller
@RequestMapping("freightRule")
public class FreightRuleController {

    @Autowired
    StoreFreightRuleRestApi storeFreightRuleApi;
    @Autowired
    StoreExtRestApi storeExtApi;
    @Autowired
    AddressCommonRestApi addressCommonApi;

    @Autowired
    FreightRuleService freightRuleService;

    @Autowired
    ProviderGoodsRestApi providerGoodsApi;

    /**
     * 卖家中心-运费管理页面
     *
     * @param model
     * @return
     */
    @RequestMapping(value = {"", "index"}, method = RequestMethod.GET)
    public String index(Map model) {
        String storeId = StoreInfoUtil.getStoreId();
        StoreExtDto storeExtDto = storeExtApi.findByStoreId(storeId);
        model.put("storeName", storeExtDto.getStoreName());
        model.put("storeId", storeId);
        List<StoreFreightRuleDto> storeFreightRuleDtos = storeFreightRuleApi.findByStoreId(storeId);
        if (CollectionUtil.isNoneEmpty(storeFreightRuleDtos)) {
            Map<String, List<StoreFreightRuleDto>> map = storeFreightRuleDtos.stream()
                    .filter(dto -> StringUtils.isNoneEmpty(dto.getRuleType()))
                    .collect(Collectors.groupingBy(StoreFreightRuleDto::getRuleType));
            List<StoreFreightRuleDto> normalrRules = map.get(StoreFreightRuleDto.CURRENCY_RULE);
            model.put("normalrRule", Lang.isEmpty(normalrRules) ? null : normalrRules.get(0));
            model.put("nFreightRuleValue", Lang.isEmpty(normalrRules) ? null : JSON.toJSONString(normalrRules.get(0)));
            List<StoreFreightRuleDto> specialRules = map.get(StoreFreightRuleDto.SPECIAL_RULE);
            if (CollectionUtil.isNoneEmpty(specialRules)) {
                List<StoreFreightRuleDto> rSpecialRules = new ArrayList<>();
                Map<String, List<StoreFreightRuleDto>> speMap = specialRules.stream()
                        .filter(dto -> (!Lang.isEmpty(dto.getFreePrice())) && (!Lang.isEmpty(dto.getFreightPrice())))
                        .collect(Collectors.groupingBy(sr -> sr.getFreePrice().toString() + "_" + sr.getFreightPrice().toString()));

                model.put("sFreightRuleValue", JSON.toJSONString(speMap));

                Iterator it = speMap.keySet().iterator();
                while (it.hasNext()) {
                    String key = it.next().toString();
                    List<StoreFreightRuleDto> itlist = speMap.get(key);
                    String address = "";
                    String addresscode = "";
                    for (int i = 0; i < itlist.size(); i++) {
                        if (i != itlist.size() - 1) {
                            address = address + itlist.get(i).getLevelOneAddressName() + "、";
                            addresscode = addresscode + itlist.get(i).getLevelOneAddressCode() + "、";
                        } else {
                            address = address + itlist.get(i).getLevelOneAddressName();
                            addresscode = addresscode + itlist.get(i).getLevelOneAddressCode();
                        }
                    }
                    StoreFreightRuleDto dto = new StoreFreightRuleDto();
                    dto.setLevelOneAddressName(address);
                    dto.setStoreId(itlist.get(0).getStoreId());
                    dto.setFreePrice(itlist.get(0).getFreePrice());
                    dto.setFreightPrice(itlist.get(0).getFreightPrice());
                    dto.setRuleType(itlist.get(0).getRuleType());
                    dto.setLevelOneAddressCode(addresscode);
                    rSpecialRules.add(dto);
                }
                model.put("specialRules", rSpecialRules);
                if (specialRules.size() > 0) {
                    model.put("specialRuleFlag", "Y");
                }
            }
        }
        //查询包邮商品
        List<ProviderGoodsDto> response = providerGoodsApi.findByIsFreeFreightAndStoreId("1",storeId);
        if(!Lang.isEmpty(response)) {
            model.put("freeFreightGoods",response);
        }
        return "freight/index";
    }

    /**
     * 运费规则添加
     */
    @RequestMapping(value = "eidtFreightRule", method = RequestMethod.POST, consumes = "application/json")
    @ResponseBody
    public BaseResponse eidtFreightRule(@RequestBody AddFreightRuleVo addFreightRuleVo) {
        if (CollectionUtil.isEmpty(addFreightRuleVo.getStoreFreightRuleDtos())) {
            return null;
        }
        return freightRuleService.eidtFreightRule(addFreightRuleVo.getStoreFreightRuleDtos());
    }

    @RequestMapping("getFreightRule")
    @ResponseBody
    public Map getFreightRule() {
        String storeId = StoreInfoUtil.getStoreId();
        List<StoreFreightRuleDto> storeFreightRuleDtos = storeFreightRuleApi.findByStoreId(storeId);
        Map returnMap = new HashMap(16);
        List<StoreFreightRuleDto> normalrRules = null;
        List<StoreFreightRuleDto> specialRules = null;
        if (!Lang.isEmpty(storeFreightRuleDtos)) {
            Map<String, List<StoreFreightRuleDto>> map = storeFreightRuleDtos.stream().collect(Collectors.groupingBy(StoreFreightRuleDto::getRuleType));
            normalrRules = map.get(StoreFreightRuleDto.CURRENCY_RULE);
            specialRules = map.get(StoreFreightRuleDto.SPECIAL_RULE);
        }
        returnMap.put("normalrRules", normalrRules);
        returnMap.put("specialRules", specialRules);
        List<StoreFreightRuleDto> storeFreightRuleDtoList = null;
        if (!Lang.isEmpty(specialRules)) {
            storeFreightRuleDtoList = new ArrayList<>();
            Map<String, List<StoreFreightRuleDto>> speMap = specialRules.stream().collect(Collectors.groupingBy(sr -> sr.getFreePrice().toString() + "_" + sr.getFreightPrice().toString()));
            Iterator it = speMap.keySet().iterator();
            while (it.hasNext()) {
                String key = it.next().toString();
                List<StoreFreightRuleDto> itlist = speMap.get(key);
                String address = "";
                String addresscode = "";
                for (int i = 0; i < itlist.size(); i++) {
                    if (i != itlist.size() - 1) {
                        address = address + itlist.get(i).getLevelOneAddressName() + "、";
                        addresscode = addresscode + itlist.get(i).getLevelOneAddressCode() + "、";
                    } else {
                        address = address + itlist.get(i).getLevelOneAddressName();
                        addresscode = addresscode + itlist.get(i).getLevelOneAddressCode();
                    }
                }
                StoreFreightRuleDto dto = new StoreFreightRuleDto();
                dto.setLevelOneAddressName(address);
                dto.setStoreId(itlist.get(0).getStoreId());
                dto.setFreePrice(itlist.get(0).getFreePrice());
                dto.setFreightPrice(itlist.get(0).getFreightPrice());
                dto.setRuleType(itlist.get(0).getRuleType());
                dto.setLevelOneAddressCode(addresscode);
                storeFreightRuleDtoList.add(dto);
            }
            returnMap.put("special", storeFreightRuleDtoList);
        }
        return ResponseMapUtils.success(returnMap);
    }

    @RequestMapping("findAllProvince")
    @ResponseBody
    public List<AddressVo> findAllProvince() {
        CommonAddressReq commonAddressReq = new CommonAddressReq();
        commonAddressReq.setLevel(AddressCommonApi.AddressLevel.PROVINCE);
        commonAddressReq.setWithChildren(false);

        return addressCommonApi.commonAddressVoList(commonAddressReq);
    }


    @RequestMapping(value = "delSpecialRule", method = RequestMethod.POST, consumes = "application/json")
    @ResponseBody
    public BaseResponse delSpecialRule(@RequestBody AddFreightRuleVo addFreightRuleVo) {
        if (CollectionUtil.isEmpty(addFreightRuleVo.getStoreFreightRuleDtos())) {
            return null;
        }
        return freightRuleService.delSpecialRule(addFreightRuleVo.getStoreFreightRuleDtos());
    }

}
