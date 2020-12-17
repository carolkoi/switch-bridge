
<li class="divider" style="color:white; padding: 15px"><span><b>Menu</b></span></li>
{{--<br/>--}}
<li class="{{ Request::is('home*') ? 'active' : '' }}">
    <a href="{{ route('home') }}"><span class="glyphicon glyphicon-home"></span><span>Dashboard</span></a>
</li>

<li class="treeview {{ Request::is('all*') ? 'active menu-open' : '' }}">
    <a class="dropdown-toggle" href="#">
        <span class="glyphicon glyphicon-list-alt"></span> <span>Transaction Manager</span>
        <span class="pull-right-container">
              <i class="fa fa-angle-left pull-right"></i>
            </span>
    </a>
    <ul class="treeview-menu">
        <li class="{{ Request::is('all/transactions*') ? 'active' : '' }}">
            <a href="{{ route('transactions.index') }}"><span class="glyphicon glyphicon-list"></span><span>All Transactions</span></a>
        </li>
        <li class="{{ Request::is('all/successful-transactions*') ? 'active' : '' }}">
            <a href="{{ route('success-transactions.index') }}"><span class="glyphicon glyphicon-check"></span><span> Successful Transactions</span></a>
        </li>

        <li class="{{ Request::is('all/pending-transactions*') ? 'active' : '' }}">
            <a href="{{ route('pending-transactions.index') }}"><span class="glyphicon glyphicon-upload"></span><span>Pending Transactions</span></a>
        </li>
        <li class="{{ Request::is('all/failed-transactions*') ? 'active' : '' }}">
            <a href="{{ route('failed-transactions.index') }}"><span class="glyphicon glyphicon-ban-circle"></span><span>Failed Transactions</span></a>
        </li>
    </ul>
</li>

@if(Auth::check() && auth()->user()->can('Can View Switch Settings'))
<li class="divider" style="color:white; padding: 15px"><span><b>Parameters</b></span></li>
<li class="treeview {{ Request::is('configurations*') ? 'active menu-open' : '' }}">
    <a class="dropdown-toggle" href="#">
        <span class="glyphicon glyphicon-cog"></span> <span>Settings</span>
        <span class="pull-right-container">
              <i class="fa fa-angle-left pull-right"></i>
            </span>
    </a>
    <ul class="treeview-menu">

        <li class="{{ Request::is('configurations/switchSettings*') ? 'active' : '' }}">
            <a href="{!! route('switchSettings.index') !!}"><i class="fa fa-cogs"></i><span>Switch Settings</span></a>
        </li>

    </ul>
</li>
@endif
@if(Auth::check() && auth()->user()->can('Can View Partners'))
<li class="treeview {{ Request::is('list*') ? 'active menu-open' : '' }}">
    <a class="dropdown-toggle" href="#">
        <i class="fa fa-institution"></i> <span>Companies</span>
        <span class="pull-right-container">
              <i class="fa fa-angle-left pull-right"></i>
            </span>
    </a>
    <ul class="treeview-menu">
        <li class="{{ Request::is('list/companies*') ? 'active' : '' }}">
            <a href="{{ route('companies.index') }}"><i class="fa fa-building"></i><span>Companies</span></a>
        </li>
        <li class="{{ Request::is('list/partners*') ? 'active' : '' }}">
            <a href="{{ route('partners.index') }}"><i class="fa fa-building"></i><span>Partners</span></a>
        </li>

    </ul>
</li>
@endif
@if(Auth::check() && auth()->user()->can('Can View Service Providers'))
<li class="treeview {{ Request::is('services*') ? 'active menu-open' : '' }}">
    <a class="dropdown-toggle" href="#">
        <span class="glyphicon glyphicon-globe"></span><span>Service Providers</span>
        <span class="pull-right-container">
              <i class="fa fa-angle-left pull-right"></i>
            </span>
    </a>
    <ul class="treeview-menu">
        <li class="{{ Request::is('services/providers*') ? 'active' : '' }}">
            <a href="{!! route('providers.index') !!}"><span class="glyphicon glyphicon-certificate"></span><span>Providers</span></a>
        </li>
    </ul>
