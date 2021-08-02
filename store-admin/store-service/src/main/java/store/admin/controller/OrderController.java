package store.admin.controller;

import com.alibaba.fastjson.JSON;

import lombok.extern.slf4j.Slf4j;
import member.api.QueryOrderApi;
import member.api.QueryOrderRestApi;
import member.api.dto.core.CoreCompDepartUserDto;
import member.api.dto.core.CoreCompanyDto;
import member.api.dto.core.CoreUserDto;
import member.api.vo.CoreCompDepartUserVo;
import order.definication.TrdSpOrderStatus;
import order.vo.query.OrderDetailQueryVo;
import org.apache.commons.lang3.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import pool.commonUtil.MessageDictionary;
import provider.trdsp.api.SubOrderApi;
import provider.trdsp.api.SubOrderRestApi;
import sinomall.global.common.response.BaseResponse;
import store.admin.dto.OrderQueryDto;
import store.admin.dto.ShippingBatchImportDto;
import store.admin.service.OrderService;
import store.admin.utils.StoreInfoUtil;
import store.admin.vo.JqueryDataTablesVo;
import store.admin.vo.order.OrdersQueryVo;
import store.admin.vo.query.OrderBatchDealVo;
import store.admin.vo.query.OrderQueryVo;
import store.model.core.Store;
import supplierapi.vo.order.OrderMainDto;
import supplierapi.vo.order.SubOrderDto;
import utils.Lang;
import utils.date.DateUtils;
import utils.file.FileUtils;
import utils.sql.PageVo;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.beans.IntrospectionException;
import java.beans.PropertyDescriptor;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.text.DecimalFormat;
import java.util.*;
import java.util.stream.Collectors;


/**
 * Created by crj on 2016/12/8.
 * 林志强
 * 订单管理控制类
 */
@Slf4j
@Controller
@RequestMapping("order")
public class OrderController {

    @Autowired
    SubOrderRestApi subOrderApi;
    /*@Autowired
    OrderMainApi orderMainApi;*/
    @Autowired
    QueryOrderRestApi queryOrderApi;

    @Autowired
    OrderService orderService;

    @Value("${order.service.url}")
    private String orderServiceUrl;

    public static final RestTemplate restTemplate = new RestTemplate();


    /**
     * 卖家中心 ---  订单列表
     */
    @RequestMapping(value = "ordersList", method = RequestMethod.GET)
    public String testApi_ordersList() {
        return "order/ordersList";
    }

    /**
     * 订单数据分页
     **/
    @RequestMapping(value = {"", "orderList"}, method = RequestMethod.POST)
    @ResponseBody
    public Map queryOrders(JqueryDataTablesVo jqueryDataTablesVo, String trdOrderState, String orderNo, String beginTime, String endTime) {
        String storeId = StoreInfoUtil.getStoreId();
        if (StringUtils.isEmpty(storeId)
                || Lang.isEmpty(jqueryDataTablesVo)) {
            return null;
        }
        OrderQueryDto orderQueryDto = new OrderQueryDto();
        orderQueryDto.setStoreId(storeId);
        orderQueryDto.setOrderNo(orderNo);
        orderQueryDto.setTrdOrderState(trdOrderState);
        if (StringUtils.isNoneEmpty(beginTime)) {
            orderQueryDto.setBeginTime(DateUtils.strToDateLong(beginTime));
        }
        if (StringUtils.isNoneEmpty(endTime)) {
            orderQueryDto.setEndTime(DateUtils.strToDateLong(endTime));
        }
        BaseResponse<PageVo<OrdersQueryVo>> response = orderService.queryProviderOrdersPage(jqueryDataTablesVo, orderQueryDto);
        Map returnModel = new HashMap();
        if (response.isSuccess()) {
            PageVo<OrdersQueryVo> pageVO = response.getResult();
            List<OrdersQueryVo> result = pageVO.getResult();
            returnModel.put("aaData", result);
            returnModel.put("iTotalRecords", pageVO.getTotalCount());
            returnModel.put("iTotalDisplayRecords", pageVO.getTotalCount());
        }
        returnModel.put("status", response.isSuccess());
        returnModel.put("resultMessage", response.getResultMessage());
        return returnModel;
    }

