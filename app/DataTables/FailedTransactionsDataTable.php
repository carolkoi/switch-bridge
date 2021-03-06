<?php

namespace App\DataTables;

use App\Models\Transactions;
use Illuminate\Support\Facades\Auth;
use Yajra\DataTables\Services\DataTable;
use Yajra\DataTables\EloquentDataTable;

class FailedTransactionsDataTable extends DataTable
{
    /**
     * Build DataTable class.
     *
     * @param mixed $query Results from query() method.
     * @return \Yajra\DataTables\DataTableAbstract
     */
    public function dataTable($query)
    {
        $dataTable = new EloquentDataTable($query);

        return $dataTable
            ->addColumn('partner', function ($query) {
                return $query->req_field123;
            })
            ->addColumn('txn_date', 'transactions.datatables_added')
//            ->addColumn('mod_time', 'transactions.datatables_modified')
            ->addColumn('date_modified', 'transactions.datatables_modified')

            ->addColumn('paid_date', function ($query){
                return $query->paid_out_date;
            })
            ->addColumn('txn_status', function ($query) {
                return $query->res_field48;
            })
            ->addColumn('txn_type', function ($query) {
                return $query->req_field41;
            })
            ->addColumn('sync_msg_ref', function ($query) {
                return $query->sync_message ? $query->sync_message : "N/A";
            })
            ->addColumn('primary_txn_ref', function ($query) {
                return $query->req_field34;
            })
            ->addColumn('txn_no', function ($query) {
                return $query->req_field37;
            })
            ->addColumn('amt_sent', function ($query) {
                return $query->req_field49 . " " . intval($query->req_field4) / 100;
            })
            ->addColumn('s_p', function ($query) {
                return Auth::user()->company_id == 9 ? $query->req_field89 : null;
            })
            ->addColumn('cur', function ($query) {
                return $query->req_field50;
            })
            ->addColumn('amt_received', function ($query) {
                return intval($query->req_field5) / 100;
            })
            ->addColumn('sender', function ($query) {
                return $query->req_field105;
            })
            ->addColumn('receiver', function ($query) {
                return $query->req_field108;
            })
            ->addColumn('receiver_acc/No', function ($query) {
                return $query->req_field102;
            })
            ->addColumn('resps', function ($query) {
                return $query->res_field44;
            })
            ->escapeColumns('resps')
            ->addColumn('receiver_bank', function ($query) {
                return $query->req_field112;
            })
            ->addColumn('modified_at', 'transactions.datatables_modified')
            ->addColumn('action', 'transactions.datatables_actions')
            ->rawColumns(['modified_at', 'txn_time', 'action']);

    }

    /**
     * Get query source of dataTable.
     *
     * @param \App\Models\Transactions $model
     * @return \Illuminate\Database\Eloquent\Builder
     */
    public function query(Transactions $model)
    {
        return $model->orderBy('date_time_added', 'desc')->where('res_field48', 'FAILED')->transactionsByCompany()->newQuery();
    }

    /**
     * Optional method if you want to use html builder.
     *
     * @return \Yajra\DataTables\Html\Builder
     */
    public function html()
    {
        return $this->builder()
            ->columns($this->getColumns())
            ->minifiedAjax()
            ->addAction(['width' => '120px', 'printable' => false])
            ->parameters([
                'lengthMenu' => [
                    [10, 25, 50, -1],
                    ['10 rows', '25 rows', '50 rows', 'Show all']
                ],
                'dom' => 'Bfrtip',
                'stateSave' => true,
                'order' => [[0, 'desc']],
                'buttons' => [
                    ['extend' => 'pageLength', 'className' => 'btn btn-default btn-sm no-corner',],

//                    ['extend' => 'create', 'className' => 'btn btn-default btn-sm no-corner',],
                    ['extend' => 'export', 'className' => 'btn btn-default btn-sm no-corner',],
                    ['extend' => 'print', 'className' => 'btn btn-default btn-sm no-corner',],
//                    ['extend' => 'reset', 'className' => 'btn btn-default btn-sm no-corner',],
                    ['extend' => 'reload', 'className' => 'btn btn-default btn-sm no-corner',],
                    ['extend' => 'colvis', 'className' => 'btn btn-default btn-sm no-corner',],

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
            'partner' => ['name' => 'req_field123'],
            'txn_date' => ['name' => 'date_time_added'],
            'date_modified' => ['name' => 'date_time_modified'],
            'txn_status' => ['name' => 'res_field48'],
            'txn_type' => ['name' => 'req_field41'],
//            'modified_at',
            'primary_txn_ref' => ['name' => 'req_field34'],
            'sync_msg_ref' => ['name' => 'sync_message'],
            'txn_no' => ['name' => 'req_field37'],
            'amt_sent' => ['name' => 'req_field49'],
            'cur' => ['name' => 'req_field50'],
            'amt_received' => ['name' => 'req_field5'],
            'sender' => ['name' => 'req_field105'],
            'receiver' => ['name' => 'req_field108'],
            'receiver_acc/No' => ['name' => 'req_field102'],
            'resps' => ['name' => 'res_field44'],
//            's_p' => ['name' => 'req_field125'],
            'receiver_bank' => ['name' => 'req_field112'],
        ];
    }

    /**
     * Get filename for export.
     *
     * @return string
     */
    protected function filename()
    {
        return 'failedtransactionsdatatable_' . time();
    }
}
