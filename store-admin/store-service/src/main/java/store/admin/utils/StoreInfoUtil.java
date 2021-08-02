package store.admin.utils;

import admin.model.AdminUser;
import org.apache.shiro.SecurityUtils;

/**
 * @author torvalds on 2018/9/9 19:41.
 * @version 1.0
 */
public class StoreInfoUtil {
    public static final String STORE_MANAGER = "user";
    public final static String STORE_ID_KEY = "STORE_ADMIN_SESSION_ID";

    public static String getStoreId() {
        return ((AdminUser) SecurityUtils.getSubject().getSession().getAttribute(STORE_MANAGER)).getBusinessModuleId();
    }
}
