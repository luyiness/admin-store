package store.admin.vo.query;

import lombok.Data;

import java.io.Serializable;

/**
 * Created by ChenGeng on 2016/10/21.
 */
@Data
public class AdminUserQueryVo implements Serializable {

    private String username;
    private String validFlag;
    private String systemId;


}
