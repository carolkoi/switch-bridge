
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
        <li class="{{ Request::is('all/failed-transactions*') ? 'active' : '' }}">
            <a href="{{ route('failed-transactions.index') }}"><span class="glyphicon glyphicon-ban-circle"></span><span>Failed Transactions</span></a>
        </li>
        <li class="{{ Request::is('all/pending-transactions*') ? 'active' : '' }}">
            <a href="{{ route('pending-transactions.index') }}"><span class="glyphicon glyphicon-upload"></span><span>Pending Transactions</span></a>
        </li>
    </ul>
</li>
<li class="treeview {{ Request::is('charts*') ? 'active menu-open' : '' }}">
    <a class="dropdown-toggle" href="#">
        <span class="glyphicon glyphicon-object-align-bottom"></span><span>High Charts</span>
        <span class="pull-right-container">
              <i class="fa fa-angle-left pull-right"></i>
            </span>
    </a>
    <ul class="treeview-menu">
        <li class="{{ Request::is('charts/failed-vs-successful*') ? 'active' : '' }}">
            <a href="{{ route('charts.index') }}"><span class="glyphicon glyphicon-random"></span><span>Failed Vs Successful</span></a>

    </ul>
</li>
<li class="divider" style="color:white; padding: 15px"><span><b>Parameters</b></span></li>
<li class="treeview {{ Request::is('configurations*') ? 'active menu-open' : '' }}">
    <a class="dropdown-toggle" href="#">
        <span class="glyphicon glyphicon-cog"></span> <span>Settings</span>
        <span class="pull-right-container">
              <i class="fa fa-angle-left pull-right"></i>
            </span>
    </a>
    <ul class="treeview-menu">
{{--        <li class="{{ Request::is('configurations/globalSettings*') ? 'active' : '' }}">--}}
{{--            <a href="{{ route('settings.index') }}"><i class="fa fa-gears"></i><span>Global Settings</span></a>--}}
{{--        </li>--}}
        <li class="{{ Request::is('configurations/switchSettings*') ? 'active' : '' }}">
            <a href="{!! route('switchSettings.index') !!}"><i class="fa fa-cogs"></i><span>Switch Settings</span></a>
        </li>

    </ul>
</li>
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

    </ul>
</li>
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


<li class="{{ Request::is('amlMakerCheckers*') ? 'active' : '' }}">
    <a href="{!! route('amlMakerCheckers.index') !!}"><i class="fa fa-edit"></i><span>Aml Maker Checkers</span></a>
</li>