    @RequestMapping(value = "checkOrderifAbove15Days", method = RequestMethod.POST)
    @ResponseBody
    public BaseResponse checkOrderifAbove15Days(String orderNo) {
        //这里的storeID不可以为页面上显示的ID，而是session里面的供应商ID
        String storeId = StoreInfoUtil.getStoreId();
        if (StringUtils.isEmpty(storeId) || StringUtils.isEmpty(orderNo)) {
            return new BaseResponse(false, MessageDictionary.RETURN_INTERNAL_ERROR_MESSAGE, MessageDictionary.RETURN_INTERNAL_ERROR_MESSAGE, MessageDictionary.RETURN_INTERNAL_EXCEPTION_CODE);
        }
        SubOrderDto subOrderDto = subOrderApi.findBySubOrderNoAndProviderId(orderNo, storeId);
        // 2018-12-17 电商法需求-用户确认收获后供应商即可确认收货
        if (OrderMainDto.order_status_finish.equals(subOrderDto.getOrder().getStatus())) {
            return new BaseResponse(true, MessageDictionary.RETURN_SUCCESS_MESSAGE, MessageDictionary.RETURN_SUCCESS_MESSAGE, MessageDictionary.RETURN_SUCCESS_CODE);
        }
        // 确认订单的时间操作
        Date lastUpdated = subOrderDto.getLastUpdated();
        Date date = new Date();
        long l = date.getTime() - lastUpdated.getTime();
        if (l >= 3600 * 24 * 15 * 1000) {
            // 大于15天
            return new BaseResponse(true, MessageDictionary.RETURN_SUCCESS_MESSAGE, MessageDictionary.RETURN_SUCCESS_MESSAGE, MessageDictionary.RETURN_SUCCESS_CODE);
        } else {
            return new BaseResponse(false, MessageDictionary.RETURN_SUCCESS_MESSAGE, MessageDictionary.RETURN_SUCCESS_MESSAGE, MessageDictionary.NEED_TO_PROVIDER_SURE);
        }
    }

    /**
     * 供应商方确认订单
     **/
    @RequestMapping(value = {"sureOrdersByOrderId"}, method = RequestMethod.POST)
    @ResponseBody
    public BaseResponse sureOrdersByOrderId(String orderNo) {
        BaseResponse baseResponse = orderService.sureOrdersByOrderId(orderNo);
        return baseResponse;
    }

    /**
     * 供应商方订单状态数据
     **/
    @RequestMapping(value = {"batchWithOrders"}, method = RequestMethod.POST)
    @ResponseBody
    public BaseResponse batchWithOrders(@RequestBody OrderBatchDealVo orderBatchDealVo) {
        BaseResponse baseResponse = orderService.batchWithOrders(orderBatchDealVo);
        return baseResponse;
    }

    /**
     * 供应商方订单详细数据
     **/
    @RequestMapping(value = {"orderDetails"}, method = RequestMethod.POST)
    @ResponseBody
    public String getOrderDetails(String orderNo) {
        BaseResponse<OrderDetailQueryVo> baseResponse = orderService.queryProviderOrdersDetails(orderNo);
        return JSON.toJSONString(baseResponse);
    }

    /**
     * 供应商方订单状态数据
     **/
    @RequestMapping(value = {"orderDetailPage"}, method = RequestMethod.GET)
    public String orderDetailPage() {
        return "order/orderDetail";
    }

    /**
     * 供应商方订单状态数据
     **/
    @RequestMapping(value = {"providerEnterOrderStatus"}, method = RequestMethod.POST)
    @ResponseBody
    public String getProviderEnterOrderStatus() {
        List<TrdSpOrderStatus> list = TrdSpOrderStatus.providerEnterOrderList;
        Map<String, String> map = new HashMap<>();
        list.stream().forEach(providerEnterOrder -> {
            map.put(providerEnterOrder.getCode(), providerEnterOrder.getDescription());
        });
        return JSON.toJSONString(map);
    }

