<?php

namespace App\DataTables;

use App\Models\Transactions;
use Yajra\DataTables\Services\DataTable;
use Yajra\DataTables\EloquentDataTable;

class PendingTransactionsDataTable extends DataTable
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
            ->addColumn('txn_time', function ($query){
                return $query->req_field7;
            })
            ->addColumn('txn_status', function ($query){
                return $query->res_field48;
            })
            ->addColumn('txn_type', function ($query){
                return $query->req_field122;
            })
            ->addColumn('txn_ref', function ($query){
                return $query->req_field37;
            })
            ->addColumn('amt_sent', function ($query){
                return $query->req_field49." ".$query->req_field4;
            })
            ->addColumn('amt_received', function ($query){
                return $query->req_field5;
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
            ->addColumn('receiver_bank', function ($query){
                return $query->req_field112;
            })
            ->addColumn('action', 'transactions.datatables_actions');
//            ->setRowAttr([
//                'style' => function($query){
////                dd($query->res_field48);
//                    return $query->res_field48 == "FAILED" ? 'background-color: #ff0000;' :
//                        ( $query->res_field48 == "COMPLETED" ? 'background-color: green;' : null);
//                }
//            ]);
    }

    /**
     * Get query source of dataTable.
     *
     * @param \App\Models\Transactions $model
     * @return \Illuminate\Database\Eloquent\Builder
     */
    public function query(Transactions $model)
    {
        return $model->where('res_field48', 'UPLOADED')->newQuery();
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
                'dom'       => 'Bfrtip',
                'stateSave' => true,
                'order'     => [[0, 'desc']],
                'buttons'   => [
//                    ['extend' => 'create', 'className' => 'btn btn-default btn-sm no-corner',],
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
            'txn_time' => ['name' => 'req_field7'],
            'txn_status' => ['name' => 'res_field48'],
            'txn_type'  => ['name' => 'req_field41'],
            'txn_ref'  => ['name' => 'req_field37'],
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
        return 'successtransactionsdatatable_' . time();
    }
}
