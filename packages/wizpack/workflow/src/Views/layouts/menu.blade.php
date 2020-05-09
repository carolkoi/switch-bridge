<li class="{{ Request::is('upesi/approvals*') ? 'active' : '' }}">
    <a href="{!! route('upesi::approvals.index') !!}"><i class="fa fa-check-square-o"></i><span>Approvals Requests</span></a>
</li>

<li class="{{ Request::is('upesi*') ? 'active' : '' }} treeview">
    <a href="#">
        <i class="fa fa-dashboard"></i> <span>Approval Flow</span>
        <span class="pull-right-container">
              <i class="fa fa-angle-left pull-right"></i>
            </span>
    </a>
    <ul class="treeview-menu">

        <li class="{{ Request::is('upesi/stage-approvers*') ? 'active' : '' }}">
            <a href="{!! route('upesi::stage-approvers.index') !!}"><i class="fa fa-id-badge"></i><span>Flow Stage Approvers</span></a>
        </li>

        <li class="{{ Request::is('upesi/approval-stages*') ? 'active' : '' }}">
            <a href="{!! route('upesi::approval-stages.index') !!}"><i class="fa fa-line-chart"></i><span> Approval Flow Stages</span></a>
        </li>

{{--        <li class="{{ Request::is('wizpack/workflowStageCheckLists*') ? 'active' : '' }}">--}}
{{--            <a href="{!! route('wizpack::workflowStageCheckLists.index') !!}"><i class="fa fa-edit"></i><span>Workflow Stage Check Lists</span></a>--}}
{{--        </li>--}}

        <li class="{{ Request::is('upesi/approval-partners*') ? 'active' : '' }}">
            <a href="{!! route('upesi::approval-partners.index') !!}"><i
                        class="fa fa-briefcase"></i><span>Approval Flow Partners</span></a>
        </li>

        <li class="{{ Request::is('upesi/approval-types*') ? 'active' : '' }}">
            <a href="{!! route('upesi::approval-types.index') !!}"><i class="fa fa-thumbs-up"></i><span>Approval Types</span></a>
        </li>

    </ul>
</li>
