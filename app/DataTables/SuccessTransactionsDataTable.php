<?php

namespace App\DataTables;

use App\Models\Transactions;
use Yajra\DataTables\Services\DataTable;
use Yajra\DataTables\EloquentDataTable;
use Carbon;

class SuccessTransactionsDataTable extends DataTable
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
            ->addColumn('partner', function ($query){
                return $query->req_field123;
            })
            ->addColumn('txn_date', 'transactions.datatables_added')
            ->addColumn('date_modified', 'transactions.datatables_modified')
//
            ->addColumn('paid_date', function ($query){
                return !empty($query->paid_out_date) ? date("Y-m-d H:i:s", strtotime($query->paid_out_date)+10800):null;

//                return date("Y-m-d H:i:s", strtotime($query->paid_out_date)+10800);
            })
            ->addColumn('txn_status', function ($query){
                return $query->res_field48;
            })
            ->addColumn('txn_type', function ($query){
                return $query->req_field41;
            })
            ->addColumn('sync_msg_ref', function ($query){
                return $query->sync_message ? $query->sync_message : "N/A";
            })
            ->addColumn('primary_txn_ref', function ($query){
                return $query->req_field34;
            })
            ->addColumn('txn_no', function ($query){
                return $query->req_field37;
            })
            ->addColumn('amt_sent', function ($query){
                return $query->req_field49." ".intval($query->req_field4)/100;
            })
            ->addColumn('cur', function ($query){
                return $query->req_field50;
            })
            ->addColumn('amt_received', function ($query){
                return intval($query->req_field5)/100;
            })
            ->addColumn('s_p', function ($query){
                return $query->req_field125;
            })
            ->addColumn('sender', function ($query){
                return $query->req_field105;
            })
            ->addColumn('receiver', function ($query){
                return $query->req_field108;
            })
            ->addColumn('receiver_acc/No', function ($query){
                return $query->req_field102;
            })
            ->addColumn('resps', function ($query){
                return $query->res_field44;
            })
            ->escapeColumns('resps')
            ->addColumn('receiver_bank', function ($query){
                return $query->req_field112;
            })
            ->addColumn('action', 'transactions.datatables_actions')
            ->rawColumns(['txn_time', 'action']);


    }

    /**
     * Get query source of dataTable.
     *
     * @param \App\Models\Transactions $model
     * @return \Illuminate\Database\Eloquent\Builder
     */
    public function query(Transactions $model)
    {
        return $model->orderBy('date_time_modified', 'desc')->where('res_field48', 'COMPLETED')->transactionsByCompany()->newQuery();
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
                    [ 10, 25, 50, -1 ],
                    [ '10 rows', '25 rows', '50 rows', 'Show all' ]
                ],
                'dom'       => 'Bfrtip',
                'stateSave' => true,
                'order'     => [[0, 'desc']],
                'buttons'   => [
                    ['extend' => 'pageLength', 'className' => 'btn btn-default btn-sm no-corner',],
                    ['extend' => 'export', 'className' => 'btn btn-default btn-sm no-corner',],
                    ['extend' => 'print', 'className' => 'btn btn-default btn-sm no-corner',],
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
//            'id' => [
//                'visible' => false
//            ],
            'partner' => ['name' => 'req_field123'],
            'txn_date' => ['name' => 'date_time_added'],
            'date_modified' => ['name' => 'date_time_modified'],
            'paid_date' => ['name' => 'paid_out_date'],
            'txn_status' => ['name' => 'res_field48'],
            'txn_type'  => ['name' => 'req_field41'],
            'primary_txn_ref'  => ['name' => 'req_field34'],
            'sync_msg_ref' => ['name' => 'sync_message'],
            'txn_no' => ['name' => 'req_field37'],
            'amt_sent'  => ['name' => 'req_field49'],
            'cur' => ['name' => 'req_field50'],
            'amt_received'  => ['name' => 'req_field5'],
            'sender'  => ['name' => 'req_field105'],
            'receiver'  => ['name' => 'req_field108'],
            'receiver_acc/No'  => ['name' => 'req_field102'],
            'resps'  => ['name' => 'res_field44'],
            's_p'  => ['name' => 'req_field125'],
            'receiver_bank'  => ['name' => 'req_field112'],
        ];

    }

    /**
     * Get filename for export.
     *
     * @return string
     */
    protected function filename()
    {
        return 'successtransactionsdatatable_' . time();
    }
}
