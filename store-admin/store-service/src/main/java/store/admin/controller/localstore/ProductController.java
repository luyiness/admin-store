package store.admin.controller.localstore;

import com.alibaba.fastjson.JSON;
import com.google.common.util.concurrent.RateLimiter;

import goods.api.category.dto.response.ProductCategoryStandardDTO;
import lombok.extern.slf4j.Slf4j;
import member.api.vo.JsonModel;
import org.apache.commons.lang3.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import pool.commonUtil.MessageDictionary;
import pool.dto.*;
import pool.dto.brand.ProviderBrandGroupDto;
import pool.enums.NumberCommonUtils;
import pool.vo.ProviderGoodsVo;
import pool.vo.ProviderProductBrandVo;
import sinomall.global.common.response.BaseResponse;
import store.admin.dto.FreeFreightGoodsBatchImportDto;
import store.admin.service.localstore.ProductService;
import store.admin.utils.StoreInfoUtil;
import store.admin.vo.AddProductVo;
import store.admin.vo.JqueryDataTablesVo;
import store.admin.vo.query.ProductQueryVo;
import store.api.StoreExtApi;
import store.api.StoreExtRestApi;
import store.api.dto.modeldto.core.StoreExtDto;
import utils.Lang;
import utils.collection.CollectionUtil;
import utils.file.FileUtils;
import utils.sequence.SequenceUtil;
import utils.sql.PageVo;
import utils.web.ResponseMapUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.InputStream;
import java.text.DecimalFormat;
import java.util.*;
import java.util.stream.Collectors;

/**
 * @author: taofeng
 * @create: 2019-08-06
 **/
@Slf4j
@Controller
@RequestMapping("/product")
public class ProductController {

    @Autowired
    StoreExtRestApi storeExtApi;

    @Autowired
    SequenceUtil sequenceUtil;
    @Autowired
    ProductService productService;

    /**
     * ???????????????
     */
    @RequestMapping(value = "goodsList", method = RequestMethod.GET)
    public String goodsList(Map model) {
        String storeId = StoreInfoUtil.getStoreId();
        model.put("storeId", storeId);
        return "goods/goodsList";
    }

    /**
     * ?????????????????????
     */
    @RequestMapping(value = {"", "list"}, method = RequestMethod.POST)
    @ResponseBody
    public Map query(JqueryDataTablesVo jqueryDataTablesVo, ProductQueryVo productQueryVo) {
        BaseResponse<PageVo<ProviderGoodsVo>> response = productService.queryGoodsList(jqueryDataTablesVo, productQueryVo);
        PageVo<ProviderGoodsVo> goodses = response.getResult();
        List<ProviderGoodsVo> goodsList = new ArrayList<>();
        if (!Lang.isEmpty(goodses)) {
            for (ProviderGoodsVo providerGoodsVo : goodses.getResult()) {
                goodsList.add(providerGoodsVo);
            }
        }
        Map returnModel = new HashMap(16);
        returnModel.putAll(jqueryDataTablesVo.toMap());
        returnModel.put("aaData", goodsList);
        returnModel.put("iTotalRecords", goodses.getTotalCount());
        returnModel.put("iTotalDisplayRecords", goodses.getTotalCount());
        return returnModel;
    }

    /**
     * ???????????????
     */
    @RequestMapping(value = "addProduct", method = RequestMethod.GET)
    public String addProduct(String productCategoryId, Map model) {
        model.put("productCategoryId", productCategoryId);
        model.put("errorMsg", "");
        String modelSku = null;
        try {
            modelSku = sequenceUtil.getOrderNo("sku");
        } catch (InterruptedException e) {
            model.put("errorMsg", "??????modelSku??????");
            log.info("??????modelSku??????", e);
        }
        model.put("modelSku", modelSku);
        return "goods/addProduct";
    }

    /**
     * @author taofeng
     * @date 2019/11/8
     * <p>
     * ??????????????????
     */
    @RequestMapping(value = {"findBrand"}, method = RequestMethod.POST)
    @ResponseBody
    public BaseResponse findBrand(String name) {
        String storeId = StoreInfoUtil.getStoreId();
        if (StringUtils.isEmpty(storeId)) {
            return null;
        }
        List<ProviderBrandGroupDto> brandGroupDtos = productService.findBrand(storeId, name);
        if (CollectionUtil.isEmpty(brandGroupDtos)) {
            brandGroupDtos = new ArrayList<>();
        }
        return new BaseResponse(true, "success", brandGroupDtos);
    }

