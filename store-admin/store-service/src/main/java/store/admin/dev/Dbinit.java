package store.admin.dev;



import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.PostConstruct;

/**
 * Created by xiaoqian on 2016/10/14.
 */
@Component
@Profile("dbinit")
public class Dbinit {





   @PostConstruct
   @Transactional
    public void postInit(){


    }
}
