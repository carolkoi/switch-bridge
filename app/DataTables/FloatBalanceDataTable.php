<?php

namespace App\DataTables;

use App\Models\FloatBalance;
use Yajra\DataTables\Services\DataTable;
use Yajra\DataTables\EloquentDataTable;

class FloatBalanceDataTable extends DataTable
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
            ->addColumn('id', function ($query){
                return $query->floattransactionid;
            })
            ->addColumn('action', 'float_balances.datatables_actions');
    }

    /**
     * Get query source of dataTable.
     *
     * @param \App\Models\FloatBalance $model
     * @return \Illuminate\Database\Eloquent\Builder
     */
    public function query(FloatBalance $model)
    {
        return $model->orderBy('floattransactionid', 'desc')->floatByPartner()->newQuery();
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
//                    ['extend' => 'create', 'className' => 'btn btn-default btn-sm no-corner',],
                    ['extend' => 'export', 'className' => 'btn btn-default btn-sm no-corner',],
                    ['extend' => 'print', 'className' => 'btn btn-default btn-sm no-corner',],
                    ['extend' => 'reset', 'className' => 'btn btn-default btn-sm no-corner',],
                    ['extend' => 'reload', 'className' => 'btn btn-default btn-sm no-corner',],
                ],
            ]);
    }

    /**
     * Get columns.h
     *
     * @return array
     */
    protected function getColumns()
    {
        return [
            'description',
            'partnerid',
            'transactionnumber',
            'transactionref',
            'debit',
            'credit',
            'amount',
            'runningbal',
            'datetimeadded',
//            'approved'
//            'addedby',
//            'ipaddress',
        ];
    }

    /**
     * Get filename for export.
     *
     * @return string
     */
    protected function filename()
    {
        return 'float_balances_datatable_' . time();
    }
}
