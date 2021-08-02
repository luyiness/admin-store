
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>请登录</title>
    <!-- Tell the browser to be responsive to screen width -->
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
    <!-- Bootstrap 3.3.6 -->
    <link rel="stylesheet" href="${c_static}/lte/bootstrap/css/bootstrap.min.css">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="${c_static}/lte/awesome-font/css/font-awesome.min.css">
    <!-- Ionicons -->
    <link rel="stylesheet" href="${c_static}/lte/ionicons/css/ionicons.min.css">
    <!-- Theme style -->
    <link rel="stylesheet" href="${c_static}/lte/dist/css/AdminLTE.min.css">
    <!-- iCheck -->
    <link rel="stylesheet" href="${c_static}/lte/plugins/iCheck/square/blue.css">

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
    <script src="${c_static}/lte/public/js/html5shiv.min.js"></script>
    <script src="${c_static}/lte/public/js/respond.min.js"></script>
    <![endif]-->
    <script src="${c_static}/lte/plugins/crypto-js-3.1.9-1/crypto-js.js"></script>
    <style>
        .login-page {
            background: #6ebced;
        }

        .login-logo {
            background: transparent;
            margin-bottom: 0;
            width: 270px;
            margin: 0 auto;
        }
        .login-box{
            background: url(${ctx}/admin/images/container_bg.jpg) no-repeat;
            width: 806px;
            margin-top: 100px;
        }
        .login-box-body{
            background: transparent;
            width: 270px;
            margin: 0 auto;
        }
        .login-logo h3{
            font-size: 30px;
            color: #7f6f67;
            line-height: 32px;
            font-weight: normal;
        }
        .login-box-con{
            width: 480px;
            margin-left: 320px;
            padding: 35px 0;
            background-color: white;
        }
    </style>
</head>
<body class="hold-transition login-page">
<div class="login-box">
    <div class="login-box-con">
        <div class="login-logo">
            <h3>商家管理中心</h3>
        </div>
        <!-- /.login-logo -->
        <div class="login-box-body">
            <p class="login-box-msg" style="padding-bottom: 10px;">请输入用户密码登录</p>
            <#if shiroLoginFailure??>
                <#if shiroLoginFailure == "org.apache.shiro.authc.LockedAccountException">
                    <span class="text-red">密码错误3次，账号已被锁定!</span>
                <#elseif shiroLoginFailure == "org.apache.shiro.authc.ExcessiveAttemptsException">
                    <span class="text-red">登录失败10次，您的ip已被锁定!</span>
                <#elseif shiroLoginFailure == "org.apache.shiro.authc.UnknownAccountException">
                    <span class="text-red">用户名或密码错误!</span>
                <#elseif shiroLoginFailure == "org.apache.shiro.authc.IncorrectCredentialsException">
                    <span class="text-red">用户名或密码错误!</span>
                <#elseif shiroLoginFailure == "org.apache.shiro.authc.DisabledAccountException">
                    <span class="text-red">管理员无效，不可登录系统!</span>
                </#if>

            </#if>
            <form action="${ctx}/login" method="post">
                <div class="form-group has-feedback">
                    <input type="text" class="form-control" name="username" placeholder="请输入您的账号">
                    <span class="glyphicon glyphicon-user form-control-feedback"></span>
                <#if shiroLoginFailure??>
                    <#if shiroLoginFailure == "org.apache.shiro.authc.pam.UnsupportedTokenException">
                        <span class="text-red" style="margin-top:-10px">账户名不能为空!</span>
                    </#if>
                </#if>
                </div>

                <div class="form-group has-feedback">
                    <input type="password" name="password" class="form-control" placeholder="请输入您的密码">
                    <span class="glyphicon glyphicon-lock form-control-feedback"></span>
                <#if shiroLoginFailure??>
                    <#if shiroLoginFailure == "org.apache.shiro.authc.CredentialsException">
                        <span class="text-red">密码不能为空!</span>
                    </#if>
                </#if>
                </div>

                <div class="row">
                  <#--  <div class="col-xs-8">
                        <div class="checkbox icheck">
                        &lt;#&ndash;<label>
                            <input type="checkbox"> Remember Me
                        </label>&ndash;&gt;
                        </div>
                    </div>-->
                    <!-- /.col -->
                    <div class="col-xs-2"></div>
                    <div class="col-xs-8">
                        <button type="button" onclick="login()" class="btn btn-primary btn-block btn-flat"
                                style="margin-top: 25px;">登录
                        </button>
                    </div>
                    <div class="col-xs-2"></div>
                    <!-- /.col -->
                </div>
            </form>

        </div>
        <!-- /.login-box-body -->

    </div>
</div>
<!-- /.login-box -->

<!-- jQuery 2.2.3 -->
<script src="${c_static}/lte/plugins/jQuery/jquery1.11.2.min.js"></script>
<!-- Bootstrap 3.3.6 -->
<script src="${c_static}/lte/bootstrap/js/bootstrap.min.js"></script>
<!-- iCheck -->
<script src="${c_static}/lte/plugins/iCheck/icheck.min.js"></script>
<script>
    $(function () {
        $('input').iCheck({
            checkboxClass: 'icheckbox_square-blue',
            radioClass: 'iradio_square-blue',
            increaseArea: '20%' // optional
        });
        var winH = $(window).height();
        if (winH >= 943) {
            $('.login-box').css('margin-top', '200px')
        } else if (winH <= 631) {
            $('.login-box').css('margin-top', '100px')
        }
    });

    $("body").keydown(function () {
        if (event.keyCode == "13") {//keyCode=13是回车键
            $('button').click();
        }
    });

    function login() {
        let password = $.trim($("input[name='password']").val());
        if (password.length > 0) {
            let key = CryptoJS.enc.Utf8.parse("${loginPasswordKey}");
            let passwordEncrypt = CryptoJS.AES.encrypt(password, key, {iv: key, mode: CryptoJS.mode.CBC}).toString();
            $("input[name='password']").val(passwordEncrypt);
            console.info(passwordEncrypt);
        }
        $("form").submit();
    }
</script>
</body>
</html>
