package store.admin.vo;

import lombok.Data;
import store.api.dto.localstore.StoreFreightRuleDto;

import java.io.Serializable;
import java.util.List;

/**
 * @author: taofeng
 * @create: 2019-12-04
 **/
@Data
public class AddFreightRuleVo implements Serializable {

    private List<StoreFreightRuleDto> storeFreightRuleDtos;

}
