<?php

namespace WizPack\Workflow\DataTables;

use App\Models\Transactions;
use WizPack\Workflow\Models\Approvals;
use WizPack\Workflow\Models\WorkflowStageType;
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
            ->addColumn('requested_by', function ($query){
               return $query->user->name;
            })
            ->addColumn('status', function ($query){
                return $query->approvalStatus();
            })
//            ->addColumn('stage', function ($query){
//                return WorkflowStageType::where('company_id', $query->awaitingStage->workflowStageType->company_id)->first()->name;
////                return WorkF($query->awaitingStage->workflowStageType->company_id);
//            })
            ->addColumn('sent_at', function ($query){
//                return $query->created_at->format('Y-m-d H:i:s');
                return date('Y-m-d H:i:s',strtotime('+3 hours',strtotime($query->created_at->format('Y-m-d H:i:s'))));
            })
            ->addColumn('receiver', function ($query){
                return $query->approvable->req_field108;
            })
            ->addColumn('received_amount', function ($query){
                return intval($query->approvable->req_field5)/100;
            })
            ->addColumn('txn_no', function ($query){
                return $query->approvable->req_field37;
            })
            ->addColumn('primary_txn_ref', function ($query){
                return $query->approvable->req_field34;
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
        return $model->with(['user','transaction'])
            ->whereHasMorph('approvable', Transactions::class)
            ->orderBy('created_at', 'desc')->filterApprovalsByCompany()->newQuery();
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
                'lengthMenu' => [
                    [ 10, 25, 50, -1 ],
                    [ '10 rows', '25 rows', '50 rows', 'Show all' ]
                ],
                'dom' => 'Bfrtip',
                'order' => [[0, 'desc']],
                'buttons' => [
                    ['extend' => 'pageLength', 'className' => 'btn btn-default btn-sm no-corner',],
                    ['extend' => 'export', 'className' => 'btn btn-default btn-sm no-corner',],
                    ['extend' => 'print', 'className' => 'btn btn-default btn-sm no-corner',],
                    ['extend' => 'reset', 'className' => 'btn btn-default btn-sm no-corner',],
                    ['extend' => 'reload', 'className' => 'btn btn-default btn-sm no-corner',],
//                    ['extend' => 'colvis', 'className' => 'btn btn-default btn-sm no-corner',],
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
            'requested_by' => [
                'name' => 'user.name'
            ],
            'sent_at',
//            'stage',
            'receiver' => [
                'name' => 'transaction.req_field108'
            ],
            'received_amount' => [
                'name' => 'transaction.req_field5'
            ],
            'txn_no' => [
                'name' => 'transaction.req_field37'
            ],
            'primary_txn_ref' => [
                'name' => 'transaction.req_field34'
            ],

            'model_id' => ['visible' => false],
            'model_type' => ['visible' => false],
            'collection_name'=>['visible' => false],
            'payload' => ['visible' => false],
//            'sent_by'=> ['visible' => false],
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
