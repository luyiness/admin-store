package store.admin.vo.query;

import java.io.Serializable;

/**
 * Created by 31714 on 2016/12/21.
 */
public class GoodsQueryVo implements Serializable {
    private String goods_name;
    private String goods_state;

    public String getGoods_name() {
        return goods_name;
    }

    public void setGoods_name(String goods_name) {
        this.goods_name = goods_name;
    }

    public String getGoods_state() {
        return goods_state;
    }

    public void setGoods_state(String goods_state) {
        this.goods_state = goods_state;
    }
}
