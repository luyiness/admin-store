package store.admin.service.localstore;

import com.alibaba.fastjson.JSON;
import com.google.common.collect.Lists;
import com.google.common.util.concurrent.RateLimiter;

import goods.api.category.CategoryApi;
import goods.api.category.CategoryRestApi;
import goods.api.category.dto.request.query.CategoryQuery;
import goods.api.category.dto.request.query.CategoryQueryVo;
import goods.api.category.dto.response.CategoryDetailDTO;
import goods.api.category.dto.response.ProductCategoryStandardDTO;
import goods.api.category.dto.response.ProductCategoryStandardValueDTO;
import lombok.extern.slf4j.Slf4j;
import member.api.vo.JsonModel;
import org.apache.commons.lang3.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.streaming.SXSSFCell;
import org.apache.poi.xssf.streaming.SXSSFRow;
import org.apache.poi.xssf.streaming.SXSSFSheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFRichTextString;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.redis.core.BoundValueOperations;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;
import pool.api.ProviderGoodsApi;
//import pool.api.ProviderProductBrandApi;
import pool.api.ProviderGoodsRestApi;
import pool.api.ProviderProductModelApi;
import pool.api.ProviderProductModelRestApi;
import pool.api.goodsmanage.GMProviderProductApi;
import pool.api.goodsmanage.GMProviderProductFashionApi;
import pool.api.goodsmanage.GMProviderProductFashionRestApi;
import pool.api.goodsmanage.GMProviderProductRestApi;
import pool.commonUtil.MessageDictionary;
import pool.dto.*;
import pool.dto.brand.ProviderBrandGroupDto;
import pool.dto.goodsmng.GMProviderGoodsSpecificationDTO;
import pool.dto.goodsmng.GMProviderProFashionPictureDTO;
import pool.dto.goodsmng.GMProviderProductDTO;
import pool.dto.goodsmng.GMProviderProductFashionDTO;
import pool.enums.NumberCommonUtils;
import pool.vo.GMProviderProductFashionVo;
import pool.vo.ProviderGoodsFreeFreightsVo;
import pool.vo.ProviderGoodsVo;
import pool.vo.UpdateProviderGoodsVo;
import sinomall.config.page.PageResponse;
import sinomall.global.common.response.BaseResponse;
import store.admin.dto.FreeFreightGoodsBatchImportDto;
import store.admin.utils.ExcelUtils;
import store.admin.utils.StoreInfoUtil;
import store.admin.vo.AddProductVo;
import store.admin.vo.JqueryDataTablesVo;
import store.admin.vo.query.ProductQueryVo;
import store.api.StoreExtApi;
import store.api.StoreExtRestApi;
import store.api.dto.modeldto.core.StoreExtDto;
import utils.Lang;
import utils.collection.CollectionUtil;
import utils.data.CopyUtil;
import utils.excel.ExcelUtil;
import utils.sequence.SequenceUtil;
import utils.sql.PageVo;
import utils.web.ResponseMapUtils;

import javax.servlet.ServletOutputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.*;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

/**
 * @author: taofeng
 * @create: 2019-11-06
 **/
@Slf4j
@Component
public class ProductService {

    @Autowired
    CategoryRestApi productCategoryApi;
    @Autowired
    ProviderProductModelRestApi providerProductModelApi;
    @Autowired
    ProviderGoodsRestApi providerGoodsApi;
    @Autowired
    GMProviderProductRestApi ProviderProductApi;
    @Autowired
    GMProviderProductFashionRestApi providerProductFashionApi;
//    @Autowired
//    ProviderProductBrandApi providerBrandApi;
    @Autowired
    StoreExtRestApi storeExtApi;

    @Autowired
    SequenceUtil sequenceUtil;
    @Autowired
    RedisTemplate redisTemplate;
    @Autowired
    JdbcTemplate jdbcTemplate;

    public List<ProductCategoryStandardDTO> getCategoryStandard(String productCategoryId) {
        return productCategoryApi.getCategoryStandard(productCategoryId);
    }


    public Map addProduct(ProductModelDto productModel, List<ProviderGoodsDto> providerGoodses) {
        try {
            //保存新的分类规格
            CompletableFuture.runAsync(() -> saveCategoryStandard(productModel, providerGoodses));
            UpdateProviderGoodsVo updateProviderGoodsVo = new UpdateProviderGoodsVo();
            updateProviderGoodsVo.setProductModel(productModel);
            updateProviderGoodsVo.setUpdate(providerGoodses);
            BaseResponse saveResponse = providerGoodsApi.saveProviderProduct(updateProviderGoodsVo);
            if (saveResponse.isSuccess() && MessageDictionary.RETURN_SUCCESS_CODE.equals(saveResponse.getResultCode())) {
                return ResponseMapUtils.success(null, "保存成功");
            }
            return ResponseMapUtils.error(null, "保存失败：" + saveResponse.getResultMessage());
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseMapUtils.error("保存失败,系统异常");
        }
    }

