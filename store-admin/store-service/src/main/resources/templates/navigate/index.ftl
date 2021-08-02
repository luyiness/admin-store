<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>商城供应商管理后台</title>
<#include "../include/head.ftl" />
</head>
<body class="hold-transition skin-blue sidebar-mini">
<div class="wrapper" id="main-containter">
<#include "../include/top-menu.ftl"/>
    <!-- Left side column. contains the logo and sidebar -->
<#include "../include/left.ftl"/>
    <div class="content-wrapper">
        <!-- Content Header (Page header) -->
        <section class="content-header">
            <h1>
                导航菜单管理
            </h1>
            <ol class="breadcrumb">
                <li><a href="${ctx}/index.htm"><i class="fa fa-dashboard"></i> 首页</a></li>
                <li class="active"><a href="${ctx}/navigate/list">导航菜单管理</a></li>
            </ol>
        </section>

        <!-- Main content -->
        <section class="content">
            <div class="row">

            <div style="display: none" id="categoryList">
                <select style="width: 90%">
                    <#if categoryList??>
                        <#list categoryList as category>
                           <option value="${category[0]}">${category[1]}</option>
                        </#list>
                    </#if>

                </select>
            </div>

                    <div class="col-xs-12">
                        <form class="form-inline well" style="text-align: right">
                                <button type="button" class="btn" id="btn-advanced-add"
                                        onclick="addNewMenu()">
                                    <i class="fa fa-add"></i>新增菜单
                                </button>
                        </form>

                    <div class="box">
                        <div class="box-body">
                            <table id="navigateTable" style="text-align: center" class="table table-bordered table-striped">
                                <thead>
                                <tr >
                                    <th style="text-align: center">序号</th>
                                    <th style="text-align: center">名称</th>
                                    <th style="text-align: center">排序</th>
                                    <th style="text-align: center">操作</th>
                                </tr>
                                </thead>

                            </table>
                        </div>
                    </div>

            </div>
        </section>
    </div>



<#include "../include/foot.ftl"/>
</div>
<!-- ./wrapper -->
<#include "../include/resource.ftl"/>