    /**
     * 订单导出
     * <p>
     * taofeng
     */
    @ResponseBody
    @RequestMapping(value = {"orderExport"}, method = RequestMethod.POST)
    public ResponseEntity<byte[]> orderExport(String trdOrderState, String orderNo, String beginTime, String endTime) {
        ResponseEntity<byte[]> responseEntity = null;
        try {
            OrderQueryDto orderQueryDto = new OrderQueryDto();
            if (!Lang.isEmpty(trdOrderState)) {
                orderQueryDto.setTrdOrderState(trdOrderState);
            }
            if (!Lang.isEmpty(orderNo)) {
                orderQueryDto.setOrderNo(orderNo);
            }
            if (!Lang.isEmpty(beginTime)) {
                orderQueryDto.setBeginTime(DateUtils.strToDateLong(beginTime));
            }
            if (!Lang.isEmpty(endTime)) {
                orderQueryDto.setEndTime(DateUtils.strToDateLong(endTime));
            }
            if (!Lang.isEmpty(StoreInfoUtil.getStoreId())) {
                orderQueryDto.setStoreId(StoreInfoUtil.getStoreId());
            }
            byte[] data = orderService.orderExportService(orderQueryDto);
            String fileName = java.net.URLEncoder.encode("供应商订单管理-订单列表.xlsx", "UTF-8");
            //设置响应头让浏览器正确显示下载
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
            headers.setContentDispositionFormData("attachment", fileName);
            responseEntity = new ResponseEntity<>(data, headers, HttpStatus.OK);
        } catch (Exception e) {
            log.info("供应商订单管理-订单列表导出异常", e);
        }
        return responseEntity;
    }

    //get方法的公告列表查询
    @RequestMapping(value = {"", "list"}, method = RequestMethod.GET)
    public String index(Map model, HttpServletRequest request) {

        HttpSession session = request.getSession();
        Store store = (Store) session.getAttribute("store");
        CoreUserDto user = (CoreUserDto) session.getAttribute("user");


        CoreCompDepartUserDto examp = new CoreCompDepartUserDto();
        examp.setUserId(user.getId());
        // List<CoreCompDepartUserVo> relatedVoList = coreCompDepartUserApi.findRelatedVoByExample(examp);
        List<CoreCompDepartUserVo> relatedVoList = null;

        CoreCompanyDto coreCompany = null;

        if (!Lang.isEmpty(relatedVoList)) {
            coreCompany = relatedVoList.get(0).getCoreCompany();
        }

        if (!Lang.isEmpty(coreCompany)) {
            model.put("company", coreCompany);
        }

        model.put("store", store);

        return "order/index";
    }

    /**
     * post方法的公告列表查询
     */
    @RequestMapping(value = {"", "list"}, method = RequestMethod.POST)
    @ResponseBody
    public Map query(JqueryDataTablesVo jqueryDataTablesVo, OrderQueryVo orderQueryVo, HttpServletRequest request) {

        HttpSession session = request.getSession();
        Store store = (Store) session.getAttribute("store");

        //获取前台额外传递过来的查询条件
        if (log.isDebugEnabled()) {
            log.debug("jqueryDataTablesVo:{}", jqueryDataTablesVo);
            log.debug("orderQueryVo:{}", orderQueryVo);
        }

        Sort.Order order = new Sort.Order(Sort.Direction.ASC, "create_time");
        List<Sort.Order> sortList = new ArrayList<>();
        sortList.add(order);
        Sort sort = new Sort(sortList);
        int pageindex = jqueryDataTablesVo.getiDisplayStart() / jqueryDataTablesVo.getiDisplayLength();
        Pageable pageable = new PageRequest(pageindex, jqueryDataTablesVo.getiDisplayLength(), sort);
        if (!Lang.isEmpty(store)) {
            orderQueryVo.setStoreId(store.getId());
        }

        PageVo permses = orderService.findOrderInfo(pageable, getMap(orderQueryVo));
        Map returnModel = new HashMap();
        if (Lang.isEmpty(permses) || permses.getResult().size() == 0) {
            returnModel.put("noDataTip", "很抱歉，系统找不到您的记录，换个条件试试！");
        }
        returnModel.putAll(jqueryDataTablesVo.toMap());
        returnModel.put("aaData", permses.getResult());
        returnModel.put("iTotalRecords", permses.getTotalCount());
        returnModel.put("iTotalDisplayRecords", permses.getTotalCount());
        return returnModel;
    }

    public Map<String, Object> getMap(OrderQueryVo orderQueryVo) {
        Map<String, Object> map = new HashMap<>();
        try {
            Class clazz = orderQueryVo.getClass();
            Field[] fields = orderQueryVo.getClass().getDeclaredFields();//获得属性
            for (Field field : fields) {
                PropertyDescriptor pd = new PropertyDescriptor(field.getName(), clazz);
                //获得get方法
                Method getMethod = pd.getReadMethod();
                //执行get方法返回一个Object
                Object o = getMethod.invoke(orderQueryVo);
                map.put(field.getName() + "", o);
            }
        } catch (SecurityException e) {
            e.printStackTrace();
        } catch (IllegalArgumentException e) {
            e.printStackTrace();
        } catch (IntrospectionException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        } catch (InvocationTargetException e) {
            e.printStackTrace();
        }
        return map;
    }

