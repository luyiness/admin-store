package store.admin.vo.query;

/**
 * Created by crj on 2016/12/8.
 */
public class OrderQueryVo {
    /*
        订单管理中相关变量查询
        所属机构，订单状态，店铺，订单号，下单人，下单日期
     */
    private String status;
    private String storeId;
    private String orderNo;
    private String memberId;
    private String startTime;
    private String endTime;
    private String coreuserId_1;
    private String coreuserId_2;
    private String coreuserId_3;

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getStoreId() {
        return storeId;
    }

    public void setStoreId(String storeId) {
        this.storeId = storeId;
    }

    public String getOrderNo() {
        return orderNo;
    }

    public void setOrderNo(String orderNo) {
        this.orderNo = orderNo;
    }

    public String getMemberId() {
        return memberId;
    }

    public void setMemberId(String memberId) {
        this.memberId = memberId;
    }

    public String getStartTime() {
        return startTime;
    }

    public void setStartTime(String startTime) {
        this.startTime = startTime;
    }

    public String getEndTime() {
        return endTime;
    }

    public void setEndTime(String endTime) {
        this.endTime = endTime;
    }

    public String getCoreuserId_1() {
        return coreuserId_1;
    }

    public void setCoreuserId_1(String coreuserId_1) {
        this.coreuserId_1 = coreuserId_1;
    }

    public String getCoreuserId_2() {
        return coreuserId_2;
    }

    public void setCoreuserId_2(String coreuserId_2) {
        this.coreuserId_2 = coreuserId_2;
    }

    public String getCoreuserId_3() {
        return coreuserId_3;
    }

    public void setCoreuserId_3(String coreuserId_3) {
        this.coreuserId_3 = coreuserId_3;
    }
}