    /**
     * @author taofeng
     * @date 2019/11/21
     * <p>
     * 保存新的分类规格
     */
    private void saveCategoryStandard(ProductModelDto productModelDto, List<ProviderGoodsDto> providerGoodsDtos) {
        String productCategoryId = productModelDto.getCategoryId();
        List<ProviderGoodsSpecificationDto> providerGoodsSpecificationDtoList = Collections.synchronizedList(new ArrayList<>());
        providerGoodsDtos.parallelStream()
                .filter(goods -> CollectionUtil.isNoneEmpty(goods.getProviderGoodsSpecifications()))
                .forEach(providerGoodsDto -> {
                    List<ProviderGoodsSpecificationDto> providerGoodsSpecifications = providerGoodsDto.getProviderGoodsSpecifications();
                    providerGoodsSpecificationDtoList.addAll(providerGoodsSpecifications);
                });
        Map<String, List<ProviderGoodsSpecificationDto>> keyMap = providerGoodsSpecificationDtoList.stream()
                .collect(Collectors.groupingBy(dto -> dto.getStandardCode()));
        Set<String> categoryStandardKeys = keyMap.keySet();
        List<ProductCategoryStandardDTO> categoryStandardDTOS = Collections.synchronizedList(new ArrayList<>());
        categoryStandardKeys.parallelStream().forEach(key -> {
            ProductCategoryStandardDTO categoryStandardDTO = new ProductCategoryStandardDTO();
            categoryStandardDTO.setName(key);
            categoryStandardDTO.setProductCategoryId(productCategoryId);
            Map<String, List<ProviderGoodsSpecificationDto>> valueMap = keyMap.get(key).stream()
                    .collect(Collectors.groupingBy(dto -> dto.getValue()));
            Set<String> values = valueMap.keySet();
            List<ProductCategoryStandardValueDTO> categoryStandardValueDTOS = Collections.synchronizedList(new ArrayList<>());
            values.parallelStream().forEach(value -> {
                ProductCategoryStandardValueDTO categoryStandardValueDTO = new ProductCategoryStandardValueDTO();
                categoryStandardValueDTO.setValue(value);
                categoryStandardValueDTOS.add(categoryStandardValueDTO);
            });
            categoryStandardDTO.setCategoryStandardValues(categoryStandardValueDTOS);
            categoryStandardDTOS.add(categoryStandardDTO);
        });
        productCategoryApi.saveCategoryStandard(categoryStandardDTOS);
    }

    public Map updateProduct(AddProductVo addProductVo) {
        try {
            UpdateProviderGoodsVo updateProviderGoodsVo = new UpdateProviderGoodsVo();
            updateProviderGoodsVo.setProductModel(addProductVo.getProductModel());
            updateProviderGoodsVo.setDel(addProductVo.getDelGoodses());
            updateProviderGoodsVo.setUpdate(addProductVo.getProviderGoodses());
            updateProviderGoodsVo.setStoreId(addProductVo.getProductModel().getStoreId());
            BaseResponse<List<ProviderGoodsDto>> goodsResponse = providerGoodsApi.updateProviderProduct(updateProviderGoodsVo);
            log.info("updateProduct.goodsResponse: {}", JSON.toJSONString(goodsResponse));
            if (goodsResponse.isSuccess() && MessageDictionary.RETURN_SUCCESS_CODE.equals(goodsResponse.getResultCode())) {
                return ResponseMapUtils.success(null, "保存成功");
            }
            return ResponseMapUtils.error("保存失败：" + goodsResponse.getResultMessage());
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseMapUtils.error("系统异常，保存失败");
        }

    }

    public Map findProduct(String storeId, String goodsSku) {
        Map result = new HashMap();
        ProviderGoodsDto providerGoodsDto = providerGoodsApi.queryProviderGoodsDto(goodsSku, storeId);
        if (!Lang.isEmpty(providerGoodsDto)) {
            result.put("providerGoods", providerGoodsDto);
            ProductModelDto modelDto = providerProductModelApi.findByModelSkuAndStoreId(providerGoodsDto.getModelSku(), storeId);
            List<ProviderGoodsDto> providerGoodsDtoList = Arrays.asList(providerGoodsDto);

            Map<String, List<String>> standardMap = new LinkedHashMap();
            providerGoodsDtoList.forEach(providerGoodsDtoTemp -> {
                providerGoodsDtoTemp.getProviderGoodsSpecifications().forEach(providerGoodsSpecificationDto -> {
                    List<String> specificationDtos = standardMap.get(providerGoodsSpecificationDto.getStandardCode());
                    if (Lang.isEmpty(specificationDtos)) {
                        specificationDtos = new ArrayList<>();
                    }
                    if (!specificationDtos.contains(providerGoodsSpecificationDto.getValue())) {
                        specificationDtos.add(providerGoodsSpecificationDto.getValue());
                    }
                    standardMap.put(providerGoodsSpecificationDto.getStandardCode(), specificationDtos);
                });
            });

            List<ProductCategoryStandardDTO> productCategoryStandardDTOS = new ArrayList<>();
            standardMap.forEach((standardCode, standardValues) -> {
                ProductCategoryStandardDTO productCategoryStandardDTO = new ProductCategoryStandardDTO();
                List<ProductCategoryStandardValueDTO> productCategoryStandardValueDTOS = new ArrayList<>();
                productCategoryStandardDTO.setName(standardCode);
                standardValues.forEach(standardValue -> {
                    ProductCategoryStandardValueDTO productCategoryMallStandardDto = new ProductCategoryStandardValueDTO();
                    productCategoryMallStandardDto.setValue(standardValue);
                    productCategoryStandardValueDTOS.add(productCategoryMallStandardDto);
                });
                productCategoryStandardDTO.setCategoryStandardValues(productCategoryStandardValueDTOS);
                productCategoryStandardDTOS.add(productCategoryStandardDTO);
            });

            result.put("providerGoodsList", providerGoodsDtoList);
            result.put("productCategoryStandardDTOS", productCategoryStandardDTOS);
            result.put("productModel", modelDto);
            return result;
        }
        return null;
    }

    /**
     * @author taofeng
     * @date 2019/4/3
     * <p>
     * 分类树
     */
    public List<JsonModel> findCategoryTree(String categoryId) {

        CategoryQueryVo  categoryQuery = new CategoryQueryVo();
        if (StringUtils.isEmpty(categoryId)) {
            categoryQuery.setLevel(CategoryDetailDTO.LEVEL_ONE);
        } else {
            categoryQuery.setParentId(categoryId);
        }
        PageResponse<CategoryDetailDTO> response = productCategoryApi.queryCategory(categoryQuery);
        return convertCategoryTree(response.getContent(), StringUtils.isEmpty(categoryId) ? "#" : categoryId);
    }

