    <li class="header">MAIN NAVIGATION</li>
    <li class="{{ Request::is('users*') ? 'active' : '' }}">
        <a href="{!! route('home') !!}"><i class="fa fa-dashboard"></i><span>Dashboard</span></a>
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

{{--    <li class="treeview {{ Request::is('report*') ? 'active menu-open' : '' }}">--}}
{{--        <a class="dropdown-toggle" href="#">--}}
{{--            <i class="fa fa-book"></i> <span>Reports</span>--}}
{{--            <span class="pull-right-container">--}}
{{--              <i class="fa fa-angle-left pull-right"></i>--}}
{{--            </span>--}}
{{--        </a>--}}
{{--        <ul class="treeview-menu">--}}
{{--            <li class="{{ Request::is('report/surveyReports*') ? 'active' : '' }}">--}}
{{--                <a href="{!! route('surveyReports.index') !!}"><i class="fa fa-file"></i><span>Survey Reports</span></a>--}}
{{--            </li>--}}
{{--            <li class="{{ Request::is('report/responseReports*') ? 'active' : '' }}">--}}
{{--                <a href="{!! route('responseReports.index') !!}"><i class="fa fa-file-o"></i><span>Response Reports</span></a>--}}
{{--            </li>--}}
{{--        </ul>--}}
{{--    </li>--}}
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

{{--    <li class="{{ Request::is('approvals*') ? 'active' : '' }}">--}}
{{--        <a href="{!! route('approvals.index') !!}"><i class="fa fa-edit"></i><span>Approvals</span></a>--}}
{{--    </li>--}}

{{--    <li class="{{ Request::is('workflow*') ? 'active' : '' }} treeview">--}}
{{--        <a href="#">--}}
{{--            <i class="fa fa-dashboard"></i> <span>WorkFlow</span>--}}
{{--            <span class="pull-right-container">--}}
{{--              <i class="fa fa-angle-left pull-right"></i>--}}
{{--            </span>--}}
{{--        </a>--}}
{{--        <ul class="treeview-menu">--}}

{{--            <li class="{{ Request::is('workflowStages*') ? 'active' : '' }}">--}}
{{--                <a href="{!! route('workflowStages.index') !!}"><i class="fa fa-edit"></i><span>Workflow Stages</span></a>--}}
{{--            </li>--}}
{{--            <li class="{{ Request::is('workflowStageApprovers*') ? 'active' : '' }}">--}}
{{--                <a href="{!! route('workflowStageApprovers.index') !!}"><i class="fa fa-edit"></i><span>Workflow Stage Approvers</span></a>--}}
{{--            </li>--}}

{{--            <li class="{{ Request::is('workflowStageCheckLists*') ? 'active' : '' }}">--}}
{{--                <a href="{!! route('workflowStageCheckLists.index') !!}"><i class="fa fa-edit"></i><span>Workflow Stage Check Lists</span></a>--}}
{{--            </li>--}}

{{--            <li class="{{ Request::is('workflowStageTypes*') ? 'active' : '' }}">--}}
{{--                <a href="{!! route('workflowStageTypes.index') !!}"><i--}}
{{--                        class="fa fa-edit"></i><span>Workflow Stage Types</span></a>--}}
{{--            </li>--}}

{{--            <li class="{{ Request::is('workflowTypes*') ? 'active' : '' }}">--}}
{{--                <a href="{!! route('workflowTypes.index') !!}"><i class="fa fa-edit"></i><span>Workflow Types</span></a>--}}
{{--            </li>--}}

{{--        </ul>--}}
{{--    </li>--}}
    @include("wizpack::layouts.menu")

    <li class="treeview {{ Request::is('settings*') ? 'active menu-open' : '' }}">
        <a class="dropdown-toggle" href="#">
            <i class="fa fa-cogs"></i> <span>Settings</span>
            <span class="pull-right-container">
              <i class="fa fa-angle-left pull-right"></i>
            </span>
        </a>
        <ul class="treeview-menu">
            <li class="{{ Request::is('settings/options*') ? 'active' : '' }}">
                <a href="{!! route('options.index') !!}"><i class="fa fa-bars"></i><span>Optional Settings</span></a>
            </li>
            <li class="{{ Request::is('settings/surveyTypes*') ? 'active' : '' }}">
                <a href="{!! route('surveyTypes.index') !!}"><i class="fa fa-edit"></i><span>Survey Types</span></a>
            </li>
        </ul>
    </li>


<li class="{{ Request::is('vendors*') ? 'active' : '' }}">
    <a href="{!! route('vendors.index') !!}"><i class="fa fa-edit"></i><span>Vendors</span></a>
</li>