    /**
     * 查询订单详情
     *
     * @param map
     * @param orderNo
     * @return
     */
    @RequestMapping(value = {"orderDetail"}, method = RequestMethod.GET)
    public String orderDetail(Map map, String orderNo) {
        Map<String, Object> params = new HashMap<>();
        params.put("orderNo", orderNo);
        params.put("memberId", null);
        Map<String, Object> stringObjectMap = queryOrderApi.queryOrderDetail(params);
        if (!Lang.isEmpty(stringObjectMap)) {
            map.putAll(stringObjectMap);
        }
        return "order/orderDetail";
    }

    /**
     * 订单数据导出
     */
    @RequestMapping("outOrder")
    public void outOrder(OrderQueryVo orderQueryVo, HttpServletResponse response) {
        String codedFileName = "订单信息";
//        List<Map<String, Object>> result = orderMainApi.findOrderInfo(getMap(orderQueryVo));
//        List<Map<String, Object>> resultInfo = orderMainApi.findReturnInfo(getMap(orderQueryVo));
//        loadXls(codedFileName, result, resultInfo, response);
    }

    public void loadXls(String codedFileName, List<Map<String, Object>> result, List<Map<String, Object>> resultInfo, HttpServletResponse response) {
        response.setContentType("application/vnd.ms-excel");
        OutputStream fOut = null;
        try {
            // 进行转码，使其支持中文文件名
            codedFileName = java.net.URLEncoder.encode("中文", "UTF-8");
            response.setHeader("content-disposition", "attachment;filename=" + codedFileName + ".xls");
            // 产生工作簿对象
            XSSFWorkbook workbook = new XSSFWorkbook();
            if (!Lang.isEmpty(result)) {
                workbook = loadResult(result, workbook);
            }
            if (!Lang.isEmpty(resultInfo)) {
                workbook = loadResult(resultInfo, workbook);
            }
            fOut = response.getOutputStream();
            workbook.write(fOut);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                fOut.flush();
                fOut.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * 导入数据
     */
    public XSSFWorkbook loadResult(List<Map<String, Object>> result, XSSFWorkbook workbook) {
        if (!Lang.isEmpty(result)) {
            //产生工作表对象
            XSSFSheet sheet = workbook.createSheet();
            for (int i = 0; i < result.size(); i++) {
                XSSFRow row = sheet.createRow((int) i);//创建一行
                Map<String, Object> mapResult = result.get(i);
                Iterator it = mapResult.keySet().iterator();
                int accout = 0;
                while (it.hasNext()) {
                    XSSFCell cell = row.createCell((int) accout);//创建一列
                    cell.setCellType(HSSFCell.CELL_TYPE_STRING);
                    Object o = mapResult.get(it.next() + "");
                    if (!Lang.isEmpty(o)) {
                        cell.setCellValue(o + "");
                    } else {
                        cell.setCellValue("");
                    }
                    accout++;
                }
            }
        }
        return workbook;
    }


    @RequestMapping(value = "addShipping")
    public String addShipping(String orderNo, Map model) {
        model.put("orderNo", orderNo);
        return "order/addShipping";
    }

    @RequestMapping(value = "editShipping")
    public String editShipping(String orderNo, Map model) {
        model.put("orderNo", orderNo);
        return "order/editShipping";
    }

    /**
     * @author taofeng
     * @date 2019/11/4
     * <p>
     * 订单批量添加物流模板下载
     */
    @RequestMapping(value = "downBatchExcel")
    public void downBatchExcel(HttpServletRequest request, HttpServletResponse response) {
        try {
            //设置Excel表格名字
            response.setHeader("Content-disposition", "attachment; filename=" + FileUtils.transCharacter(request, "订单批量添加物流模板下载.xlsx"));
            orderService.checkBatchExcelOut(response.getOutputStream());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * @author taofeng
     * @date 2019/11/4
     * <p>
     * 订单批量添加物流
     */
    @ResponseBody
    @RequestMapping("batchImportExcel")
    public Map batchImportExcel(HttpServletRequest request) {
        Map returnMap = new HashMap();
        String storeId = StoreInfoUtil.getStoreId();
        if (StringUtils.isEmpty(storeId)) {
            returnMap.put("errorMsg", "系统错误,供应商校验未通过");
            return returnMap;
        }
        MultipartHttpServletRequest multiRequest = (MultipartHttpServletRequest) request;
        MultipartFile file = multiRequest.getFile("file");
        String fileName = file.getOriginalFilename();
        DecimalFormat df = new DecimalFormat("#.##");
        List<ShippingBatchImportDto> returnList = new ArrayList<>();
        List<Map> icMapList = new ArrayList<>();
        String errorMsg = null;
        try {
            InputStream inputStream = file.getInputStream();
            String stuff = fileName.substring(fileName.indexOf(".") + 1);
            Workbook wb;
            if (stuff.endsWith("xls")) {
                wb = new HSSFWorkbook(inputStream);
            } else {
                wb = new XSSFWorkbook(inputStream);
            }
            Sheet sheet = wb.getSheetAt(0);
            if (Lang.isEmpty(sheet)) {
                returnMap.put("errorMsg", "系统错误,excel生成失败");
                return returnMap;
            }
            int rowNum = sheet.getPhysicalNumberOfRows();
            //封装导入的数据
            for (int i = 1; i < rowNum; i++) {
                Row row = sheet.getRow(i);
                if (Lang.isEmpty(row)) {
                    continue;
                }
                Map icMap = new HashMap();
                for (int j = 0; j < 4; j++) {
                    Cell cell = row.getCell(j);
                    Object value = null;
                    if (!Lang.isEmpty(cell)) {
                        if (cell.getCellType() == Cell.CELL_TYPE_NUMERIC) {
                            value = df.format(cell.getNumericCellValue());
                        } else if (cell.getCellType() == Cell.CELL_TYPE_STRING) {
                            value = cell.getStringCellValue().trim();
                        }
                    }
                    icMap.put(j, Lang.isEmpty(value) ? "" : value);
                }
                if (icMap.size() == 4) {
                    int keyCount = 0;
                    for (Object key : icMap.keySet()) {
                        if (Lang.isEmpty(icMap.get(key))) {
                            keyCount++;
                        }
                    }
                    if (keyCount < 4) {
                        icMapList.add(icMap);
                    }
                }
            }
            if (icMapList.size() > 0) {
                //获取导入的数据
                int importNum = icMapList.size();
                List<ShippingBatchImportDto> importDtos = new ArrayList<>();
                for (int i = 0; i < importNum; i++) {
                    ShippingBatchImportDto importDto = new ShippingBatchImportDto();
                    Map mapitem = icMapList.get(i);
                    importDto.setOrderNo(String.valueOf(mapitem.get(0)).trim());
                    importDto.setLogisticCompanyName(String.valueOf(mapitem.get(1)).trim());
                    importDto.setShippingNo(String.valueOf(mapitem.get(2)).trim());
                    importDtos.add(importDto);
                }
                returnList = orderService.batchImportExcel(importDtos, storeId);
                List<ShippingBatchImportDto> errorList = returnList.stream()
                        .filter(dto -> Lang.isEmpty(dto.getSuccess()) || !dto.getSuccess())
                        .collect(Collectors.toList());
                int errorSize = errorList.size();
                returnMap.put("errorSize", errorSize);
                /*List<ShippingBatchImportDto> successList = returnList.stream()
                        .filter(dto -> !Lang.isEmpty(dto.getSuccess()) && dto.getSuccess())
                        .collect(Collectors.toList());*/
            }
        } catch (IOException e) {
            errorMsg = "文件导入异常";
            log.info("文件导入异常", e);
        }
        returnMap.put("returnList", returnList);
        returnMap.put("errorMsg", errorMsg);
        return returnMap;
    }

    @RequestMapping(value = "downloadReturnList", method = RequestMethod.POST)
    public ResponseEntity<byte[]> downloadReturnList(String returnList) {
        ResponseEntity<byte[]> responseEntity = null;
        try {
            List<ShippingBatchImportDto> shippingBatchImportDtos = JSON.parseArray(returnList, ShippingBatchImportDto.class);
            responseEntity = orderService.downloadReturnList(shippingBatchImportDtos);
        } catch (Exception e) {
            log.info("订单批量添加物流结果导出异常", e);
        }
        return responseEntity;
    }

}
