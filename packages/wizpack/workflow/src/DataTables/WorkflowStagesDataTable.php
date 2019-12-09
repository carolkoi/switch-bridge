<?php

namespace WizPack\Workflow\DataTables;

use WizPack\Workflow\Models\WorkflowStage;
use Yajra\DataTables\DataTableAbstract;
use Yajra\DataTables\Html\Builder;
use Yajra\DataTables\Services\DataTable;
use Yajra\DataTables\EloquentDataTable;

class WorkflowStagesDataTable extends DataTable
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

        return $dataTable->addColumn('workflowStageType', function ($q){
            return $q->workflowStageType->name;
        })->addColumn('workflowType', function ($q){
            return $q->workflowType->name;
        })
            ->addColumn('action', 'wizpack::workflow_stages.datatables_actions');
    }

    /**
     * Get query source of dataTable.
     *
     * @param WorkflowStage $model
     * @return \Illuminate\Database\Eloquent\Builder
     */
    public function query(WorkflowStage $model)
    {
        return $model->orderBy('workflow_stages.weight')->with(['workflowStageType','workflowType'])->newQuery();
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
                'dom'       => 'Bfrtip',
                'stateSave' => true,
                'order'     => [[0, 'desc']],
                'buttons'   => [
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
            'workflowStageType'=>[
                'name'=>'workflowStageType.name'
            ],
            'workflowType'=>[
                'name'=>'workflowType.name'
            ],
            'weight'
        ];
    }

    /**
     * Get filename for export.
     *
     * @return string
     */
    protected function filename()
    {
        return 'workflow_stagesdatatable_' . time();
    }
}
