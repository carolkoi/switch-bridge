<?php

namespace WizPack\Workflow\DataTables;

use WizPack\Workflow\Models\WorkflowStageApprovers;
use Yajra\DataTables\DataTableAbstract;
use Yajra\DataTables\Html\Builder;
use Yajra\DataTables\Services\DataTable;
use Yajra\DataTables\EloquentDataTable;

class WorkflowStageApproversDataTable extends DataTable
{
    /**
     * Build DataTable class.
     *
     * @param mixed $query Results from query() method.
     * @return DataTableAbstract
     */
    public function dataTable($query)
    {
        $dataTable = new EloquentDataTable($query);

        return $dataTable
            ->addColumn('Approver', function ($q) {
                return $q->user->name;
            })->editColumn('granted_by', function ($q) {
                return $q->grantedBy->name;
            })->addColumn('workflow_stage', function ($q) {
                return $q->workflowStage->workflowStageType->name;
            })->addColumn('workflow', function ($q) {
                return $q->workflowStage->workflowType->name;
            })
            ->addColumn('action', 'wizpack::workflow_stage_approvers.datatables_actions');
    }

    /**
     * Get query source of dataTable.
     *
     * @param WorkflowStageApprovers $model
     * @return \Illuminate\Database\Eloquent\Builder
     */
    public function query(WorkflowStageApprovers $model)
    {
        return $model
            ->with(['user','workflowStage.workflowStageType', 'workflowStage.workflowType'])
            ->newQuery();
    }

    /**
     * Optional method if you want to use html builder.
     *
     * @return Builder
     */
    public function html()
    {
        return $this->builder()
            ->columns($this->getColumns())
            ->minifiedAjax()
            ->addAction(['width' => '120px', 'printable' => false])
            ->parameters([
                'dom' => 'Bfrtip',
                'stateSave' => true,
                'order' => [[0, 'desc']],
                'buttons' => [
                    ['extend' => 'create', 'className' => 'btn btn-default btn-sm no-corner',],
                    ['extend' => 'export', 'className' => 'btn btn-default btn-sm no-corner',],
                    ['extend' => 'print', 'className' => 'btn btn-default btn-sm no-corner',],
                    ['extend' => 'reset', 'className' => 'btn btn-default btn-sm no-corner',],
                    ['extend' => 'reload', 'className' => 'btn btn-default btn-sm no-corner',],
                ],
            ]);
    }

    /**
     * Get columns.
     *
     * @return array
     */
    protected function getColumns()
    {
        return [
            'id' => [
                'visible' => false
            ],
            'Approver' => [
                'name' => 'user.name'
            ],
            'workflow' => [
                'name' => 'workflowStage.workflowType.name'
            ],
            'workflow_stage' => [
                'name' => 'workflowStage.workflowStageType.name'
            ],
            'granted_by' => [
                'name' => 'user.name'
            ]
        ];
    }

    /**
     * Get filename for export.
     *
     * @return string
     */
    protected function filename()
    {
        return 'workflow_stage_approversdatatable_' . time();
    }
}
