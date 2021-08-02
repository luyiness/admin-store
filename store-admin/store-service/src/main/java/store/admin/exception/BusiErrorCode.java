package store.admin.exception;

/**
 * @author Lans
 * @date 2018-7-9 14:41
 */
public enum BusiErrorCode {

    ERROR_PRAM("3001", "参数错误"),
    ERROR_STATE("4005", "订单状态错误"),
    IF_ABOVE_FIFTEEN_DAYS("5001", "确认订单未超过15天，请确认订单超过15天后再试。"),
    UNKNOWN_ERROR("6001", "系统繁忙，请稍后再试...."),
    SHIPPING_CONFIG_ERROR("7001", " 物流配置错误");

    private String value;
    private String desc;

    private BusiErrorCode(String value, String desc) {
        this.setValue(value);
        this.setDesc(desc);
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public String getDesc() {
        return desc;
    }

    public void setDesc(String desc) {
        this.desc = desc;
    }

    @Override
    public String toString() {
        return "--" + this.value + "--" + this.desc;
    }

}