    private List<JsonModel> convertCategoryTree(List<CategoryDetailDTO> productCategories, String parentId) {
        List<JsonModel> treeDtos = new Vector<>();
        productCategories.stream().forEach(category -> {
            JsonModel treeDto = new JsonModel();
            treeDto.setId(category.getId());
            treeDto.setType1("category");
            treeDto.setText(category.getName());
            treeDto.setParent(parentId);
            treeDto.setIcon("false");
            treeDtos.add(treeDto);
        });
        return treeDtos;
    }

    /**
     * @author taofeng
     * @date 2019/4/3
     * <p>
     * 获取指定三级分类的所有层级分类名称
     */
    public List<String> findAllNameById(String productCategoryId) {
        List<String> allName = new ArrayList<>();
        List<CategoryDetailDTO> allParent = productCategoryApi.getAllParent(productCategoryId);
        allParent.forEach(categoryDetailDTO -> {
            allName.add(categoryDetailDTO.getName());
        });
        return allName;
    }

    public BaseResponse queryGoodsList(JqueryDataTablesVo jqueryDataTablesVo, ProductQueryVo productQueryVo) {
        Sort.Order order = new Sort.Order(Sort.Direction.ASC, "date_created");
        List<Sort.Order> sortList = new ArrayList<>();
        sortList.add(order);
        Sort sort = new Sort(sortList);
        int pageindex = jqueryDataTablesVo.getiDisplayStart() / jqueryDataTablesVo.getiDisplayLength();
        Pageable pageable = new PageRequest(pageindex, jqueryDataTablesVo.getiDisplayLength(), sort);

        ProductQueryDto productQueryDto = new ProductQueryDto();
        productQueryDto.setPageNo(pageable.getPageNumber());
        productQueryDto.setPageSize(pageable.getPageSize());
        productQueryDto.setProductName(productQueryVo.getProductName());
        productQueryDto.setCategoryId(productQueryVo.getCategoryId());
        //productQueryDto.setProductBrand(productQueryVo.getProductBrand());
        //实际是供应商品牌
        productQueryDto.setProviderBrandName(productQueryVo.getProductBrand());
        productQueryDto.setProductSku(productQueryVo.getProductSku());
        productQueryDto.setIsFreeFreight(productQueryVo.getIsFreeFreight());
        if (!Lang.isEmpty(StoreInfoUtil.getStoreId())) {
            productQueryDto.setStoreId(StoreInfoUtil.getStoreId());
        }
        productQueryDto.setProviderSaleStatus(productQueryVo.getProviderSaleStatus());
        return providerGoodsApi.queryProviderGoodsPage(productQueryDto);
    }

    public BaseResponse deleteProviderGoodsBatch(List<String> skus, String storeId) {
        return providerGoodsApi.deleteProviderGoodsBatch(skus, storeId);
    }

    public List<ProviderBrandGroupDto> findBrand(String storeId, String brandNameOrFirstLetter) {
        if (StringUtils.isEmpty(storeId)) {
            return null;
        }
        StringBuffer sql = new StringBuffer();
        List<Object> params = new ArrayList<>();
        sql.append(" select p.id, p.name, upper(p.provider_brand_first_letter) as firstletter ");
        sql.append(" from mall_provider.provider_product_brand p ");
        sql.append(" where p.is_delete = 0 ");
        sql.append("   and p.store_id = ? ");
        params.add(storeId);
        if (StringUtils.isNoneEmpty(brandNameOrFirstLetter)) {
            sql.append("  and (p.name like ? or p.provider_brand_first_letter like ?) ");
            params.add(StringUtils.upperCase("%" + brandNameOrFirstLetter.trim() + "%"));
            params.add(StringUtils.upperCase("%" + brandNameOrFirstLetter.trim() + "%"));
        }
        sql.append("   order by upper(p.provider_brand_first_letter),p.name asc ");
        List<ProviderProductBrandDto> brandDtos = jdbcTemplate.query(sql.toString(), new BeanPropertyRowMapper<>(ProviderProductBrandDto.class), params.toArray());
        List<ProviderBrandGroupDto> brandGroupDtos = Collections.synchronizedList(new ArrayList<>());
        brandDtos.forEach(brandDto -> {
            try {
                if (CollectionUtil.isNoneEmpty(brandGroupDtos)) {
                    Boolean flag = false;
                    for (ProviderBrandGroupDto productBrandGroupDto : brandGroupDtos) {
                        if (StringUtils.isEmpty(brandDto.getFirstLetter())) {
                            brandDto.setFirstLetter("#");
                        }
                        if (StringUtils.isEmpty(productBrandGroupDto.getCharacter())) {
                            productBrandGroupDto.setCharacter("");
                        }
                        if (brandDto.getFirstLetter().equals(productBrandGroupDto.getCharacter())) {
                            flag = true;
                            List<ProviderProductBrandDto> productBrandDtos = productBrandGroupDto.getProviderBrandDtos();
                            productBrandDtos.add(brandDto);
                            break;
                        }
                    }
                    if (!flag) {
                        ProviderBrandGroupDto productBrandGroupDto = new ProviderBrandGroupDto();
                        productBrandGroupDto.setCharacter(brandDto.getFirstLetter());
                        List<ProviderProductBrandDto> productBrandDtosList = new ArrayList<>();
                        productBrandDtosList.add(brandDto);
                        productBrandGroupDto.setProviderBrandDtos(productBrandDtosList);
                        brandGroupDtos.add(productBrandGroupDto);
                    }
                } else {
                    ProviderBrandGroupDto productBrandGroupDto = new ProviderBrandGroupDto();
                    productBrandGroupDto.setCharacter(StringUtils.EMPTY);
                    productBrandGroupDto.setProviderBrandDtos(Lists.<ProviderProductBrandDto>newArrayList());
                    productBrandGroupDto.setCharacter(Lang.isEmpty(brandDto.getFirstLetter()) ? "#" : brandDto.getFirstLetter());
                    List<ProviderProductBrandDto> productBrandDtosList = new ArrayList<>();
                    productBrandDtosList.add(brandDto);
                    productBrandGroupDto.setProviderBrandDtos(productBrandDtosList);
                    brandGroupDtos.add(productBrandGroupDto);
                }
            } catch (Exception e) {
                log.info(e.toString());
            }
        });
        return brandGroupDtos;
    }

