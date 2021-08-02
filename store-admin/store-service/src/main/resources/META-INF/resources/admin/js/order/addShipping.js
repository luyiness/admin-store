/**
 * Created by 张金广 on 2018/8/24.
 */
var orderNo;

function showAddShipping() {
    $("#addLogis").removeClass("hide");
}

/*获取订单及物流信息*/
$(function addShipping() {
    orderNo = $("#orderNo").val();
    $.ajax({
        url: "/store-admin/mallShipping/queryShipping",
        type: "GET",
        data: {
            orderNo: orderNo
        },
        dataType: "json",
        success: function (result) {
            if (result.success) {
                $('#shippingInfo').html(template('shippingInfoTemplete', {result: result}));
            }
        },
        error: function () {
        }
    });
});

/*订单物流添加编辑框*/
$(document).on('click', '#submitEditShipping', submitEditShipping);

function submitEditShipping() {
    var mallShippingVo = {};
    var shippingType = $("#style  option:selected").val();
    var shippingCompany = $("#logisticCompany  option:selected").text();
    var shippingCode = $("#logisCode").val();
    var remark = $("#remark").val();
    var id = $("#shippingId").val();
    var companyCode = $("#logisticCompany").val()
    var styles = $("#style  option:selected").text();

    if (styles != '自送'
        && (shippingType.trim() == ''
            || shippingCompany.trim() == ''
            || shippingCode.trim() == ''
            || companyCode.trim() == '')) {
        window.wxc.xcConfirm("数据为空，请检查。", "error");
        return;
    }
    mallShippingVo.orderNo = orderNo;
    mallShippingVo.shippingType = shippingType;
    mallShippingVo.shippingCompany = shippingCompany;
    mallShippingVo.shippingNo = shippingCode;
    mallShippingVo.remark = remark;
    mallShippingVo.id = id;
    mallShippingVo.shippingCode = companyCode;
    $.ajax({
        url: "/store-admin/mallShipping/addShipping",
        type: "POST",
        contentType: "application/json",
        data: JSON.stringify(mallShippingVo),
        success: function (result) {
            if (result.success) {
                window.location.reload();
            }
        },
        error: function () {
        }
    });
}

/*取消订单物流*/
$(document).on('click', '#cancelEditShipping', cancelEditShipping);

function cancelEditShipping() {
    $("#style").val("");
    $("#logisticCompany").val("");
    $("#logisCode").val("");
    $("#remark").val("");
    $("#shippingId").val("");
    $("#addLogis").addClass("hide");
}

/*删除订单物流信息*/
function deleteShippingInfo(obj) {
    $.ajax({
        url: "/store-admin/mallShipping/deleteShipping",
        type: "POST",
        data: {
            id: obj
        },
        dataType: "json",
        success: function (result) {
            if (result) {
                window.location.reload();
            }
        },
        error: function () {
        }
    });
}

/*编辑订单物流*/
function editeShippingInfo(obj, that, type) {
    $("#addLogis").removeClass("hide");
    $.ajax({
        url: "/store-admin/mallShipping/queryShippingById",
        type: "POST",
        data: {
            id: obj
        },
        dataType: "json",
        success: function (result) {
            if (result != null) {
                $("#style").val(result.shippingType);
                $("#logisticCompany option[value=" + result.shippingCode + "]").attr("selected", "selected");
                // $("#logisticCompany").val(result.shippingCompany);
                $("#logisCode").val(result.shippingNo);
                $("#remark").val(result.remark);
                $("#shippingId").val(result.id);
                // console.log(type)
                if (type == '自送') {
                    displayOrNot(false);
                } else {
                    displayOrNot(true);
                }
            }
        },
        error: function () {

        }
    });
}

function displayOrNot(flag) {
    if (flag) {
        $("#shippingCompanyDiv").css("display", "block");
        $("#codeshippings").css("display", "block");

    } else {
        $("#shippingCompanyDiv").css("display", "none");
        $("#codeshippings").css("display", "none");
    }

}