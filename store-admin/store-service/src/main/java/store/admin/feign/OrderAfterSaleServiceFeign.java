package store.admin.feign;

import aftersale.api.dto.orderaftersale.req.UpdateOrderAfterSaleStatusReq;
import org.springframework.cloud.netflix.feign.FeignClient;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import sinomall.config.response.RestfulBaseResponse;
import store.admin.feign.fallback.OrderAfterSaleServiceFeignFallback;

/**
 * @author Drury
 * @date 2020/7/20
 */
@FeignClient(url = "${order.service.url}", name = "order", fallbackFactory = OrderAfterSaleServiceFeignFallback.class)
public interface OrderAfterSaleServiceFeign {

    /**
     * 更新订单售后状态
     *
     * @param updateOrderAfterSaleStatusReq 更新订单售后状态请求对象
     * @return RestfulBaseResponse<Boolean>
     */
    @PostMapping(value = "/order/afterSale/updateOrderAfterSaleStatus")
    RestfulBaseResponse<Boolean> updateOrderAfterSaleStatus(@RequestBody UpdateOrderAfterSaleStatusReq updateOrderAfterSaleStatusReq);
}