    /**
     * ????????????
     */
    @RequestMapping(value = "addProduct", method = RequestMethod.POST, consumes = "application/json")
    @ResponseBody
    public Map addProduct(@RequestBody AddProductVo addProductVo) {
        List<ProviderGoodsDto> providerGoodsDtos = addProductVo.getProviderGoodses();
        ProductModelDto productModelDto = addProductVo.getProductModel();
        productModelDto.setStoreId(StoreInfoUtil.getStoreId());
        Map map = productService.addProduct(productModelDto, providerGoodsDtos);
        return map;
    }

    /**
     * ???????????????
     */
    @RequestMapping(value = "editProduct")
    public String editProduct(String sku, Map model, @RequestParam(value = "key", required = false) String key) {
        String storeId = StoreInfoUtil.getStoreId();
        Map map = productService.findProduct(storeId, sku);
        String productCategoryId = "";
        if (!Lang.isEmpty(map)) {
            ProductModelDto productModel = (ProductModelDto) map.get("productModel");
            productCategoryId = productModel.getCategoryId();
        }
        model.put("key", key);
        model.put("goodsSku", sku);
        model.put("productCategoryId", productCategoryId);
        model.put("remark", "edit");
        return "goods/editProduct";
    }

    /**
     * ????????????
     */
    @RequestMapping(value = "editProduct", method = RequestMethod.POST, consumes = "application/json")
    @ResponseBody
    public Map editProduct(@RequestBody AddProductVo addProductVo) {
        addProductVo.getProductModel().setStoreId(StoreInfoUtil.getStoreId());
        return productService.updateProduct(addProductVo);
    }

    /**
     * ????????????
     */
    @RequestMapping("findProviderGoods")
    @ResponseBody
    public Map findProviderGoods(String goodsSku) {
        if (Lang.isEmpty(goodsSku)) {
            return ResponseMapUtils.error("??????????????????");
        }
        String storeId = StoreInfoUtil.getStoreId();
        Map map = productService.findProduct(storeId, goodsSku);
        return ResponseMapUtils.success(map);
    }

    /**
     * ????????????
     */
    @RequestMapping(value = {"deleteProduct"}, method = RequestMethod.POST)
    @ResponseBody
    public BaseResponse deleteProduct(@RequestParam("ids[]") String[] ids, String storeId) {
        List<String> skus = Arrays.asList(ids);
        return productService.deleteProviderGoodsBatch(skus, storeId);
    }

    /**
     * ???????????????
     */
    @RequestMapping(value = "productView")
    public String productView(String sku, Map model) {
        String storeId = StoreInfoUtil.getStoreId();
        Map map = productService.findProduct(storeId, sku);
        String productCategoryId = "";
        if (!Lang.isEmpty(map)) {
            ProductModelDto productModel = (ProductModelDto) map.get("productModel");
            productCategoryId = productModel.getCategoryId();
        }
        model.put("goodsSku", sku);
        model.put("productCategoryId", productCategoryId);
        model.put("remark", "productView");
        return "goods/editProduct";
    }

    @RequestMapping(value = {"getStoreName"}, method = RequestMethod.POST)
    @ResponseBody
    public BaseResponse getStoreName() {
        String storeId = StoreInfoUtil.getStoreId();
        if (StringUtils.isEmpty(storeId)) {
            log.info("???????????????????????????,????????????storeId");
            return new BaseResponse(false, "???????????????????????????,????????????storeId");
        }
        StoreExtDto storeExtDto = storeExtApi.findByStoreId(storeId);
        if (Lang.isEmpty(storeExtDto)) {
            log.info("???????????????????????????,???????????? storeId:{} ?????????storeExtDto", storeId);
            return new BaseResponse(false, "???????????????????????????,???????????? storeId:" + storeId + " ?????????storeExtDto");
        }
        return new BaseResponse(true, "???????????????????????????", storeExtDto.getStoreName());
    }

    /**
     * ???????????????
     */
    @RequestMapping(value = {"updateProduct"}, method = RequestMethod.POST)
    @ResponseBody
    public BaseResponse updateGoods(@RequestParam("ids[]") String[] ids, String status) {
        String storeId = StoreInfoUtil.getStoreId();
        if (Lang.isEmpty(storeId)) {
            return new BaseResponse(false, MessageDictionary.RETURN_NO_STORE_ID_MESSAGE, "", MessageDictionary.RETURN_NO_STORE_ID_MESSAGE);
        }
        List<ProviderGoodsStatus> providerGoodsStatusList = new ArrayList<>();
        if (ids != null && ids.length > 0) {
            for (String id : ids) {
                ProviderGoodsStatus providerGoodsStatus = new ProviderGoodsStatus();
                providerGoodsStatus.setSku(id);
                providerGoodsStatus.setStatus(status);
                providerGoodsStatusList.add(providerGoodsStatus);
            }
        }
        return productService.modifyGoodsStatus(providerGoodsStatusList, storeId);

    }

