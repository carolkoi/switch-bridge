<?php

namespace App\DataTables;

use App\Models\AmlMakerChecker;
use Yajra\DataTables\Services\DataTable;
use Yajra\DataTables\EloquentDataTable;

class AmlMakerCheckerDataTable extends DataTable
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
        ->addColumn('id', function($query){
        return $query->blacklist_id;
        })
        ->addColumn('customer_id_number', function($query){
        return $query->customer_idnumber;
        })
        ->addColumn('reason', function($query){
        return $query->response;
        })
        ->escapeColumns('reason')
        ->addColumn('action', 'aml_maker_checkers.datatables_actions');
    }

    /**
     * Get query source of dataTable.
     *
     * @param \App\Models\AmlMakerChecker $model
     * @return \Illuminate\Database\Eloquent\Builder
     */
    public function query(AmlMakerChecker $model)
    {
        return $model->newQuery();
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
                    //['extend' => 'create', 'className' => 'btn btn-default btn-sm no-corner',],
                    ['extend' => 'export', 'className' => 'btn btn-default btn-sm no-corner',],
                    ['extend' => 'print', 'className' => 'btn btn-default btn-sm no-corner',],
                   // ['extend' => 'reset', 'className' => 'btn btn-default btn-sm no-corner',],
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
            //'date_time_added',
           // 'added_by',
            //'date_time_modified',
           // 'modified_by',
           // 'source_ip',
            //'latest_ip',
            //'partner_id',
           'customer_id_number' => [
           'name' => 'customer_idnumber'
           ],
            //'transaction_number',
            'customer_name',
            'mobile_number',
            'blacklist_status',
            'reason' => [
            'name' => 'response'],
//            'blacklist_source',
           // 'remarks',
            //'blacklisted',
            //'blacklist_version'
        ];
    }

    /**
     * Get filename for export.
     *
     * @return string
     */
    protected function filename()
    {
        return 'aml_maker_checkersdatatable_' . time();
    }
}
