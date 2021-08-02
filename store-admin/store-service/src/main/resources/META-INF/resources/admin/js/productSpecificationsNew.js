
var p_static = $("#p_static").val();

var productSpecificationsVo = null;

// 初始化点击 当前选中属性点击事件不触发样式变更
var initClick = false;

// 当前页面商品ID
//var currentGoodsId = goodsId;

//當前商品的產品Id
var currentProductId=productId;

// 产品规格数量
var specificationCount = null;

$(function() {

    //加载产品规格相关数据
    loadPproductSpecifications();

    //绑定规格点击事件
    $(document).on("click", "#productSpecifications .item", selectSpecifications);

});

//加载产品规格相关数据
function loadPproductSpecifications() {
    var loadData = {};
    $.ajax({
        type: "post",
        url: p_static +"/goodsdetails/loadProductSpecifications",
        dataType: "json",
        data: {
            productId: productId,
        },
        beforesend: function () {

        },
        success: function (data) {
            var data = JSON.parse(data);
            productSpecificationsVo = data.productSpecificationsVo;
            if(data.status != "success") {
                console.error(data.error + " | " + data.message);
            } else {
                loadData = data;
                var html = template("loadProductSpecifications", loadData);
                $("#productSpecifications").append(html);

                specificationCount = $(".chooseVersion").length;

                // 遍历当前规格选中属性 并触发初始化点击
                $(".chooseVersion").find(".active").each(function (index, a) {
                    initClick = true;
                    $(a).click();
                });
                initClick = false;
            }
        },
        error: function () {
            console.error("获取规格失败");
        },
        complete: function (XHR, TS) {
            if(TS == "error") {
                console.error("获取规格失败");
            }
        }
    });
}

//规格点击事件
function selectSpecifications() {
    var self = $(this);
    // 非初始化点击则样式改变
    if(!initClick) {
        // 改变当前规格属性成选中或非选中样式
        if(self.find("a").hasClass('active')) {
            // 只有一个规格不可取消已选择的规格属性
            if(specificationCount > 1) {
                self.find("a").removeClass('active');
            }
        } else {
            //当前属性所属规格全部设为非选中
            self.parents('.chooseType').find('.item').find('a').removeClass('active');
            //当卡属性设置为选中
            self.find("a").addClass('active');
        }
    }
    // 属性改变
    specificationsChange(self);
}

