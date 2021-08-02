<style>
    .main-sidebar{

    }
    .skin-blue .sidebar-menu>li.header{
        font-size: 18px;
        color: #FF9800;
        background: #2186c1;
    }
    .skin-blue .wrapper, .skin-blue .main-sidebar, .skin-blue .left-side{
        background-color: #1a6fb2;
    }
    .skin-blue .sidebar-menu>li>.treeview-menu{
        background: #139ff0;
    }
    .skin-blue .treeview-menu>li>a{
        color: #fff;
    }
    .skin-blue .sidebar-menu>li:hover>a, .skin-blue .sidebar-menu>li.active>a{
        background: #3c8dbc;
        border-left-color: #139ff0;
    }
    .skin-blue .main-header .logo{
        background-color: #139ff0;
    }
</style>
<aside class="main-sidebar">
    <!-- sidebar: style can be found in sidebar.less -->
    <section class="sidebar">
        <!-- Sidebar user panel -->
        <div class="user-panel">
            <div class="pull-left image">
                <img src="${c_static}/lte/dist/img/user2-160x160.jpg" class="img-circle" alt="User Image">
            </div>
            <div class="pull-left info">
                <p>${admin!"管理员"}</p>
                <a href="#"><i class="fa fa-circle text-success"></i>在线</a>
            </div>
        </div>
        <!-- search form -->
    <#--<form action="#" method="get" class="sidebar-form">
        <div class="input-group">
            <input type="text" name="q" class="form-control" placeholder="Search...">
      <span class="input-group-btn">
        <button type="submit" name="search" id="search-btn" class="btn btn-flat"><i class="fa fa-search"></i>
        </button>
      </span>
        </div>
    </form>-->
        <!-- /.search form -->
        <!-- sidebar menu: : style can be found in sidebar.less -->
        <ul class="sidebar-menu">
            <li class="header">功能菜单</li>
            <#if adminMenus??>
        <#list adminMenus as menu>
            <#if !menu.isDelete >
                <#if menu.hasChild()>
                    <li class="treeview ${menu.activStatus?string("active menu-open","")}">
                        <a href="javascript:void(0)">
                            <i class="${menu.iconLarge!"fa fa-dashboard"}"></i>
                            <span>${menu.name}</span>
                            <span class="pull-right-container">
                                <i class="${menu.icon!"fa "} fa-angle-left pull-right"></i>
                            </span>
                        </a>
                        <ul class="treeview-menu">
                            <#list menu.childs as subMenu>
                                <#if !subMenu.isDelete>
                                    <li  class="${subMenu.activStatus?string("active","")}" >
                                        <a href="${subMenu.url}">
                                            <i class="${subMenu.iconLarge!"fa fa-circle-o"}"></i> ${subMenu.name}
                                        </a>
                                    </li>
                                </#if>
                            </#list>
                        </ul>
                    </li>
                <#--<#else>-->
                    <#--<li>-->
                        <#--<a href="pages/calendar.html">-->
                            <#--<i class="fa fa-calendar"></i> <span>Calendar</span>-->
                                <#--<span class="pull-right-container">-->
                                  <#--<small class="label pull-right bg-red">3</small>-->
                                  <#--<small class="label pull-right bg-blue">17</small>-->
                                <#--</span>-->
                        <#--</a>-->
                    <#--</li>-->
                </#if>
            </#if>
        </#list>
            </#if>
        </ul>
    </section>
    <!-- /.sidebar -->
</aside>