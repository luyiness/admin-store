package store.admin.feign.fallback;

import aftersale.api.dto.orderaftersale.req.UpdateOrderAfterSaleStatusReq;
import feign.hystrix.FallbackFactory;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestMapping;
import sinomall.config.response.RestfulBaseResponse;
import store.admin.feign.OrderAfterSaleServiceFeign;

/**
 * @author Drury
 * @date 2020/7/20
 */
@Slf4j
@Service
@RequestMapping("fallback/order/afterSale")
public class OrderAfterSaleServiceFeignFallback implements FallbackFactory<OrderAfterSaleServiceFeign> {

    @Override
    public OrderAfterSaleServiceFeign create(Throwable throwable) {
        return new OrderAfterSaleServiceFeign() {

            @Override
            public RestfulBaseResponse<Boolean> updateOrderAfterSaleStatus(UpdateOrderAfterSaleStatusReq request) {
                log.error("feign 更新订单售后状态 fallback 处理, 请求参数 = {}", request, throwable);
                return RestfulBaseResponse.fail("updateOrderAfterSaleStatus feign error", "内部接口异常", "系统异常，请稍后再试");
            }

        };
    }
}
