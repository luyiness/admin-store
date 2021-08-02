<script src="${c_static}/lte/plugins/jQuery/jquery1.11.2.min.js"></script>
<!-- jQuery UI 1.11.4 -->
<script src="${c_static}/lte/plugins/jQueryUI/jquery-ui.min.js"></script>
<!-- Resolve conflict in jQuery UI tooltip with Bootstrap tooltip -->
<script>
    $.widget.bridge('uibutton', $.ui.button);
</script>
<!-- Bootstrap 3.3.6 -->
<script src="${c_static}/lte/bootstrap/js/bootstrap.min.js"></script>
<!-- Morris.js charts -->
<script src="${c_static}/lte/public/js/raphael-min.js"></script>
<script src="${c_static}/lte/plugins/morris/morris.min.js"></script>
<!-- Sparkline -->
<script src="${c_static}/lte/plugins/sparkline/jquery.sparkline.min.js"></script>
<!-- jvectormap -->
<script src="${c_static}/lte/plugins/jvectormap/jquery-jvectormap-1.2.2.min.js"></script>
<script src="${c_static}/lte/plugins/jvectormap/jquery-jvectormap-world-mill-en.js"></script>
<!-- jQuery Knob Chart -->
<script src="${c_static}/lte/plugins/knob/jquery.knob.js"></script>
<!-- daterangepicker -->
<script src="${c_static}/lte/public/js/moment.min.js"></script>
<script src="${c_static}/lte/plugins/daterangepicker/daterangepicker.js"></script>
<!-- datepicker -->
<script src="${c_static}/lte/plugins/datepicker/bootstrap-datepicker.js"></script>
<!-- Bootstrap WYSIHTML5 -->
<script src="${c_static}/lte/plugins/bootstrap-wysihtml5/bootstrap3-wysihtml5.all.min.js"></script>
<!-- Slimscroll -->
<script src="${c_static}/lte/plugins/slimScroll/jquery.slimscroll.min.js"></script>
<!-- DataTables -->
<script src="${c_static}/lte/plugins/datatables/jquery.dataTables.min.js"></script>
<script src="${c_static}/lte/plugins/datatables/dataTables.bootstrap.min.js"></script>
<!-- FastClick -->
<script src="${c_static}/lte/plugins/fastclick/fastclick.js"></script>
<script src="${c_static}/lte/plugins/jqform/jquery.form.js"></script>
<!-- AdminLTE App -->
<script src="${c_static}/lte/dist/js/app.min.js"></script>
<!-- AdminLTE dashboard demo (This is only for demo purposes) -->
<script src="${c_static}/lte/dist/js/pages/dashboard.js"></script>
<!-- AdminLTE for demo purposes -->
<script src="${c_static}/lte/dist/js/demo.js"></script>
<!-- jstree-->
<script src="${c_static}/lte/jstree/jstree.min.js"></script>
<!--- xcConfirm-->
<script src="${c_static}/lte/plugins/xcConfirm/js/xcConfirm.js"></script>

<!--- my97datepicker-->
<script src="${c_static}/lte/plugins/My97DatePicker/WdatePicker.js"></script>

<!-- 转换解析FastJson序列化生成的ref引用，使用方法：var json= FastJson.format(jsonObject) -->
<script src="${c_static}/lte/plugins/fastJson/FastJson-1.0.min.js"></script>

<!-- JQuery Validation 插件 -->
<script src="${c_static}/lte/plugins/validation/jquery.validate.min.js"></script>
<#--附加校验方法，自定义公共校验也可添加到该文件，添加后压缩到additional-methods.min.js-->
<script src="${c_static}/lte/plugins/validation/additional-methods.js"></script>
<script src="${c_static}/lte/plugins/validation/localization/messages_zh.js"></script>

<!--- laypage-->
<script src="${c_static}/lte/plugins/laypage/laypage.js"></script>

<!-- select2-->
<script src="${c_static}/lte/plugins/select2/select2.full.js"></script>
<script src="${c_static}/lte/plugins/select2/i18n/zh-CN.js"></script>

<!-- STATCI_CTX -->
<script type="text/javascript">
    var STATIC_CTX = "${ctx}";
</script>

<script type="text/javascript" src="${p_static}/admin/js/global.js"></script>

<script src="${c_static}/lte/plugins/jQuery/jquery.placeholder.min.js"></script>
<script>
    $(function() {
        $('input, textarea').placeholder();
    });
</script>


