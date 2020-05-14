<?php

namespace WizPack\Workflow\DataTables;

use WizPack\Workflow\Models\Approvals;
use Yajra\DataTables\DataTableAbstract;
use Yajra\DataTables\Html\Builder;
use Yajra\DataTables\Services\DataTable;
use Yajra\DataTables\EloquentDataTable;

class ApprovalsDataTable extends DataTable
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
            ->addColumn('applicant', function ($query){
               return $query->user->name;
            })
            ->editColumn('status', function ($query){
                return $query->approvalStatus();
            })
            ->addColumn('stage', function ($query){
                return $query->awaitingStage->workflowStageType->name;
            })
            ->editColumn('created_at', function ($query){
//                return $query->created_at->format('Y-m-d H:i:s');
                return date('Y-m-d H:i:s',strtotime('+3 hours',strtotime($query->created_at->format('Y-m-d H:i:s'))));
            })
            ->addColumn('approval_type', function ($query){
                return $query->workflow->name;
            })
            ->addColumn('action', 'wizpack::approvals.datatables_actions')
            ->rawColumns(['status','action']);
    }

    /**
     * Get query source of dataTable.
     *
     * @param Approvals $model
     * @return \Illuminate\Database\Eloquent\Builder
     */
    public function query(Approvals $model)
    {
        return $model->with(['user','awaitingStage.workflowStageType'])->orderBy('created_at', 'desc')->MyApprovals()->newQuery();
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
                'order' => [[0, 'desc']],
                'buttons' => [
                    ['extend' => 'export', 'className' => 'btn btn-default btn-sm no-corner',],
                    ['extend' => 'print', 'className' => 'btn btn-default btn-sm no-corner',],
                    ['extend' => 'reset', 'className' => 'btn btn-default btn-sm no-corner',],
                    ['extend' => 'reload', 'className' => 'btn btn-default btn-sm no-corner',],
                    ['extend' => 'colvis', 'className' => 'btn btn-default btn-sm no-corner',],
                ],
                'fixedHeader' => [
                    'header' => true,
                    'footer' => true,
                ],
                'responsive'=> true
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
            'approval_type',
            'applicant',
            'created_at',
            'stage',
            'model_id' => ['visible' => false],
            'model_type' => ['visible' => false],
            'collection_name'=>['visible' => false],
            'payload' => ['visible' => false],
            'sent_by'=> ['visible' => false],
            'status',
            'approved_at'=> ['visible' => false],
            'rejected_at'=> ['visible' => false],
            'awaiting_stage_id' => ['visible' => false]
        ];
    }

    /**
     * Get filename for export.
     *
     * @return string
     */
    protected function filename()
    {
        return 'approvalsdatatable_' . time();
    }
}
