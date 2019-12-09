<?php

namespace WizPack\Workflow\DataTables;

use WizPack\Workflow\Models\WorkflowStageCheckList;
use Yajra\DataTables\DataTableAbstract;
use Yajra\DataTables\Html\Builder;
use Yajra\DataTables\Services\DataTable;
use Yajra\DataTables\EloquentDataTable;

class WorkflowStageCheckListDataTable extends DataTable
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
            ->addColumn('ChecklistName', function ($q){
                return $q->name;
            })
            ->addColumn('workflowStage', function ($q) {
                return $q->workflowStages->workflowStageType->name;
            })
            ->addColumn('action', 'wizpack::workflow_stage_check_lists.datatables_actions');
    }

    /**
     * Get query source of dataTable.
     *
     * @param WorkflowStageCheckList $model
     * @return \Illuminate\Database\Eloquent\Builder
     */
    public function query(WorkflowStageCheckList $model)
    {
        return $model->with(['workflowStages', 'workflowStages.workflowStageType'])->newQuery();
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
            'ChecklistName',
            'text',
            'status',
            'workflowStage'
        ];
    }

    /**
     * Get filename for export.
     *
     * @return string
     */
    protected function filename()
    {
        return 'workflow_stage_check_listsdatatable_' . time();
    }
}