    /**
     * ??????????????????
     */
    @RequestMapping(value = {"getProductStockCount"}, method = RequestMethod.POST)
    @ResponseBody
    public BaseResponse getProductStockCount(String sku) {
        String storeId = StoreInfoUtil.getStoreId();
        if (Lang.isEmpty(storeId)) {
            return new BaseResponse(false, MessageDictionary.RETURN_NO_STORE_ID_MESSAGE, "", MessageDictionary.RETURN_NO_STORE_ID_MESSAGE);
        }
        BaseResponse<ProviderGoodsVo> providerGoodsVoBaseResponse = productService.queryProviderGoods(sku, storeId);
        ProviderGoodsVo result = providerGoodsVoBaseResponse.getResult();
        if (!Lang.isEmpty(result)) {
            Integer stockCount = result.getStockCount();
            return new BaseResponse(true, MessageDictionary.RETURN_SUCCESS_MESSAGE, stockCount, MessageDictionary.RETURN_SUCCESS_CODE);
        }
        return new BaseResponse(false, MessageDictionary.RETURN_INTERNAL_ERROR_MESSAGE, null, MessageDictionary.RETURN_RUNTIME_CONDITION_MISSING_CODE);
    }

    /**
     * ??????????????????
     */
    @RequestMapping(value = {"updateProductStockCount"}, method = RequestMethod.POST)
    @ResponseBody
    public BaseResponse updateProductStockCount(String sku, Integer stockCount) {
        String storeId = StoreInfoUtil.getStoreId();
        if (Lang.isEmpty(storeId)) {
            return new BaseResponse(false, MessageDictionary.RETURN_NO_STORE_ID_MESSAGE, "", MessageDictionary.RETURN_NO_STORE_ID_MESSAGE);
        }
        if (Lang.isEmpty(sku) || Lang.isEmpty(stockCount)) {
            return new BaseResponse(false, MessageDictionary.RETURN_INTERNAL_ERROR_MESSAGE, null, MessageDictionary.RETURN_RUNTIME_CONDITION_MISSING_CODE);
        }
        List<ProviderGoodsStock> providerGoodsStockList = new ArrayList<>();
        ProviderGoodsStock providerGoodsStock = new ProviderGoodsStock();
        providerGoodsStock.setSku(sku);
        providerGoodsStock.setStockCount(stockCount);
        providerGoodsStockList.add(providerGoodsStock);
        return productService.modifyGoodsStock(providerGoodsStockList, storeId);

    }

    @RequestMapping("getCategoryInfo")
    @ResponseBody
    public Map getCategoryInfo(String productCategoryId, String sku) {
        if (Lang.isEmpty(productCategoryId)) {
            return ResponseMapUtils.error("??????????????????");
        }
        String storeId = StoreInfoUtil.getStoreId();
        Map returnMap = new HashMap(16);
        long t1  = System.currentTimeMillis();
        if (StringUtils.isNoneEmpty(sku)) {
            Map map = productService.findProduct(storeId, sku);
            if (!Lang.isEmpty(map)) {
                List<ProviderGoodsDto> providerGoodsList = (List<ProviderGoodsDto>) map.get("providerGoodsList");
                if (CollectionUtil.isNoneEmpty(providerGoodsList)) {
                    ProviderProductBrandVo providerProductBrandVo = new ProviderProductBrandVo();
                    providerProductBrandVo.setId(providerGoodsList.get(0).getProviderBrandId());
                    providerProductBrandVo.setName(providerGoodsList.get(0).getProviderBrandName());
                    returnMap.put("brands", Arrays.asList(providerProductBrandVo));
                }
            }
        } else {
            //List<ProviderProductBrandVo> brandDtos = providerProductBrandApi.findByStoreId(storeId);
            returnMap.put("brands", new ArrayList<>());
        }
        long t2 = System.currentTimeMillis();
        log.info("???????????????????????????{}",t2-t1);
        List<String> categoryNames = productService.findAllNameById(productCategoryId);
        long t3 = System.currentTimeMillis();
        log.info("???????????????????????????{}",t3-t2);
        List<ProductCategoryStandardDTO> productCategoryStandardDTOS = productService.getCategoryStandard(productCategoryId);
        returnMap.put("categoryNames", categoryNames);
        log.info("?????????????????????????????????{}",System.currentTimeMillis()-t3);
        returnMap.put("productCategoryStandardDTOS", productCategoryStandardDTOS);
        return ResponseMapUtils.success(returnMap);
    }