    /*-----------------------------新接口-----------------------------*/

    public BaseResponse<List<String>> saveProduct(ProductModelDto productModelDto, List<ProviderGoodsDto> providerGoodsDtos) {

        //保存新的分类规格
        CompletableFuture.runAsync(() -> saveCategoryStandard(productModelDto, providerGoodsDtos));

        //创建商品模型
        String modelSku = productModelDto.getModelSku();
        if (StringUtils.isEmpty(modelSku)) {
            try {
                modelSku = sequenceUtil.getOrderNo("sku");
                productModelDto.setModelSku(modelSku);
            } catch (InterruptedException e) {
                log.info("生成商品modelSku失败", e);
                return new BaseResponse(false, "生成商品modelSku失败");
            }
        }
        GMProviderProductDTO providerProductDTO = copyProviderProduct(Arrays.asList(productModelDto)).get(NumberCommonUtils.ZERO.getValue());
        GMProviderProductDTO gmProviderProductDTO = ProviderProductApi.save(providerProductDTO);
        if (Lang.isEmpty(gmProviderProductDTO)) {
            return new BaseResponse(false, "商品模型创建失败");
        }
        //创建商品
        StoreExtDto storeExtDto = storeExtApi.findByStoreId(productModelDto.getStoreId());
        providerGoodsDtos.forEach(providerGoodsDto -> {
            providerGoodsDto.setModelSku(gmProviderProductDTO.getModelSku());
            providerGoodsDto.setStoreId(storeExtDto.getStore().getId());
            providerGoodsDto.setProvideName(storeExtDto.getStoreName());
            providerGoodsDto.setStatus(NumberCommonUtils.ZERO.getCode());
            String sku = providerGoodsDto.getSku();
            if (StringUtils.isEmpty(sku)) {
                try {
                    sku = sequenceUtil.getOrderNo("sku");
                    providerGoodsDto.setSku(sku);
                } catch (InterruptedException e) {
                    log.info("生成商品sku失败", e);
                    return;
                }
            }
        });
        List<GMProviderProductFashionDTO> providerProductFashionDTOS = copyProviderGoods(providerGoodsDtos);
        GMProviderProductFashionVo gmProviderProductFashionVo = new GMProviderProductFashionVo();
        gmProviderProductFashionVo.setProviderProductFashionDTOS(providerProductFashionDTOS);
        gmProviderProductFashionVo.setStoreId(productModelDto.getStoreId());
        Map<String, String> responseMap = providerProductFashionApi.save(gmProviderProductFashionVo);
        //组装返回值
        List<String> errorGoodsNames = Collections.synchronizedList(new ArrayList<>());
        if (!Lang.isEmpty(responseMap)) {
            Map<String, List<GMProviderProductFashionDTO>> skuMap = providerProductFashionDTOS.stream()
                    .collect(Collectors.groupingBy(dto -> dto.getSku()));
            responseMap.keySet().parallelStream().forEach(sku -> {
                List<GMProviderProductFashionDTO> fashionDTOS = skuMap.get(sku);
                if (CollectionUtil.isNoneEmpty(fashionDTOS)) {
                    GMProviderProductFashionDTO fashionDTO = fashionDTOS.get(NumberCommonUtils.ZERO.getValue());
                    errorGoodsNames.add(fashionDTO.getName());
                }
            });
        }
        if (CollectionUtil.isNoneEmpty(errorGoodsNames)) {
            return new BaseResponse(false, String.join(",", errorGoodsNames) + "提交失败");
        }
        return new BaseResponse(true, "操作完成");
    }

    public List<GMProviderProductDTO> copyProviderProduct(List<ProductModelDto> productModelDtos) {
        List<GMProviderProductDTO> providerProductDTOS = CopyUtil.parallelMapList(productModelDtos, GMProviderProductDTO.class);
        Map<String, List<ProductModelDto>> pmMap = productModelDtos.stream()
                .filter(dto -> StringUtils.isNoneEmpty(dto.getModelSku()))
                .collect(Collectors.groupingBy(dto -> dto.getModelSku()));
        Map<String, List<GMProviderProductDTO>> ppMap = providerProductDTOS.stream()
                .filter(dto -> StringUtils.isNoneEmpty(dto.getModelSku()))
                .collect(Collectors.groupingBy(dto -> dto.getModelSku()));
        Set<String> modelSkus = ppMap.keySet();
        List<GMProviderProductDTO> gmProviderProductDTOS = Collections.synchronizedList(new ArrayList<>());
        modelSkus.parallelStream().forEach(modelSku -> {
            ProductModelDto productModelDto = pmMap.get(modelSku).get(NumberCommonUtils.ZERO.getValue());
            GMProviderProductDTO providerProductDTO = ppMap.get(modelSku).get(NumberCommonUtils.ZERO.getValue());
            providerProductDTO.setId(productModelDto.getModelId());
            providerProductDTO.setModelName(productModelDto.getName());
            providerProductDTO.setStoreId(productModelDto.getStoreId());
            providerProductDTO.setProductCategoryId(productModelDto.getCategoryId());
            providerProductDTO.setProviderProductBrandId(productModelDto.getBrandId());
            providerProductDTO.setProductBrandId(productModelDto.getProductBrandId());
            providerProductDTO.setProviderProductCategoryId(productModelDto.getProviderProductCategoryId());
            gmProviderProductDTOS.add(providerProductDTO);
        });
        return gmProviderProductDTOS;
    }

