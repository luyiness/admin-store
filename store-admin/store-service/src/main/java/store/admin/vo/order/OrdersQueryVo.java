package store.admin.vo.order;

import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

/**
 *
 * @author Jian
 * @date 2019-12-24
 */
@Data
public class OrdersQueryVo implements Serializable {

    private String orderNo;
    private String subOrderNo;
    private Date createdTime;
    private BigDecimal sumCostPrice;
    private BigDecimal sumNofreightPrice;
    private BigDecimal freight;
    private String addressName;
    private String logisticsNo;
    private String trdOrderState;
    private String recipientName;
    private String afterSaleType;
    private String afterSaleStatus;
    private String afterSaleStatusName;
    private String ifAfterSaling;
    private String afterSaleRefundType;

    public boolean equals(Object o) {
        if (o == this) {
            return true;
        } else if (!(o instanceof OrdersQueryVo)) {
            return false;
        } else {
            OrdersQueryVo other = (OrdersQueryVo) o;
            if (!other.canEqual(this)) {
                return false;
            } else {
                label95: {
                    String this$orderNo = this.getOrderNo();
                    String other$orderNo = other.getOrderNo();
                    if(this$orderNo == null) {
                        if(other$orderNo == null) {
                            break label95;
                        }
                    } else if(this$orderNo.equals(other$orderNo)) {
                        break label95;
                    }

                    return false;
                }

                String this$subOrderNo = this.getSubOrderNo();
                String other$subOrderNo = other.getSubOrderNo();
                if(this$subOrderNo == null) {
                    if(other$subOrderNo != null) {
                        return false;
                    }
                } else if(!this$subOrderNo.equals(other$subOrderNo)) {
                    return false;
                }

                Date this$createdTime = this.getCreatedTime();
                Date other$createdTime = other.getCreatedTime();
                if(this$createdTime == null) {
                    if(other$createdTime != null) {
                        return false;
                    }
                } else if(!this$createdTime.equals(other$createdTime)) {
                    return false;
                }

                label74: {
                    BigDecimal this$sumCostPrice = this.getSumCostPrice();
                    BigDecimal other$sumCostPrice = other.getSumCostPrice();
                    if(this$sumCostPrice == null) {
                        if(other$sumCostPrice == null) {
                            break label74;
                        }
                    } else if(this$sumCostPrice.equals(other$sumCostPrice)) {
                        break label74;
                    }

                    return false;
                }

                label67: {
                    String this$addressName = this.getAddressName();
                    String other$addressName = other.getAddressName();
                    if(this$addressName == null) {
                        if(other$addressName == null) {
                            break label67;
                        }
                    } else if(this$addressName.equals(other$addressName)) {
                        break label67;
                    }

                    return false;
                }

                String this$logisticsNo = this.getLogisticsNo();
                String other$logisticsNo = other.getLogisticsNo();
                if(this$logisticsNo == null) {
                    if(other$logisticsNo != null) {
                        return false;
                    }
                } else if(!this$logisticsNo.equals(other$logisticsNo)) {
                    return false;
                }

                String this$trdOrderState = this.getTrdOrderState();
                String other$trdOrderState = other.getTrdOrderState();
                if(this$trdOrderState == null) {
                    if(other$trdOrderState != null) {
                        return false;
                    }
                } else if(!this$trdOrderState.equals(other$trdOrderState)) {
                    return false;
                }

                return true;
            }
        }
    }

    protected boolean canEqual(Object other) {
        return other instanceof OrdersQueryVo;
    }

    public int hashCode() {
        boolean PRIME = true;
        byte result = 1;
        String $orderNo = this.getOrderNo();
        int result1 = result * 59 + ($orderNo == null?43:$orderNo.hashCode());
        String $subOrderNo = this.getSubOrderNo();
        result1 = result1 * 59 + ($subOrderNo == null?43:$subOrderNo.hashCode());
        Date $createdTime = this.getCreatedTime();
        result1 = result1 * 59 + ($createdTime == null?43:$createdTime.hashCode());
        BigDecimal $sumCostPrice = this.getSumCostPrice();
        result1 = result1 * 59 + ($sumCostPrice == null?43:$sumCostPrice.hashCode());
        String $addressName = this.getAddressName();
        result1 = result1 * 59 + ($addressName == null?43:$addressName.hashCode());
        String $logisticsNo = this.getLogisticsNo();
        result1 = result1 * 59 + ($logisticsNo == null?43:$logisticsNo.hashCode());
        String $trdOrderState = this.getTrdOrderState();
        result1 = result1 * 59 + ($trdOrderState == null?43:$trdOrderState.hashCode());
        return result1;
    }

    public String toString() {
        return "OrdersQueryVo(orderNo=" + this.getOrderNo() + ", subOrderNo=" + this.getSubOrderNo() + ", createdTime=" + this.getCreatedTime() + ", sumCostPrice=" + this.getSumCostPrice() + ", addressName=" + this.getAddressName() + ", logisticsNo=" + this.getLogisticsNo() + ", trdOrderState=" + this.getTrdOrderState() + ")";
    }
}