    @RequestMapping(value = {"getCategoryTree"})
    @ResponseBody
    public List<JsonModel> getCategoryTree(String id) {
        return productService.findCategoryTree(id);
    }

    @RequestMapping(value = {"chooseCategory"})
    public String chooseCategory() {
        return "goods/chooseCategory";
    }


    /*-----------------------------?????????-----------------------------*/

    /**
     * @author taofeng
     * @date 2019/11/20
     * <p>
     * ????????????
     */
    @RequestMapping(value = "saveProduct", method = RequestMethod.POST, consumes = "application/json")
    @ResponseBody
    public BaseResponse saveProduct(@RequestBody AddProductVo addProductVo) {
        ProductModelDto productModelDto = addProductVo.getProductModel();
        productModelDto.setStoreId(StoreInfoUtil.getStoreId());
        List<ProviderGoodsDto> providerGoodsDtos = addProductVo.getProviderGoodses();
        return productService.saveProduct(productModelDto, providerGoodsDtos);
    }

    @RequestMapping(value = "getsku", method = RequestMethod.POST)
    @ResponseBody
    public String getsku() throws Exception {
        return sequenceUtil.getOrderNo("sku");
    }


    /**
     * @author taofeng
     * @date 2019/11/26
     * <p>
     * ????????????????????????????????????????????????
     */
    RateLimiter rateLimiter = RateLimiter.create(NumberCommonUtils.ONE.getValue());

    @RequestMapping(value = "categoryStandardSave", method = RequestMethod.POST)
    @ResponseBody
    public void categoryStandardSave(String standardName, String standardVal, String productCategoryId) {
        rateLimiter.acquire();
        if (StringUtils.isEmpty(standardName)
                || StringUtils.isEmpty(standardVal)
                || StringUtils.isEmpty(productCategoryId)) {
            return;
        }
        productService.categoryStandardSave(standardName, standardVal, productCategoryId);
    }

    /*-----------------------------?????????-----------------------------*/


    /**
     * ??????????????????
     * @param productSku
     * @param productName
     * @param productBrand
     * @param providerSaleStatus
     * @param categoryId
     * @param isFreeFreight
     * @return
     */
    @ResponseBody
    @RequestMapping(value = {"goodsExport"}, method = RequestMethod.POST)
    public ResponseEntity<byte[]> goodsExport(String productSku, String productName, String productBrand
            , String providerSaleStatus, String categoryId, String isFreeFreight
    ) {
        ResponseEntity<byte[]> responseEntity = null;
        try {
            ProductQueryVo productQueryVo = new ProductQueryVo();
            if (!Lang.isEmpty(productSku)) {
                productQueryVo.setProductSku(productSku);
            }
            if (!Lang.isEmpty(productBrand)) {
                productQueryVo.setProductBrand(productBrand);
            }
            if (!Lang.isEmpty(productName)) {
                productQueryVo.setProductName(productName);
            }
            if (!Lang.isEmpty(StoreInfoUtil.getStoreId())) {
                productQueryVo.setStoreId(StoreInfoUtil.getStoreId());
            }
            if (!Lang.isEmpty(providerSaleStatus)) {
                productQueryVo.setProviderSaleStatus(Integer.parseInt(providerSaleStatus));
            }
            if (!Lang.isEmpty(categoryId)) {
                productQueryVo.setCategoryId(categoryId);
            }
            if (!Lang.isEmpty(isFreeFreight)) {
                productQueryVo.setIsFreeFreight(isFreeFreight);
            }

            byte[] data = productService.goodsExportService(productQueryVo);
            String fileName = java.net.URLEncoder.encode("?????????????????????-????????????.xlsx", "UTF-8");
            //?????????????????????????????????????????????
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
            headers.setContentDispositionFormData("attachment", fileName);
            responseEntity = new ResponseEntity<>(data, headers, HttpStatus.OK);
        } catch (Exception e) {
            log.info("?????????????????????-????????????????????????", e);
        }
        return responseEntity;
    }