</li>
@endif
@if(Auth::check() && auth()->user()->can('Can Perform AML Check'))
<li class="treeview {{ Request::is('checker*') ? 'active menu-open' : '' }}">
    <a class="dropdown-toggle" href="#">
        <span class="glyphicon glyphicon-repeat"></span><span>AML CHECKER</span>
        <span class="pull-right-container">
              <i class="fa fa-angle-left pull-right"></i>
            </span>
    </a>
    <ul class="treeview-menu">
       <li class="{{ Request::is('/checker/amlMakerCheckers*') ? 'active' : '' }}">
    <a href="{!! route('aml-listing.index') !!}"><i class="fa fa-search"></i><span>Aml Listing</span></a>
</li>
    </ul>
</li>
@endif
{{--@if(Auth::check() && auth()->user()->can('Can Create User'))--}}
<li class="divider" style="color:white; padding: 15px"><span><b>Administration</b></span></li>
<li class="treeview {{ Request::is('members*') ? 'active menu-open' : '' }}">
    <a class="dropdown-toggle" href="#">
        <span class="glyphicon glyphicon-lock"></span><span>Administration</span>
        <span class="pull-right-container">
              <i class="fa fa-angle-left pull-right"></i>
            </span>
    </a>
    <ul class="treeview-menu">
       <li class="{{ Request::is('members/users*') ? 'active' : '' }}">
    <a href="{!! route('users.index') !!}"><i class="fa fa-users"></i><span>Users</span></a>
    </li>
{{--        @if(Auth::check() && auth()->user()->can('Can Create Role'))--}}

        <li class="{{ Request::is('members/roles*') ? 'active' : '' }}">
        <a href="{!! route('roles.index') !!}"><i class="fa fa-user-plus"></i><span>Roles</span></a>
    </li>
{{--        @if(Auth::check() && auth()->user()->can('Can Add Permissions'))--}}
        <li class="{{ Request::is('members/permissions*') ? 'active' : '' }}">
            <a href="{{ route('permissions.index') }}"><i class="fa fa-check-square-o"></i><span>Permissions</span></a>
        </li>
{{--            @endif--}}
{{--            @endif--}}
    </ul>
{{--@endif--}}

{{--@if(Auth::check() && auth()->user()->can('Can Authorize Transaction Update'))--}}

    <li class="divider" style="color:white; padding: 15px"><span><b>Approval Settings</b></span></li>
    @include("wizpack::layouts.menu")
{{--    @endif--}}

{{--<li class="{{ Request::is('partners*') ? 'active' : '' }}">--}}
{{--    <a href="{{ route('partners.index') }}"><i class="fa fa-edit"></i><span>Partners</span></a>--}}
{{--</li>--}}
@if(Auth::check() && auth()->user()->can('Can View Messages'))
<li class="divider" style="color:white; padding: 15px"><span><b>Notifications / Alerts</b></span></li>
<li class="treeview {{ Request::is('notifications*') ? 'active menu-open' : '' }}">
    <a class="dropdown-toggle" href="#">
        <span class="glyphicon glyphicon-alert"></span><span>Notifications</span>
        <span class="pull-right-container">
              <i class="fa fa-angle-left pull-right"></i>
            </span>
    </a>
    <ul class="treeview-menu">
        <li class="{{ Request::is('notifications/messageTemplates*') ? 'active' : '' }}">
            <a href="{{ route('messageTemplates.index') }}"><i class="fa fa-envelope-square"></i><span>Message Templates</span></a>
        </li>

        <li class="{{ Request::is('notifications/messages*') ? 'active' : '' }}">
            <a href="{{ route('messages.index') }}"><i class="fa fa-envelope"></i><span>Messages</span></a>
        </li>

        <li class="{{ Request::is('notifications/outboxes*') ? 'active' : '' }}">
            <a href="{{ route('outboxes.index') }}"><i class="fa fa-envelope-open-o"></i><span>Outboxes</span></a>
        </li>
    </ul>
    @endif



{{--<li class="{{ Request::is('floats*') ? 'active' : '' }}">--}}
{{--    <a href="{{ route('floats.index') }}"><i class="fa fa-edit"></i><span>Float</span></a>--}}
{{--</li>--}}
{{--@if(Auth::check() && auth()->user()->can('Can View Float'))--}}
<li class="{{ Request::is('floatBalances*') ? 'active' : '' }}">
    <a href="{{ route('floatBalances.index') }}"><i class="fa fa-money"></i><span>Float Balances</span></a>
</li>
{{--    @endif--}}

