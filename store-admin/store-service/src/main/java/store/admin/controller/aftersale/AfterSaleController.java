package store.admin.controller.aftersale;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping(value = "afterSale")
public class AfterSaleController {


    @RequestMapping(value = "")
    public String index() {
        return "afterSale/index";
    }

    @RequestMapping(value = "address")
    public String address() {
        return "afterSale/address";
    }

}
