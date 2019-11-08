    <li class="header">MAIN NAVIGATION</li>
    <li class="{{ Request::is('users*') ? 'active' : '' }}">
        <a href="{!! route('home') !!}"><i class="fa fa-dashboard"></i><span>Dashboard</span></a>
    </li>


    <li class="treeview {{ Request::is('people*') ? 'active menu-open' : '' }}">
        <a class="dropdown-toggle" href="#">
            <i class="fa fa-users"></i> <span>Users</span>
            <span class="pull-right-container">
              <i class="fa fa-angle-left pull-right"></i>
            </span>
        </a>
        <ul class="treeview-menu">
            <li class="{{ Request::is('people/users*') ? 'active' : '' }}">
                <a href="{!! route('users.index') !!}"><i class="fa fa-users"></i><span>Staffs</span></a>
            </li>
            <li class="{{ Request::is('people/clients*') ? 'active' : '' }}">
                <a href="{!! route('clients.index') !!}"><i class="fa fa-users"></i><span>Clients</span></a>
            </li>
        </ul>
    </li>

    <li class="{{ Request::is('templates*') ? 'active' : '' }}">
        <a href="{!! route('templates.index') !!}"><i class="fa fa-file-text"></i><span>Surveys</span></a>
    </li>


<li class="{{ Request::is('allocations*') ? 'active' : '' }}">
    <a href="{!! route('allocations.index') !!}"><i class="fa fa-address-card"></i><span>Allocations</span></a>
</li>
    <li class="{{ Request::is('responses*') ? 'active' : '' }}">
        <a href="{!! route('responses.index') !!}"><i class="fa fa-reply-all"></i><span>Responses</span></a>
    </li>

    <li class="treeview {{ Request::is('report*') ? 'active menu-open' : '' }}">
        <a class="dropdown-toggle" href="#">
            <i class="fa fa-book"></i> <span>Reports</span>
            <span class="pull-right-container">
              <i class="fa fa-angle-left pull-right"></i>
            </span>
        </a>
        <ul class="treeview-menu">
            <li class="{{ Request::is('report/surveyReports*') ? 'active' : '' }}">
                <a href="{!! route('surveyReports.index') !!}"><i class="fa fa-file"></i><span>Survey Reports</span></a>
            </li>
            <li class="{{ Request::is('report/responseReports*') ? 'active' : '' }}">
                <a href="{!! route('responseReports.index') !!}"><i class="fa fa-file-o"></i><span>Response Reports</span></a>
            </li>
        </ul>
    </li>

    <li class="treeview {{ Request::is('settings*') ? 'active menu-open' : '' }}">
        <a class="dropdown-toggle" href="#">
            <i class="fa fa-cogs"></i> <span>Settings</span>
            <span class="pull-right-container">
              <i class="fa fa-angle-left pull-right"></i>
            </span>
        </a>
        <ul class="treeview-menu">
            <li class="{{ Request::is('settings/options*') ? 'active' : '' }}">
                <a href="{!! route('options.index') !!}"><i class="fa fa-bars"></i><span>Options</span></a>
            </li>

            <li class="{{ Request::is('settings/approvalWorkflows*') ? 'active' : '' }}">
                <a href="{!! route('approvalWorkflows.index') !!}"><i class="fa fa-tasks"></i><span>Approval Workflows</span></a>
            </li> </li>
        </ul>
    </li>