<script>
    var isEditing = false;
    var table;

    $(function () {
        //  $('#permTable').DataTable();
        table= $('#navigateTable').DataTable({

            "oLanguage": {
                "sLengthMenu": "每页显示 _MENU_ 条记录",
                "sZeroRecords": "抱歉， 没有找到",
                "sInfo": "从 _START_ 到 _END_ /共 _TOTAL_ 条数据",
                "sInfoEmpty": "没有数据",
                "sInfoFiltered": "(从 _MAX_ 条数据中检索)",
                "oPaginate": {
                    "sFirst": "首页",
                    "sPrevious": "前一页",
                    "sNext": "后一页",
                    "sLast": "尾页"
                },
                "sZeroRecords": "没有检索到数据",
                "sProcessing": "<img src='./loading.gif' />",
                "sSearch": "搜索"
            },

            "bStateSave" : false,
            "bJQueryUI" : true,
            "bPaginate" : false,// 分页按钮
            "bFilter" : false,// 搜索栏
            "bLengthChange" : false,// 每行显示记录数
            "iDisplayLength" : 10,// 每页显示行数
            "bSort" : false,// 排序
            "bInfo" : true,// Showing 1 to 10 of 23 entries 总记录数没也显示多少等信息
            "bWidth" : true,
            "bScrollCollapse" : true,
            "sPaginationType" : "full_numbers", // 分页，一共两种样式 另一种为two_button // 是datatables默认
            //  "bProcessing" : true,
            "bServerSide" : true,
            "bDestroy" : true,
            "bSortCellsTop" : true,
            "sAjaxSource" : "${ctx}/navigate/list",
            //  "sScrollY": "100%",
            "fnInitComplete": function() {
                this.fnAdjustColumnSizing(true);
            },
            "fnServerParams" : function(aoData) {

                aoData.push(

                );
            },
            "aoColumns" : [
                {"data" :  function(row, type, set, meta) {
                    var c = meta.settings._iDisplayStart + meta.row + 1;
                    return c;
                },"sWidth":"15%"},
                {"data" : "productCategory.name" ,"sWidth":"50%"},
                {"data" : "storeNav.sortIndex","sWidth":"15%"}
            ],

            "aoColumnDefs":[
                {
                    "sClass":"center",
                    "aTargets":[3],
                    "data":"storeNav.id",
                    "mRender":function(a,b,c,d){//id，c表示当前记录行对象
                            return '<text value=\"'+a+'\" style=\"cursor:pointer;color:#3c8dbc \" onclick=\"confirmDelete(\''+a+'\')\">删除</text>' +
                                    '&nbsp;&nbsp;&nbsp;&nbsp;'
                                    + '<text style=\"cursor:pointer;color:#3c8dbc \" onclick=\"editNavigate(this)\" >修改</text>';

                    }
                }
            ],
            "fnRowCallback" : function(nRow, aData, iDisplayIndex) {//相当于对字段格式化

            },
            "createdRow": function ( row, data, index ) {

            },
            "fnServerData" : function(sSource, aoData, fnCallback) {
                var serializeData = function(aoData){
                    var data = {};
                    for(var i = 0 ;i<aoData.length ;i++){
                        var dd = aoData[i];
                        if(dd['value']){
                            data[ dd['name'] ]= dd['value'];
                        }
                    }
                    return $.param(data);
                };

                $.ajax({
                    "type" : 'post',
                    "url" : sSource,
                    "data" :serializeData(aoData),
                    "success" : function(resp) {
                        fnCallback(resp);
                    }
                });
            }

        });

    });

    function search(){
        //table.draw();
        table.ajax.reload();
    }

    function editNavigate(aTag) {

        if(isEditing==false){
            isEditing = true;
        }else{
            window.wxc.xcConfirm("当前已有菜单正在编辑中，请保存或取消后重试。", "info");
            return false;
        }

//        alert(aTag.parentNode.parentNode.childNodes.length);
        var childrenElement = aTag.parentNode.parentNode.childNodes;
        var nameElement = childrenElement[1];
        var indexElement = childrenElement[2];
        var buttonElement = childrenElement[3];

        //修改选择框
        var selectElement = document.getElementById("categoryList").cloneNode(true);
        var beforeName = nameElement.innerHTML;

        nameElement.innerHTML="";
        selectElement.setAttribute("style","display:block");
        nameElement.appendChild(selectElement);
        var selectElement1 = selectElement.childNodes[1];
        var optionElements = selectElement1.childNodes;
        for(var i=0;i<optionElements.length;i++){
            if(optionElements[i].innerHTML==beforeName)
            {
                optionElements[i].setAttribute("selected","selected");
                i=optionElements.length;
            }
        }

        //修改排序值
        var indexValue = indexElement.innerHTML;
        indexElement.innerHTML="";
        var inputElement = document.createElement("input");
        inputElement.setAttribute("type","number");
        inputElement.setAttribute("value",indexValue);
        indexElement.appendChild(inputElement);

        var space = buttonElement.childNodes[1].cloneNode(true);
        //将修改按钮删除
        buttonElement.removeChild(buttonElement.childNodes[2]);
        //定义保存按钮
        var saveButton = document.createElement("text");
        saveButton.setAttribute("style","cursor:pointer;color:#3c8dbc");
        saveButton.setAttribute("onclick","confirmSave(this)");
        saveButton.innerHTML="保存";
        //定义取消按钮
        var cancelButton = document.createElement("text");
        cancelButton.setAttribute("style","cursor:pointer;color:#3c8dbc");
        cancelButton.setAttribute("onclick","cancelSave(this)");
        cancelButton.innerHTML="取消";
        //添加按钮进操作栏
        buttonElement.appendChild(saveButton);
        buttonElement.appendChild(space);
        buttonElement.appendChild(cancelButton);
    }

    function confirmSave(aTag) {
        var childrenElement = aTag.parentNode.parentNode.childNodes;
        var nameElement = childrenElement[1];
        var indexElement = childrenElement[2];
        var buttonElement = childrenElement[3];
        var selectElement = nameElement.childNodes[0].childNodes[1];
        var id = buttonElement.childNodes[0].getAttribute("value");
        var categoryId = selectElement.options[selectElement.selectedIndex].value;
        var showIndex = indexElement.childNodes[0].value;
        if(showIndex<=0 || parseInt(showIndex)!=showIndex){
            window.wxc.xcConfirm("请输入正确的排序值", "newCustom");
            return false;
        }else{
            showIndex = parseInt(showIndex);
        }
        $.ajax({
            url: "${ctx}/navigate/checkNavigate",
            type: 'POST',
            dataType: 'json',
            data: {
                id:id,
                categoryId:categoryId,
                index:showIndex
            },
            success:function (data) {
                if(data.status=="success"){
                    $.ajax({
                        url: "${ctx}/navigate/update",
                        type: 'POST',
                        dataType: 'json',
                        data: {
                            id:id,
                            categoryId:categoryId,
                            index:showIndex
                        },
                        success:function (data) {
                            window.wxc.xcConfirm(data.message, data.status);
                            isEditing = false;
                            table.ajax.reload();
                        },
                        error:function () {
                            window.wxc.xcConfirm("异常，请联系管理员。", "error");
                        }
                    })
                }else{
                    window.wxc.xcConfirm(data.message, data.status);
                }
            },
            error:function () {
                window.wxc.xcConfirm("异常，请联系管理员。", "error");
            }
        })

    }

    function cancelSave() {
        table.ajax.reload();
        isEditing = false;
    }

    function newMenu(){
        var tableElement = document.getElementsByTagName("table")[0];
        var tableBody = tableElement.childNodes[3];
        var count = tableBody.childNodes.length+1;
        var newTr = document.createElement("tr");
        if(tableBody.childNodes[0].childNodes.length%4!=0){
            tableBody.childNodes[0].remove();
            count=1;
        }
        if(count%2==0){
            newTr.setAttribute("class","odd");
        }else{
            newTr.setAttribute("class","even");
        }
        //序号
        var newTd = document.createElement("td");
        newTd.innerHTML=count;
        newTr.appendChild(newTd);
        //名称
        newTd = document.createElement("td");
        var selectElement = document.getElementById("categoryList").cloneNode(true);
        selectElement.setAttribute("style","display:block");
        newTd.appendChild(selectElement);
        newTr.appendChild(newTd);
        //排序值
        newTd = document.createElement("td");
        var inputElement = document.createElement("input");
        inputElement.setAttribute("type","number");
        inputElement.value=1;
        newTd.appendChild(inputElement);
        newTr.appendChild(newTd);
        //按钮
        newTd = document.createElement("td");
        //定义id
        var newInput = document.createElement("input");
        newInput.setAttribute("type","hidden");
        newInput.value="new";
        newTd.appendChild(newInput);
        //定义保存按钮
        var saveButton = document.createElement("text");
        saveButton.setAttribute("style","cursor:pointer;color:#3c8dbc");
        saveButton.setAttribute("onclick","confirmSave(this)");
        saveButton.innerHTML="保存";
        //定义取消按钮
        var cancelButton = document.createElement("text");
        cancelButton.setAttribute("style","cursor:pointer;color:#3c8dbc");
        cancelButton.setAttribute("onclick","cancelSave(this)");
        cancelButton.innerHTML="取消";
        //定义两个按钮中间的空白
        var space = document.createElement("text");
        space.innerHTML="&nbsp;&nbsp;&nbsp;&nbsp;";
        //添加按钮进操作栏
        newTd.appendChild(saveButton);
        newTd.appendChild(space);
        newTd.appendChild(cancelButton);

        newTr.appendChild(newTd);

        tableBody.appendChild(newTr);
    }

    function addNewMenu(){
        if(isEditing==false){
            var total = $("tr");
            if(total.size()>=9){
                window.wxc.xcConfirm("当前导航菜单总数已达上限！", "newCustom");
            }
            else {
                isEditing = true;
                newMenu();
            }
        }else{
            window.wxc.xcConfirm("当前已有菜单正在编辑中，请保存或取消后重试。", "info");
        }
    }

    function confirmDelete(id){
        var total = $("tr");
            var url = "${ctx}/navigate/delete";
            var tipTxt = "温馨提示:删除后无法恢复，是否确定删除？";
            var option = {
                onOk: function () {
                    $.ajax({
                        url: url,
                        type: 'POST',
                        dataType: 'json',
                        data: {id: id},
                    })
                            .done(function (data) {
                                window.wxc.xcConfirm(data.message, "success");
                                table.ajax.reload();
                            })
                            .fail(function () {
                                window.wxc.xcConfirm("异常，请联系管理员。", "error");
                            });
                }
            }
            window.wxc.xcConfirm(tipTxt, "confirm", option);

    }

</script>
</body>
</html>