    /**
     * @author taofeng
     * @date 2019/11/20
     * <p>
     * 需保证 providerProductId 有值
     * 或 providerGoodsDtos 中的 providerProductId 有值
     * 此方法暂不做校验
     */
    public List<GMProviderProductFashionDTO> copyProviderGoods(List<ProviderGoodsDto> providerGoodsDtos) {

        List<GMProviderProductFashionDTO> providerProductFashionDTOS = CopyUtil.parallelMapList(providerGoodsDtos, GMProviderProductFashionDTO.class);

        Map<String, List<ProviderGoodsDto>> pgMap = providerGoodsDtos.stream()
                .filter(dto -> StringUtils.isNoneEmpty(dto.getSku()))
                .collect(Collectors.groupingBy(dto -> dto.getSku()));

        Map<String, List<GMProviderProductFashionDTO>> ppfMap = providerProductFashionDTOS.stream()
                .filter(dto -> StringUtils.isNoneEmpty(dto.getSku()))
                .collect(Collectors.groupingBy(dto -> dto.getSku()));

        Set<String> skus = ppfMap.keySet();

        List<GMProviderProductFashionDTO> gmProviderProductFashionDTOS = Collections.synchronizedList(new ArrayList<>());

        skus.parallelStream().forEach(sku -> {
            //ppf
            ProviderGoodsDto providerGoodsDto = pgMap.get(sku).get(NumberCommonUtils.ZERO.getValue());
            GMProviderProductFashionDTO providerProductFashionDTO = ppfMap.get(sku).get(NumberCommonUtils.ZERO.getValue());
            if (StringUtils.isNoneEmpty(providerGoodsDto.getStatus())) {
                providerProductFashionDTO.setProviderSaleStatus(Integer.valueOf(providerGoodsDto.getStatus()));
            }
            //图片
            List<PicDto> picDtos = providerGoodsDto.getPics();
            if (CollectionUtil.isNoneEmpty(picDtos)) {
                List<GMProviderProFashionPictureDTO> pics = new ArrayList<>();
                for (int i = 0; i < picDtos.size(); i++) {
                    PicDto picDto = picDtos.get(i);
                    GMProviderProFashionPictureDTO pic = new GMProviderProFashionPictureDTO();
                    //入库的时候再关联商品
                    //pic.setProviderProductFashionId();
                    if (picDto.getIsPrimary() != null
                            && (picDto.getIsPrimary().equals(1)
                            || "1".equals(picDto.getIsPrimary())
                            || "true".equals(picDto.getIsPrimary()))) {
                        pic.setIsPrimary(true);
                        pic.setOrdersort(0);
                    } else {
                        pic.setIsPrimary(false);
                        pic.setOrdersort(Lang.isEmpty(picDto.getOrderSort()) ? (i + NumberCommonUtils.TEN.getValue()) : Integer.parseInt(picDto.getOrderSort()));
                    }
                    pic.setPath(providerGoodsDto.getPics().get(i).getPath());
                    pic.setCompressPath(providerGoodsDto.getPics().get(i).getCompressPath());
                    pic.setType(providerGoodsDto.getPics().get(i).getType());
                    pic.setFeatures(providerGoodsDto.getPics().get(i).getFeatures());
                    pic.setPosition(providerGoodsDto.getPics().get(i).getPosition());
                    pics.add(pic);
                }
                providerProductFashionDTO.setProviderProFashionPictureDTOS(pics);
            }
            //规格
            List<ProviderGoodsSpecificationDto> providerGoodsSpecifications = providerGoodsDto.getProviderGoodsSpecifications();
            List<GMProviderGoodsSpecificationDTO> providerGoodsSpecificationDTOS = CopyUtil.parallelMapList(providerGoodsSpecifications, GMProviderGoodsSpecificationDTO.class);
            providerProductFashionDTO.setProviderGoodsSpecificationDTOS(providerGoodsSpecificationDTOS);
            //保存
            gmProviderProductFashionDTOS.add(providerProductFashionDTO);
        });

        return gmProviderProductFashionDTOS;
    }

    RateLimiter rateLimiter = RateLimiter.create(NumberCommonUtils.ONE.getValue());

    public void categoryStandardSave(String standardName, String standardVal, String productCategoryId) {
        rateLimiter.acquire();
        BoundValueOperations ops = redisTemplate.boundValueOps(standardVal);
        String standardValKeyValue = (String) ops.get();
        if (StringUtils.isNoneEmpty(standardValKeyValue)) {
            return;
        } else {
            ops.set(standardVal, NumberCommonUtils.FIVE.getValue(), TimeUnit.SECONDS);
        }
        ProductCategoryStandardValueDTO categoryStandardValueDTO = new ProductCategoryStandardValueDTO();
        categoryStandardValueDTO.setValue(standardVal);

        ProductCategoryStandardDTO categoryStandardDTO = new ProductCategoryStandardDTO();
        categoryStandardDTO.setName(standardName);
        categoryStandardDTO.setProductCategoryId(productCategoryId);
        categoryStandardDTO.setCategoryStandardValues(Arrays.asList(categoryStandardValueDTO));
        productCategoryApi.saveCategoryStandard(Arrays.asList(categoryStandardDTO));
    }