// 属性改变
function specificationsChange(self) {
    // 选中的规格属性数组
    var specificationSelectedArray = new Array();
    $(".chooseType .active").each(function (index, element) {
        var specificationSelected = {};
        var code = $(element).parents(".chooseVersion").find("input[type='hidden']").val();
        var value = $(element).attr("data");
        specificationSelected.code = code;
        specificationSelected.value = value;
        specificationSelectedArray.push(specificationSelected);
    });

    // 当选中的规格属性数量与产品所有的规格数量相等 则表明找到唯一的商品需要跳转
    if(specificationCount == specificationSelectedArray.length) {

        var matchdGoodsId = null;

        // 遍历当前商品所属产品下所有 PRODUCT_FASHION VO
        $.each(productSpecificationsVo.fashionSpecificationsVos, function (productFashionVoIndex, productFashionVo) {

            // 规格匹配数量
            var matchs = 0;

            // 遍历当前 PRODUCT_FASHION VO 下 PRODUCT_FASHION_SPECIFICATIONS VO
            $.each(productFashionVo.productFashionSpecificationsVos, function (productFashionSpecificationsVoIndex, productFashionSpecificationsVo) {

                // 遍历选中的规格属性 与 PRODUCT_FASHION_SPECIFICATIONS VO 所拥有的规格属性比较
                $.each(specificationSelectedArray, function (specificationSelectedArrayIndex, specificationSelected) {

                    // 匹配
                    if(productFashionSpecificationsVo.standardCode == specificationSelected.code && productFashionSpecificationsVo.value == specificationSelected.value) {
                        matchs ++;
                        // 匹配成功进行下次遍历
                        return false;
                    }

                });

            });

            // 规格数量完成匹配并且找到的商品非当前页面商品则跳转指定的规格商品页面
            if(specificationCount == matchs && productFashionVo.goodsId != currentGoodsId) {
                // 记录跳转的商品ID
                matchdGoodsId = productFashionVo.goodsId;
                // 跳出循环
                return false;
            }
        });

        // 跳转
        if(matchdGoodsId != null) {
            console.log("可以跳转");
            //解绑绑规格点击事件
            $(document).off("click", "#productSpecifications .item", selectSpecifications);
             // 页面指针显示等待
            $("*").css("cursor", "wait");
            // 跳转
            window.location.href = p_static +"/goodsdetails?goodsId=" + matchdGoodsId;
            return true;

        }

    }

    /*******************************************规格可选判断*******************************************/

    // 当前事件规格属性
    var selftCode = self.parents(".chooseVersion").find("input[type='hidden']").val();
    var selftValue = self.find("a").attr("data");

    // 选中或取消选中任意一个规格属性将影响其他规格属性，

    // 遍历当前商品所属产品所有规格
    $(".chooseVersion").each(function (chooseVersionIndex, chooseVersion) {

        // 当前规格代码
        var specificationCode = $(chooseVersion).find("input[type='hidden']").val();

        // 跳过自身规格判定
        if(specificationCode != selftCode || $(".chooseVersion").length == 1) {

            // 遍历当前规格所有属性
            $(chooseVersion).find(".chooseType").find(".item, .itemDisabled").each(function (itemIndex, item) {

                // 当前规格代码
                var specificationCode = $(item).parents(".chooseVersion").find("input[type='hidden']").val();
                // 当前规格属性值
                var specificationValue = $(item).find("a").attr("data");

                // 过滤当前选中规格属性
                if(!$(item).find("a").hasClass('active')) {

                    // 校验规格参数组合数组
                    var checkSpecificationSelectedArray = new Array();
                    $.each(specificationSelectedArray, function (specificationSelectedArrayIndex, specificationSelected) {
                        if(specificationSelected.code != specificationCode) {
                            checkSpecificationSelectedArray.push(specificationSelected);
                        }
                    });
                    var specificationSelected = {};
                    specificationSelected.code = specificationCode;
                    specificationSelected.value = specificationValue;
                    checkSpecificationSelectedArray.push(specificationSelected);

                    // 校验规格属性是否可选
                    makeChange($(item), checkSpecificationSelectedArray);

                }

            });
        }


    });

}

/**
 *
 * @param item 当前需要判定的规格属性
 * @param checkSpecificationSelectedArray 需要满足校验规格参数组合数组
 */
function makeChange(item, checkSpecificationSelectedArray) {

    var match = false;

    // 遍历当前商品所属产品下所有 PRODUCT_FASHION VO
    $.each(productSpecificationsVo.fashionSpecificationsVos, function (productFashionVoIndex, productFashionVo) {

        // 规格匹配数量
        var matchs = 0;

        // 遍历当前 PRODUCT_FASHION VO 下 PRODUCT_FASHION_SPECIFICATIONS VO
        $.each(productFashionVo.productFashionSpecificationsVos, function (productFashionSpecificationsVoIndex, productFashionSpecificationsVo) {

            // 遍历选中的规格属性 与 PRODUCT_FASHION_SPECIFICATIONS VO 所拥有的规格属性比较
            $.each(checkSpecificationSelectedArray, function (specificationSelectedArrayIndex, specificationSelected) {

                // 匹配
                if(productFashionSpecificationsVo.standardCode == specificationSelected.code && productFashionSpecificationsVo.value == specificationSelected.value) {
                    matchs ++;
                    // 匹配成功进行下次遍历
                    return false;
                }

            });

        });

        // 规格数量完成匹配
        if(checkSpecificationSelectedArray.length == matchs) {
            match = true;
            return false;
        }
    });

    // 能匹配上代表可选规格属性
    if(match) {
        item.removeClass("itemDisabled").addClass("item");
    } else {
        item.removeClass("item").addClass("itemDisabled");
    }

}


