<?php

namespace App\DataTables;

use App\Models\Outbox;
use Yajra\DataTables\Services\DataTable;
use Yajra\DataTables\EloquentDataTable;

class OutboxDataTable extends DataTable
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
                return $query->messageoutboxid;
            })
            ->addColumn('messagetype', function ($query){
                return $query->messageType['messagetype'];
            })
            ->addColumn('message', function ($query){
                return $query->message['message'];
            })
            ->addColumn('sent_to', function ($query){
                return $query->message['mobilenumber'];
            })
            ->editColumn('datetimeadded', function ($query){
                return date('Y-m-d H:i:s', strtotime($query->datetimeadded));
            })
            ->editColumn('datetimesent', function ($query){
                return date('Y-m-d H:i:s', strtotime($query->datetimesent));
            })
            ->addColumn('action', 'outboxes.datatables_actions');
    }

    /**
     * Get query source of dataTable.
     *
     * @param \App\Models\Outbox $model
     * @return \Illuminate\Database\Eloquent\Builder
     */
    public function query(Outbox $model)
    {
        return $model->with(['messageType', 'message'])->newQuery();
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
//            'id',
            'messagetype' => [
                'name' => 'messageType.messagetype'
            ],
            'message',
            'sent_to',
            'messagestatus',
            'messagepriority',
            'datetimeadded',
            'datetimesent',
//            'addedby',
//            'ipaddress',
            'attempts',
//            'record_version'
        ];
    }

    /**
     * Get filename for export.
     *
     * @return string
     */
    protected function filename()
    {
        return '$MODEL_NAME_PLURAL_SNAKE_$datatable_' . time();
    }
}
