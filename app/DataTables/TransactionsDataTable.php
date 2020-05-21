<?php

namespace App\DataTables;

use App\Models\Transactions;
use Yajra\DataTables\Services\DataTable;
use Yajra\DataTables\EloquentDataTable;

class TransactionsDataTable extends DataTable
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
//            ->skipPaging()
            ->addColumn('id', function ($query){
                return $query->iso_id;
            })
            ->addColumn('partner', function ($query){
                return $query->req_field123;
            })
            ->addColumn('txn_time', 'transactions.datatables_added')
            ->addColumn('updated_at', 'transactions.datatables_modified')
//            ->addColumn('txn_status', function ($query){
//                return $query->res_field48;
//            })
            ->addColumn('txn_status', 'transactions.datatables_status')
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
//                ->addColumn('amt_sent', 'transactions.datatables_amt_sent')
            ->addColumn('amt_received', function ($query){
                return intval($query->req_field5)/100;
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
            ->addColumn('response', function ($query){
                return $query->res_field44;
            })
            ->addColumn('modified_at', 'transactions.datatables_modified')

            ->escapeColumns('response')
            ->addColumn('receiver_bank', function ($query){
                return $query->req_field112;
            })
            ->addColumn('action', 'transactions.datatables_actions')
            ->rawColumns(['modified_at', 'txn_time', 'action'])
        ->setRowAttr([
                'style' => function($query){
//                dd($query->res_field48);
                    return $query->res_field48 == "FAILED" ? 'color: #ff0000;' :
                        ( $query->res_field48 == "COMPLETED" ? 'color: #2E8B57;' : null);
                }
            ]);
    }

    /**
     * Get query source of dataTable.
     *
     * @param \App\Models\Transactions $model
     * @return \Illuminate\Database\Eloquent\Builder
     */
    public function query(Transactions $model)
    {
        return $model->orderBy('date_time_added', 'desc')->newQuery();
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
//                    'pageLength',
                    ['extend' => 'pageLength', 'className' => 'btn btn-default btn-sm no-corner',],
                    ['extend' => 'export', 'className' => 'btn btn-default btn-sm no-corner',],
                    ['extend' => 'print', 'className' => 'btn btn-default btn-sm no-corner',],
//                    ['extend' => 'reset', 'className' => 'btn btn-default btn-sm no-corner',],
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
//            'id' => [
//                'visible' => false
//            ],
            'partner' => ['name' => 'req_field123'],
            'txn_time' => ['name' => 'date_time_added'],
            'updated_at',
            'txn_status' => ['name' => 'res_field48'],
            'txn_type'  => ['name' => 'req_field41'],
            'primary_txn_ref'  => ['name' => 'req_field34'],
            'sync_msg_ref' => ['name' => 'sync_message'],
            'txn_no' => ['name' => 'req_field37'],
//            'req_field49',
            'amt_sent'  => ['name' => 'req_field49'],
            'amt_received'  => ['name' => 'req_field5'],
            'sender'  => ['name' => 'req_field105'],
//        'req_field105',
            'receiver'  => ['name' => 'req_field108'],
            'receiver_acc/No'  => ['name' => 'req_field102'],
            'response'  => ['name' => 'res_field44'],
//            'res_field39',
            'receiver_bank'  => ['name' => 'req_field112'],
//            'aml_listed',
//            'posted'
        ];
    }


    /**
     * Get filename for export.
     *
     * @return string
     */
    protected function filename()
    {
        return 'transactionsdatatable_' . time();
    }
}
