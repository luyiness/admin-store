package store.admin.controller;

import com.alibaba.fastjson.JSON;

import lombok.extern.slf4j.Slf4j;
import order.dto.OrderMainDto;
import order.vo.SubOrderDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;
import pool.commonUtil.MessageDictionary;
import provider.trdsp.api.SubOrderApi;
import provider.trdsp.api.SubOrderRestApi;
import shipping.api.LogisticsCompanyApi;
import shipping.api.LogisticsCompanyRestApi;
import shipping.api.dto.LogisticCompanyDto;
import sinomall.config.response.RestfulBaseResponse;
import sinomall.global.common.response.BaseResponse;
import store.admin.utils.StoreInfoUtil;
import store.api.MallShippingApi;
import store.api.MallShippingRestApi;
import store.api.dto.mapdto.MallShippingDto;
import store.api.vo.MallShippingVo;
import supplierapi.api.SupplierProductApi;
import supplierapi.api.SupplierProductRestApi;
import supplierapi.vo.OrderShippingPackageVo;
import utils.Lang;
import utils.collection.CollectionUtil;
import utils.data.CopyUtil;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author 张代春
 * @date 2018/8/21
 */
@Slf4j
@Controller
@RequestMapping("mallShipping")
public class MallShippingController {

    @Autowired
    MallShippingRestApi mallShippingApi;
    /*@Autowired
    OrderMainApi orderMainApi;*/
    @Autowired
    SubOrderRestApi subOrderApi;
    @Autowired
    LogisticsCompanyRestApi logisticsCompanyApi;
    @Autowired
    SupplierProductRestApi supplierProductApi;

    @Value("${order.service.url}")
    private String orderServiceUrl;

    public static final RestTemplate restTemplate = new RestTemplate();

    /**
     * 查询所有的物流公司
     *
     * @return
     */
    @RequestMapping(value = "/findUsAbleLogisticsCompany", method = RequestMethod.POST)
    @ResponseBody
    public BaseResponse<List<LogisticCompanyDto>> findUsAbleLogisticsCompany() {
//        List<LogisticCompanyDto> usAbleLogisticsCompany = logisticsCompanyApi.findUsAbleLogisticsCompany();
        List<LogisticCompanyDto> usAbleLogisticsCompany = logisticsCompanyApi.findCommonUseableLogisticsCompany();
        BaseResponse baseResponse = new BaseResponse();
        if (!Lang.isEmpty(usAbleLogisticsCompany)) {
            baseResponse.setSuccess(true);
            baseResponse.setResult(usAbleLogisticsCompany);
        } else {
            baseResponse.setSuccess(false);
            baseResponse.setResult(null);
        }
        return baseResponse;
    }

    @RequestMapping(value = "/shippingLine", method = RequestMethod.POST)
    @ResponseBody
    public BaseResponse shippingLine(String subOrderNo, String shippingNo) {
        String storeId = null;
        if (!Lang.isEmpty(StoreInfoUtil.getStoreId())) {
            storeId = StoreInfoUtil.getStoreId();
        }
        if (Lang.isEmpty(subOrderNo) || Lang.isEmpty(storeId)) {
            log.info("MallShippingController.shippingLine---subOrderNo:{} storeId:{}", subOrderNo, storeId);
            return new BaseResponse(false, "error");
        }
        List<OrderShippingPackageVo> shipingTrace;
        try {
            shipingTrace = supplierProductApi.getShipingTrace(storeId, subOrderNo);
        } catch (RuntimeException re) {
            log.info("MallShippingController.shippingLine---:{} storeId:{}", subOrderNo, storeId, re);
            return new BaseResponse(false, re.getMessage());
        } catch (Exception e) {
            log.info("MallShippingController.shippingLine---:{} storeId:{}", subOrderNo, storeId, e);
            return new BaseResponse(false, "error");
        }
        if (CollectionUtil.isEmpty(shipingTrace)) {
            log.info("MallShippingController.shippingLine---OrderShippingPackageVos is null");
            return new BaseResponse(false, "error");
        }
        for (OrderShippingPackageVo orderShippingPackageVo : shipingTrace) {
            if (shippingNo.equals(orderShippingPackageVo.getTrdSubOrderNo())
                    && CollectionUtil.isNoneEmpty(orderShippingPackageVo.getTrackInfoList())) {
                OrderShippingPackageVo orderShippingPackageVos = new OrderShippingPackageVo();
                orderShippingPackageVos.setReceiptsFlag(orderShippingPackageVo.getReceiptsFlag());
                orderShippingPackageVos.setPackageId(orderShippingPackageVo.getPackageId());
                orderShippingPackageVos.setTrackInfoList(orderShippingPackageVo.getTrackInfoList());
                orderShippingPackageVos.setShippingTime(orderShippingPackageVo.getShippingTime());
                orderShippingPackageVos.setTrdSubOrderNo(orderShippingPackageVo.getTrdSubOrderNo());
                orderShippingPackageVos.setStatus(orderShippingPackageVo.getStatus());
                orderShippingPackageVos.setPackageName(orderShippingPackageVo.getPackageName());
                orderShippingPackageVos.setReceiveTime(orderShippingPackageVo.getReceiveTime());
                return new BaseResponse(true, "success", orderShippingPackageVos);
            }
        }
        return new BaseResponse(false, "error");
    }

    /**
     * 添加物流订单信息
     */
    @RequestMapping(value = "/addShipping", method = RequestMethod.POST)
    @ResponseBody
    public BaseResponse addMallShipping(@RequestBody MallShippingVo mallShippingVo) {
        return mallShippingApi.addMallShipping(mallShippingVo);
    }