    /*-----------------------------新接口-----------------------------*/

    /**
     * 导出
     * @param productQueryVo
     * @return
     */
    public byte[] goodsExportService(ProductQueryVo productQueryVo) {

        ProductQueryDto productQueryDto = CopyUtil.map(productQueryVo,ProductQueryDto.class);
        productQueryDto.setPageNo(0);
        productQueryDto.setPageSize(10000);
        BaseResponse<PageVo<ProviderGoodsVo>> response =  providerGoodsApi.queryProviderGoodsPage(productQueryDto);
        List<ProviderGoodsVo> lists = new ArrayList<>();
        if(!Lang.isEmpty(response) && response.isSuccess()){
            lists  = response.getResult().getResult();
        }

        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
        List<String> title = Arrays.asList(new String[]{"序号", "供应商", "供应商sku", "商品名称", "商品品牌", "市场价", "协议价", "库存", "状态","是否包邮"});
        Workbook workbook = null;
        try {
            workbook = new XSSFWorkbook();
            Sheet sheet = workbook.createSheet();
            ExcelUtil.createHeader(sheet, title);

            Integer gindexStartRow = null, gindexColumn = 0;
            Integer storeStartRow = null, storeColumn = 1;
            Integer skuStartRow = null, skuColumn = 2;
            Integer goodsNameStartRow = null, goodsNameColumn = 3;
            Integer brandStartRow = null, brandColumn = 4;
            Integer marketPriceStartRow = null, marketPriceColumn = 5;
            Integer costPriceStartRow = null, costPriceColumn = 6;
            Integer stockStartRow = null, stockColumn = 7;
            Integer statusStartRow = null, statusColumn = 8;
            Integer isFreeFreightStartRow = null, isFreeFreightColumn = 9;

            String gindexPrevious = null;
            String storePrevious = null;
            String skuPrevious = null;
            String goodsNamePrevious = null;
            String brandPrevious = null;
            String marketPricePrevious = null;
            String costPricePrevious = null;
            String stockPrevious = null;
            String statusPrevious = null;
            String isFreeFreightPrevious = null;

            CellStyle cellStyle = ExcelUtil.createValueCellStyle(workbook);
            for (int i = 0, rowIndex = 1; i < lists.size(); i++, rowIndex++) {
                Row row = sheet.createRow(rowIndex);
                row.setHeightInPoints(25);
                Map<String, Object> returnMap;
                ProviderGoodsVo p = lists.get(i);

                //序号
                returnMap = createOrMargedCell(sheet, row, cellStyle, rowIndex, rowIndex + "", gindexPrevious, gindexStartRow, gindexColumn, false);
                gindexPrevious = (String) returnMap.get("previousValue");
                gindexStartRow = (Integer) returnMap.get("startRow");

                //供应商
                String store = Lang.isEmpty(p.getProvideName())?"":p.getProvideName();
                returnMap = createOrMargedCell(sheet, row, cellStyle, rowIndex, store, storePrevious, storeStartRow, storeColumn, false);
                storePrevious = (String) returnMap.get("previousValue");
                storeStartRow = (Integer) returnMap.get("startRow");

                //商品编码
                String sku = Lang.isEmpty(p.getSku())?"":p.getSku();
                returnMap = createOrMargedCell(sheet, row, cellStyle, rowIndex, sku, skuPrevious, skuStartRow, skuColumn, false);
                skuPrevious = (String) returnMap.get("previousValue");
                skuStartRow = (Integer) returnMap.get("startRow");

                //商品名称
                String goodsname = Lang.isEmpty(p.getName())?"":p.getName();
                returnMap = createOrMargedCell(sheet, row, cellStyle, rowIndex, goodsname, goodsNamePrevious, goodsNameStartRow, goodsNameColumn, false);
                goodsNamePrevious = (String) returnMap.get("previousValue");
                goodsNameStartRow = (Integer) returnMap.get("startRow");

                //品牌
                String brand = Lang.isEmpty(p.getProviderBrandName())?"":p.getProviderBrandName();
                returnMap = createOrMargedCell(sheet, row, cellStyle, rowIndex, brand, brandPrevious, brandStartRow, brandColumn, false);
                brandPrevious = (String) returnMap.get("previousValue");
                brandStartRow = (Integer) returnMap.get("startRow");

                //商品市场价
                String marketPrice = Lang.isEmpty(p.getMarketPrice())?"":p.getMarketPrice().toString();
                returnMap = createOrMargedCell(sheet, row, cellStyle, rowIndex, marketPrice, marketPricePrevious, marketPriceStartRow, marketPriceColumn, false);
                marketPricePrevious = (String) returnMap.get("previousValue");
                marketPriceStartRow = (Integer) returnMap.get("startRow");

                //商品协议价
                String costPrice = Lang.isEmpty(p.getCostPrice())?"":p.getCostPrice().toString();
                returnMap = createOrMargedCell(sheet, row, cellStyle, rowIndex, costPrice, costPricePrevious, costPriceStartRow, costPriceColumn, false);
                costPricePrevious = (String) returnMap.get("previousValue");
                costPriceStartRow = (Integer) returnMap.get("startRow");


                //库存
                String stock = Lang.isEmpty(p.getStockCount())?"":p.getStockCount().toString();
                returnMap = createOrMargedCell(sheet, row, cellStyle, rowIndex, stock, stockPrevious, stockStartRow, stockColumn, false);
                stockPrevious = (String) returnMap.get("previousValue");
                stockStartRow = (Integer) returnMap.get("startRow");


                //状态
                String status = Lang.isEmpty(p.getStatus())?"":p.getStatus().toString();
                if (!Lang.isEmpty(status)) {
                    if ("1".equals(status)) {
                        status = "已上架";
                    } else if ("0".equals(status)) {
                        status = "未上架";
                    } else if ("-1".equals(status)) {
                        status = "已下架";
                    }
                }
                returnMap = createOrMargedCell(sheet, row, cellStyle, rowIndex, status, statusPrevious, statusStartRow, statusColumn, false);
                statusPrevious = (String) returnMap.get("previousValue");
                statusStartRow = (Integer) returnMap.get("startRow");
                //是否包邮
                String isFreeFreight = Lang.isEmpty(p.getIsFreeFreight())?"":p.getIsFreeFreight().toString();
                if (!Lang.isEmpty(isFreeFreight)) {
                    if ("1".equals(isFreeFreight)) {
                        isFreeFreight = "是";
                    } else {
                        isFreeFreight = "否";
                    }
                }else {
                    isFreeFreight = "否";
                }
                returnMap = createOrMargedCell(sheet, row, cellStyle, rowIndex, isFreeFreight, isFreeFreightPrevious, isFreeFreightStartRow, isFreeFreightColumn, false);
                isFreeFreightPrevious = (String) returnMap.get("previousValue");
                isFreeFreightStartRow = (Integer) returnMap.get("startRow");
            }
            for (int i = 0; i < title.size(); i++) {
                sheet.autoSizeColumn(i, true);
            }
            workbook.write(byteArrayOutputStream);
            byteArrayOutputStream.flush();
            byteArrayOutputStream.close();
        } catch (Exception e) {
            log.error("导出异常", e);
        } finally {
            try {
                if (Lang.isEmpty(workbook)) {
                    workbook.close();
                }
            } catch (Exception e) {
                log.error(String.valueOf(e));
            }
        }
        return byteArrayOutputStream.toByteArray();
    }


