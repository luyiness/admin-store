<style>
    .navbar navbar-static-top{
        background-color: #139ff0;
    }
    .skin-blue .main-header .navbar {
        background-color: #139ff0;
    }
</style>
<header class="main-header">
    <!-- Logo -->
    <a href="${ctx}" class="logo">
        <!-- mini logo for sidebar mini 50x50 pixels -->
        <span class="logo-mini">admin</span>
        <!-- logo for regular state and mobile devices -->
        <#--<span class="logo-lg"><b>集采</b>统一管理系统</span>-->
        <span class="logo-lg">商家管理中心</span>
    </a>
    <!-- Header Navbar: style can be found in header.less -->
    <nav class="navbar navbar-static-top">
        <!-- Sidebar toggle button-->
        <a href="#" class="sidebar-toggle" data-toggle="offcanvas" role="button" id="top-sidebar-toggle">
            <span class="sr-only">Toggle navigation</span>
        </a>

        <div class="navbar-custom-menu">
            <ul class="nav navbar-nav">
                <li class="dropdown user user-menu">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                        <img src="${c_static}/lte/dist/img/user2-160x160.jpg" class="user-image" alt="User Image">
                        <span class="hidden-xs">${user.username!}</span>
                    </a>
                    <ul class="dropdown-menu">
                        <!-- User image -->
                        <li class="user-header">
                            <img src="${c_static}/lte/dist/img/user2-160x160.jpg" class="img-circle" alt="User Image">
                            <div style="font-size: 30px;color:white;margin-top:10px;">
                                <span class="glyphicon glyphicon-user"></span> ${user.username!}
                            </div>
                        </li>
                        <!-- Menu Footer-->
                        <li class="user-footer">
                            <div style="display: table;width: auto;margin-left: auto;margin-right: auto">
                                <a href="${ctx}/login/logout" class="btn btn-default btn-flat">&nbsp;&nbsp;退出&nbsp;&nbsp;</a>
                            </div>
                        </li>
                    </ul>
                </li>
            </ul>
        </div>
    </nav>
</header>