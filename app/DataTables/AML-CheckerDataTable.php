<?php

namespace App\DataTables;

use App\Models\AML-Checker;
use Yajra\DataTables\Services\DataTable;
use Yajra\DataTables\EloquentDataTable;

class AML-CheckerDataTable extends DataTable
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

        return $dataTable->addColumn('action', 'a_m_l-_checkers.datatables_actions');
    }

    /**
     * Get query source of dataTable.
     *
     * @param \App\Models\AML-Checker $model
     * @return \Illuminate\Database\Eloquent\Builder
     */
    public function query(AML-Checker $model)
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
            'date_time_added',
            'added_by',
            'date_time_modified',
            'modified_by',
            'source_ip',
            'latest_ip',
            'partner_id',
            'customer_idnumber',
            'transaction_number',
            'customer_name',
            'mobile_number',
            'blacklist_status',
            'response',
            'blacklist_source',
            'remarks',
            'blacklisted',
            'blacklist_version'
        ];
    }

    /**
     * Get filename for export.
     *
     * @return string
     */
    protected function filename()
    {
        return 'a_m_l-_checkersdatatable_' . time();
    }
}