    /**
     * 删除订单物流信息
     */
    @RequestMapping(value = "/deleteShipping", method = RequestMethod.POST)
    @ResponseBody
    public Boolean deleteMallShipping(String id) {
        return mallShippingApi.deleteMallShipping(id);
    }

    /**
     * 查询订单物流信息（根据ID）
     */
    @RequestMapping(value = "/queryShippingById", method = RequestMethod.POST)
    @ResponseBody
    public MallShippingVo queryShippingById(String id) {
        MallShippingDto mallShippingDto = mallShippingApi.queryShippingById(id);
        return CopyUtil.map(mallShippingDto, MallShippingVo.class);
    }

    /**
     * 初始化添加物流页
     */
    @RequestMapping(value = "/queryShipping", method = RequestMethod.GET)
    @ResponseBody
    public Map queryMallShipping(String orderNo) {
        String storeId = "";
        if (!Lang.isEmpty(StoreInfoUtil.getStoreId()))
            //这里的storeID不可以为页面上显示的ID，而是session里面的供应商ID
            storeId = StoreInfoUtil.getStoreId();

        if (Lang.isEmpty(orderNo) || Lang.isEmpty(storeId)) {
            log.info("mallShipping:{},userId:{}", orderNo, storeId);
            return null;
        }
        HashMap returnMap = new HashMap();
        List<MallShippingDto> mallShippings = mallShippingApi.findMallShipping(orderNo);
//        OrderMainDto orderMainDto = orderMainApi.findByOrderNoAndProviderId(orderNo, storeId);
        String BASE_URI = orderServiceUrl + "/orderMain/findByOrderNoAndStoreId";
        MultiValueMap<String, String> paramMap = new LinkedMultiValueMap<>();
        paramMap.add("orderNo", orderNo);
        paramMap.add("storeId", storeId);
        RestfulBaseResponse response =restTemplate.postForObject(BASE_URI, paramMap,RestfulBaseResponse.class);
        if(Lang.isEmpty(response) || Lang.isEmpty(response.getResult())) {
            throw new IllegalArgumentException("未查询到订单");
        }
        OrderMainDto orderMainDto;
        try {
            orderMainDto = JSON.parseObject(JSON.toJSONString(response.getResult()), OrderMainDto.class);
        }catch (Exception e) {
            throw new IllegalArgumentException("订单查询异常");
        }

        returnMap.put("orderMainDto", orderMainDto);
        returnMap.put("mallShippings", mallShippings);
        returnMap.put("success", true);
        return returnMap;
    }

    @RequestMapping(value = "/sureOrderShipping", method = RequestMethod.POST)
    @ResponseBody
    public BaseResponse sureOrderShipping(String orderNo) {
        String storeId = StoreInfoUtil.getStoreId();
        if (Lang.isEmpty(orderNo) || "".equals(storeId)) {
            log.error("mallShipping:{},storeId:{}", orderNo, storeId);
            return new BaseResponse(false, MessageDictionary.RETURN_ERROR_MESSAGE, MessageDictionary.RETURN_SESSSION_OR_NOORDER_ERROR_MESSAGE, MessageDictionary.RETURN_ERROR_MESSAGE);
        }
        List<MallShippingDto> mallShippings = mallShippingApi.findMallShipping(orderNo);
//        OrderMainDto orderMainDto = orderMainApi.findByOrderNoAndProviderId(orderNo, storeId);

        String BASE_URI = orderServiceUrl + "/orderMain/findByOrderNoAndStoreId";
        MultiValueMap<String, String> paramMap = new LinkedMultiValueMap<>();
        paramMap.add("orderNo", orderNo);
        paramMap.add("storeId", storeId);
        RestfulBaseResponse response =restTemplate.postForObject(BASE_URI, paramMap,RestfulBaseResponse.class);
        if(Lang.isEmpty(response) || Lang.isEmpty(response.getResult())) {
            throw new IllegalArgumentException("未查询到订单");
        }
        OrderMainDto orderMainDto;
        try {
            orderMainDto = JSON.parseObject(JSON.toJSONString(response.getResult()), OrderMainDto.class);
        }catch (Exception e) {
            throw new IllegalArgumentException("订单查询异常");
        }
        if (Lang.isEmpty(mallShippings)) {
            return new BaseResponse(false, MessageDictionary.RETURN_ERROR_MESSAGE, MessageDictionary.RETURN_SHIPPING_ERROR_MESSAGE, MessageDictionary.RETURN_ERROR_MESSAGE);
        }
        //先暂时取第一个数据作为未拆单的数据
        List<SubOrderDto> subOrders = orderMainDto.getSubOrders();
        if (!Lang.isEmpty(subOrders)) {
            SubOrderDto subOrderDto = subOrders.get(0);
            if (!Lang.isEmpty(subOrderDto)) {
                String trdOrderState = subOrderDto.getTrdOrderState();
                try {
                    MallShippingDto mallShippingDto = mallShippings.get(0);
                    //状态机判断该数据是否 可以被确认为已发货
//                    subOrderApi.setSubOrderDelivered(subOrderDto.getSubOrderNo(), storeId, 1, mallShippingDto);
                    subOrderApi.setSubOrderDelivered(subOrderDto.getSubOrderNo(), storeId);
                } catch (Exception e) {
                    e.printStackTrace();
                    return new BaseResponse(false, MessageDictionary.RETURN_ERROR_MESSAGE, e.getMessage(), MessageDictionary.RETURN_ERROR_MESSAGE);
                }
            }
        }
        return new BaseResponse(true, MessageDictionary.RETURN_SUCCESS_MESSAGE, MessageDictionary.RETURN_SUCCESS_MESSAGE, MessageDictionary.RETURN_SUCCESS_CODE);
    }

}