    private Map<String, Object> createOrMargedCell(Sheet sheet, Row row, CellStyle cellStyle, int currentRow, String currentValue, String previousValue, Integer startRow, int column, boolean merge) {
        Map<String, Object> map = new HashMap<>();
        if (currentRow > 0 && currentValue.equals(previousValue) && merge) {
            if (Lang.isEmpty(startRow)) {
                startRow = currentRow - 1;
            } else {
                List<CellRangeAddress> cellRangeAddresseList = sheet.getMergedRegions();
                for (int margedIndex = 0; margedIndex < cellRangeAddresseList.size(); margedIndex++) {
                    CellRangeAddress marged = cellRangeAddresseList.get(margedIndex);
                    if (marged.getFirstRow() == startRow && marged.getLastRow() == currentRow - 1 && marged.getFirstColumn() == column) {
                        sheet.removeMergedRegion(margedIndex);
                        break;
                    }
                }
            }
            sheet.addMergedRegion(new CellRangeAddress(startRow, currentRow, column, column));
        } else {
            Cell cell = row.createCell(column, Cell.CELL_TYPE_STRING);
            cell.setCellValue(currentValue);
            cell.setCellStyle(cellStyle);
            previousValue = currentValue;
            startRow = currentRow;
        }
        map.put("startRow", startRow);
        map.put("previousValue", previousValue);
        return map;
    }

    private SXSSFWorkbook hwbBatch;
    private static final String[] titlesBatch = {"供应商sku"};

