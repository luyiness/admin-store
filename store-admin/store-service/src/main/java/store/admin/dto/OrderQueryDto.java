package store.admin.dto;

import lombok.Data;

import java.io.Serializable;
import java.util.Date;

/**
 * @author xjw
 * @version v1.0
 * @date 2018年8月22日 15:47:52
 */
@Data
public class OrderQueryDto implements Serializable {

    //页码
    private Integer pageNo;

    //页大小
    private Integer pageSize;

    //订单NO
    private String orderNo;

    //开始时间
    /*@JSONField(format = "yyyy-MM-dd HH:mm:ss")*/
    private Date beginTime;

    //结束时间
    /*@JSONField(format = "yyyy-MM-dd HH:mm:ss")*/
    private Date endTime;

    //供应商ID
    private String storeId;

    //订单状态
    private String trdOrderState;

}
