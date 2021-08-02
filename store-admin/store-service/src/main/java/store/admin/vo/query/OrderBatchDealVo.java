package store.admin.vo.query;

import java.io.Serializable;
import java.util.List;

/**
 * Created by xjw on 2018年8月25日 11:27:19.
 */
public class OrderBatchDealVo implements Serializable {
    private List<String> orderNo;

    private String flag;

    public List<String> getOrderNo() {
        return orderNo;
    }

    public void setOrderNo(List<String> orderNo) {
        this.orderNo = orderNo;
    }

    public String getFlag() {
        return flag;
    }

    public void setFlag(String flag) {
        this.flag = flag;
    }

    @Override
    public String toString() {
        return "OrderBatchDealVo{" +
                "orderNo=" + orderNo +
                ", flag='" + flag + '\'' +
                '}';
    }
}