    /**
     * ????????????????????????
     */
    @RequestMapping(value = {"setUpFreeShippingGoods"}, method = RequestMethod.POST)
    @ResponseBody
    public BaseResponse setUpFreeShippingGoods(@RequestParam("ids[]") String[] ids, String status) {
        String storeId = StoreInfoUtil.getStoreId();
        if (Lang.isEmpty(storeId)) {
            return new BaseResponse(false, MessageDictionary.RETURN_NO_STORE_ID_MESSAGE, "", MessageDictionary.RETURN_NO_STORE_ID_MESSAGE);
        }
        List<ProviderGoodsFreeFreightDto> list = new ArrayList<>();
        if (ids != null && ids.length > 0) {
            for (String id : ids) {
                ProviderGoodsFreeFreightDto providerGoodsFreeFreightDto = new ProviderGoodsFreeFreightDto();
                providerGoodsFreeFreightDto.setSku(id);
                providerGoodsFreeFreightDto.setIsFreeFreight(status);
                providerGoodsFreeFreightDto.setStoreId(storeId);
                list.add(providerGoodsFreeFreightDto);
            }
        }
        return productService.modifyGoodsFreeFreight(list, storeId);
    }


    /**
     * ????????????????????????????????????
     * @param request
     * @param response
     */
    @RequestMapping(value = "downBatchExcel")
    public void downBatchExcel(HttpServletRequest request, HttpServletResponse response) {
        try {
            //??????Excel????????????
            response.setHeader("Content-disposition", "attachment; filename=" + FileUtils.transCharacter(request, "????????????????????????????????????.xlsx"));
            productService.checkBatchExcelOut(response.getOutputStream());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    /**
     * ????????????
     * @param returnList
     * @return
     */
    @RequestMapping(value = "downloadReturnList", method = RequestMethod.POST)
    public ResponseEntity<byte[]> downloadReturnList(String returnList) {
        ResponseEntity<byte[]> responseEntity = null;
        try {
            List<FreeFreightGoodsBatchImportDto> freeFreightGoodsBatchImportDtos = JSON.parseArray(returnList, FreeFreightGoodsBatchImportDto.class);
            responseEntity = productService.downloadReturnList(freeFreightGoodsBatchImportDtos);
        } catch (Exception e) {
            log.info("??????????????????", e);
        }
        return responseEntity;
    }


    /**
     * ????????????????????????
     * @param request
     * @return
     */
    @ResponseBody
    @RequestMapping("batchImportExcel")
    public Map batchImportExcel(HttpServletRequest request) {
        Map returnMap = new HashMap();
        String storeId = StoreInfoUtil.getStoreId();
        if (StringUtils.isEmpty(storeId)) {
            returnMap.put("errorMsg", "????????????,????????????????????????");
            return returnMap;
        }
        MultipartHttpServletRequest multiRequest = (MultipartHttpServletRequest) request;
        MultipartFile file = multiRequest.getFile("file");
        String fileName = file.getOriginalFilename();
        DecimalFormat df = new DecimalFormat("#.##");
        List<FreeFreightGoodsBatchImportDto> returnList = new ArrayList<>();
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
                returnMap.put("errorMsg", "????????????,excel????????????");
                return returnMap;
            }
            int rowNum = sheet.getPhysicalNumberOfRows();
            //?????????????????????
            for (int i = 1; i < rowNum; i++) {
                Row row = sheet.getRow(i);
                if (Lang.isEmpty(row)) {
                    continue;
                }
                Map icMap = new HashMap();
                for (int j = 0; j < 1; j++) {
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
                if (icMap.size() == 1) {
                    int keyCount = 0;
                    for (Object key : icMap.keySet()) {
                        if (Lang.isEmpty(icMap.get(key))) {
                            keyCount++;
                        }
                    }
                    if (keyCount < 1) {
                        icMapList.add(icMap);
                    }
                }
            }
            if (icMapList.size() > 0) {
                //?????????????????????
                int importNum = icMapList.size();
                List<FreeFreightGoodsBatchImportDto> importDtos = new ArrayList<>();
                for (int i = 0; i < importNum; i++) {
                    FreeFreightGoodsBatchImportDto importDto = new FreeFreightGoodsBatchImportDto();
                    Map mapitem = icMapList.get(i);
                    importDto.setSku(String.valueOf(mapitem.get(0)).trim());
                    importDto.setStoreId(storeId);
                    importDtos.add(importDto);
                }
                returnList = productService.batchImportExcel(importDtos, storeId);
                List<FreeFreightGoodsBatchImportDto> errorList = returnList.stream()
                        .filter(dto -> Lang.isEmpty(dto.getSuccess()) || !dto.getSuccess())
                        .collect(Collectors.toList());
                int errorSize = errorList.size();
                returnMap.put("errorSize", errorSize);
            }
        } catch (IOException e) {
            errorMsg = "??????????????????";
            log.info("??????????????????", e);
        }
        returnMap.put("returnList", returnList);
        returnMap.put("errorMsg", errorMsg);
        return returnMap;
    }


}
