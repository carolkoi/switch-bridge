<li class="{{ Request::is('wizpack/approvals*') ? 'active' : '' }}">
    <a href="{!! route('wizpack::approvals.index') !!}"><i class="fa fa-check-square-o"></i><span> All Approvals</span></a>
</li>

<li class="{{ Request::is('wizpack/workflow*') ? 'active' : '' }} treeview">
    <a href="#">
        <i class="fa fa-dashboard"></i> <span>Approval Flow</span>
        <span class="pull-right-container">
              <i class="fa fa-angle-left pull-right"></i>
            </span>
    </a>
    <ul class="treeview-menu">

        <li class="{{ Request::is('wizpack/workflowStageApprovers*') ? 'active' : '' }}">
            <a href="{!! route('wizpack::workflowStageApprovers.index') !!}"><i class="fa fa-id-badge"></i><span>Flow Stage Approvers</span></a>
        </li>

        <li class="{{ Request::is('wizpack/workflowStages*') ? 'active' : '' }}">
            <a href="{!! route('wizpack::workflowStages.index') !!}"><i class="fa fa-line-chart"></i><span> Approval Flow Stages</span></a>
        </li>

{{--        <li class="{{ Request::is('wizpack/workflowStageCheckLists*') ? 'active' : '' }}">--}}
{{--            <a href="{!! route('wizpack::workflowStageCheckLists.index') !!}"><i class="fa fa-edit"></i><span>Workflow Stage Check Lists</span></a>--}}
{{--        </li>--}}

        <li class="{{ Request::is('wizpack/workflowStageTypes*') ? 'active' : '' }}">
            <a href="{!! route('wizpack::workflowStageTypes.index') !!}"><i
                        class="fa fa-briefcase"></i><span>Approval Flow Partners</span></a>
        </li>

        <li class="{{ Request::is('wizpack/workflowTypes*') ? 'active' : '' }}">
            <a href="{!! route('wizpack::workflowTypes.index') !!}"><i class="fa fa-thumbs-up"></i><span>Approval Types</span></a>
        </li>

    </ul>
</li>
