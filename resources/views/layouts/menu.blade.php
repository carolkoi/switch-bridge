
<ul class="sidebar-menu tree" data-widget="tree">
    <li class="header">MAIN NAVIGATION</li>
    <li class="{{ Request::is('users*') ? 'active' : '' }}">
        <a href="{!! route('home') !!}"><i class="fa fa-dashboard"></i><span>Dashboard</span></a>
    </li>


    <li class="active treeview">
        <a class="dropdown-toggle" href="#">
            <i class="fa fa-users"></i> <span>Users</span>
            <span class="pull-right-container">
              <i class="fa fa-angle-left pull-right"></i>
            </span>
        </a>
        <ul class="treeview-menu">
            <li class="{{ Request::is('users*') ? 'active' : '' }}">
                <a href="{!! route('users.index') !!}"><i class="fa fa-users"></i><span>Staffs</span></a>
            </li>
            <li class="{{ Request::is('clients*') ? 'active' : '' }}">
                <a href="{!! route('clients.index') !!}"><i class="fa fa-users"></i><span>Clients</span></a>
            </li>
        </ul>
    </li>

    <li class="{{ Request::is('templates*') ? 'active' : '' }}">
        <a href="{!! route('templates.index') !!}"><i class="fa fa-file-text"></i><span>Surveys</span></a>
    </li>


{{--<li class="{{ Request::is('questions*') ? 'inactive' : '' }}">--}}
{{--    <a href="{!! route('questions-index') !!}"><i class="fa fa-edit"></i><span>Questions</span></a>--}}
{{--</li>--}}

{{--<li class="{{ Request::is('answers*') ? 'active' : '' }}">--}}
{{--    <a href="{!! route('answers.index') !!}"><i class="fa fa-edit"></i><span>Answers</span></a>--}}
{{--</li>--}}

<li class="{{ Request::is('allocations*') ? 'active' : '' }}">
    <a href="{!! route('allocations.index') !!}"><i class="fa fa-address-card"></i><span>Allocations</span></a>
</li>
    <li class="{{ Request::is('responses*') ? 'active' : '' }}">
        <a href="{!! route('responses.index') !!}"><i class="fa fa-edit"></i><span>Responses</span></a>
    </li>
{{--    <li class="active treeview menu-open">--}}
{{--        <a href="#">--}}
{{--            <i class="fa fa-dashboard"></i> <span>Dashboard</span>--}}
{{--            <span class="pull-right-container">--}}
{{--              <i class="fa fa-angle-left pull-right"></i>--}}
{{--            </span>--}}
{{--        </a>--}}
{{--        <ul class="treeview-menu">--}}
{{--            <li><a href="index.html"><i class="fa fa-circle-o"></i> Dashboard v1</a></li>--}}
{{--            <li class="active"><a href="index2.html"><i class="fa fa-circle-o"></i> Dashboard v2</a></li>--}}
{{--        </ul>--}}
{{--    </li>--}}
</ul>

{{--<li class="{{ Request::is('allocations*') ? 'active' : '' }}">--}}
{{--    <a href="{!! route('allocations.index') !!}"><i class="fa fa-edit"></i><span>Allocations</span></a>--}}
{{--</li>--}}

{{--<li class="{{ Request::is('allocations*') ? 'active' : '' }}">--}}
{{--    <a href="{!! route('allocations.index') !!}"><i class="fa fa-edit"></i><span>Allocations</span></a>--}}
{{--</li>--}}

{{--<li class="{{ Request::is('clients*') ? 'active' : '' }}">--}}
{{--    <a href="{!! route('clients.index') !!}"><i class="fa fa-edit"></i><span>Clients</span></a>--}}
{{--</li>--}}

{{--<li class="{{ Request::is('surveys*') ? 'active' : '' }}">--}}
{{--    <a href="{!! route('surveys.index') !!}"><i class="fa fa-edit"></i><span>Surveys</span></a>--}}
{{--</li>--}}