    public void checkBatchExcelOut(ServletOutputStream out) {
        try {
            hwbBatch = new SXSSFWorkbook();
            hwbBatch = checkDownBatch();
            hwbBatch.write(out);
            out.flush();
            out.close();
            hwbBatch.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public SXSSFWorkbook checkDownBatch() {
        SXSSFWorkbook hwb = new SXSSFWorkbook();
        //sheet1
        SXSSFSheet sheet = hwb.createSheet("批量设置包邮商品模板");
        //创建第一行并设置行高
        SXSSFRow row = sheet.createRow(0);
        row.setHeight((short) 600);
        //设置字体
        Font font = hwb.createFont();
        font.setFontName("宋体");
        font.setFontHeightInPoints((short) 12);
        DataFormat format = hwb.createDataFormat();
        //设置单元格格式
        CellStyle style = hwb.createCellStyle();
        style.setFont(font);
        style.setDataFormat(format.getFormat("@"));  //设置输入格式为文本格式
        style.setAlignment(HorizontalAlignment.CENTER);
        style.setVerticalAlignment(VerticalAlignment.CENTER);
        style.setWrapText(true);
        //设置单元格内容
        int columnCount = titlesBatch.length;
        for (int i = 0; i < columnCount; i++) {
            SXSSFCell cell = row.createCell(i);
            cell.setCellStyle(style);
            cell.setCellValue(new XSSFRichTextString(titlesBatch[i]));
            sheet.setColumnWidth(i, 8000);
            sheet.setDefaultColumnStyle(i, style);
        }
        return hwb;
    }

    public BaseResponse modifyGoodsFreeFreight(List<ProviderGoodsFreeFreightDto> list, String storeId) {
        ProviderGoodsFreeFreightsVo providerGoodsFreeFreights = new ProviderGoodsFreeFreightsVo();
        providerGoodsFreeFreights.setProviderGoodsFreeFreightDtos(list);
        providerGoodsFreeFreights.setStoreId(storeId);
        return providerGoodsApi.modifyGoodsFreeFreight(providerGoodsFreeFreights);
    }

    public BaseResponse modifyGoodsStatus(List<ProviderGoodsStatus> providerGoodsStatusList, String storeId) {
        ProviderGoodsFreeFreightsVo providerGoodsFreeFreights = new ProviderGoodsFreeFreightsVo();
        providerGoodsFreeFreights.setProviderGoodsStatusList(providerGoodsStatusList);
        providerGoodsFreeFreights.setStoreId(storeId);
        return providerGoodsApi.modifyGoodsStatus(providerGoodsFreeFreights);
    }

    public BaseResponse<ProviderGoodsVo> queryProviderGoods(String sku, String storeId) {
        return providerGoodsApi.queryProviderGoods(sku, storeId);
    }

    public BaseResponse modifyGoodsStock(List<ProviderGoodsStock> providerGoodsStockList, String storeId) {
        ProviderGoodsFreeFreightsVo providerGoodsFreeFreights = new ProviderGoodsFreeFreightsVo();
        providerGoodsFreeFreights.setProviderGoodsStockList(providerGoodsStockList);
        providerGoodsFreeFreights.setStoreId(storeId);
        return providerGoodsApi.modifyGoodsStock(providerGoodsFreeFreights);
    }


    /**
     * 包邮商品导入
     * @param importDtos
     * @param storeId
     * @return
     */
    public List<FreeFreightGoodsBatchImportDto> batchImportExcel(List<FreeFreightGoodsBatchImportDto> importDtos, String storeId) {
        if (CollectionUtil.isEmpty(importDtos)) {
            return null;
        }
        List<String> skuList = importDtos.stream().map(FreeFreightGoodsBatchImportDto::getSku).collect(Collectors.toList());
        List<String> skuParams = Collections.synchronizedList(new ArrayList<>());
        skuList.parallelStream().forEach(o -> {
            StringBuffer sb = new StringBuffer();
            sb.append("'").append(o).append("'");
            skuParams.add(sb.toString());
        });
        //校验商品是否存在
        StringBuffer successSql = new StringBuffer();
        successSql.append(" select distinct ppf.sku ");
        successSql.append(" from mall_provider.provider_product_fashion ppf ");
        successSql.append(" where ppf.is_delete=0 and ppf.store_id ='"+storeId+"'");
        successSql.append(" and ppf.sku in (" + String.join(",", skuParams) + ") ");
        List<String> successSku = jdbcTemplate.queryForList(successSql.toString(), String.class);
        List<String> errorSku = new ArrayList<String>();
        HashSet hs1 = new HashSet(skuList);
        HashSet hs2 = new HashSet(successSku);
        hs1.removeAll(hs2);
        errorSku.addAll(hs1);

        List<FreeFreightGoodsBatchImportDto> successList = new ArrayList<>();
        List<FreeFreightGoodsBatchImportDto> errorList = new ArrayList<>();

        List<ProviderGoodsFreeFreightDto> list = new ArrayList<>();
        if (successSku != null && successSku.size() > 0) {
            for (String sku : successSku) {
                ProviderGoodsFreeFreightDto providerGoodsFreeFreightDto = new ProviderGoodsFreeFreightDto();
                providerGoodsFreeFreightDto.setSku(sku);
                providerGoodsFreeFreightDto.setIsFreeFreight("1");
                providerGoodsFreeFreightDto.setStoreId(storeId);
                list.add(providerGoodsFreeFreightDto);
                FreeFreightGoodsBatchImportDto f = new FreeFreightGoodsBatchImportDto();
                f.setSku(sku);
                f.setStoreId(storeId);
                f.setSuccess(true);
                f.setMsg("导入成功");
                successList.add(f);
            }
            ProviderGoodsFreeFreightsVo providerGoodsFreeFreights = new ProviderGoodsFreeFreightsVo();
            providerGoodsFreeFreights.setProviderGoodsFreeFreightDtos(list);
            providerGoodsFreeFreights.setStoreId(storeId);
            providerGoodsApi.modifyGoodsFreeFreight(providerGoodsFreeFreights);
        }
        if(!Lang.isEmpty(errorSku)) {
            for (String sku : errorSku) {
                FreeFreightGoodsBatchImportDto f = new FreeFreightGoodsBatchImportDto();
                f.setSku(sku);
                f.setStoreId(storeId);
                f.setSuccess(false);
                f.setMsg("商品不存在");
                errorList.add(f);
            }
        }
        List<FreeFreightGoodsBatchImportDto> returnList = new ArrayList<>();
        returnList.addAll(successList);
        returnList.addAll(errorList);
        return returnList;
    }

    @Autowired
    ExcelUtils excelUtils;

    public ResponseEntity<byte[]> downloadReturnList(List<FreeFreightGoodsBatchImportDto> freeFreightGoodsBatchImportDtos) {
        ResponseEntity<byte[]> responseEntity = null;
        try {
            List<List<Object>> rows = getRows(freeFreightGoodsBatchImportDtos);
            String fileName = "store_admin_addFreeFreightGoods.xlsx";
            ByteArrayOutputStream byteArrayOutputStream = excelUtils.excelForSXSSFWorkbook(fileName, rows);
            String downFileName = java.net.URLEncoder.encode("批量设置包邮商品导入结果.xlsx", "UTF-8");
            //设置响应头让浏览器正确显示下载
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
            headers.setContentDispositionFormData("attachment", downFileName);
            responseEntity = new ResponseEntity<>(byteArrayOutputStream.toByteArray(), headers, HttpStatus.OK);
        } catch (UnsupportedEncodingException e) {
            log.info("OrderService.downloadReturnList", e);
        }
        return responseEntity;
    }
    private List<List<Object>> getRows(List<FreeFreightGoodsBatchImportDto> freeFreightGoodsBatchImportDtos) {
        //EXCEL列
        List<List<Object>> rows = new ArrayList<>();
        //从给定数据获取指定列作为EXCEL列数据
        for (FreeFreightGoodsBatchImportDto f : freeFreightGoodsBatchImportDtos) {
            List<Object> row = new ArrayList<>();
            //商品编码
            row.add(f.getSku());
            //导入结果
            row.add(f.getMsg());
            rows.add(row);
        }
        return rows;
    }
}
