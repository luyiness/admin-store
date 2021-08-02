package store.admin.vo;

import lombok.Data;

import java.util.ArrayList;

/**
 * Created by ChenGeng on 2016/12/21.
 */
@Data
public class BatchDealOrderVo {

    private  ArrayList<String>  sucList ;
    private  ArrayList<String>  timeList;
    private  ArrayList<String>  failList;


}
