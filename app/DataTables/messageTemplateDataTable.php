<?php

namespace App\DataTables;

use App\Models\MessageTemplate;
use Yajra\DataTables\Services\DataTable;
use Yajra\DataTables\EloquentDataTable;
use function Clue\StreamFilter\fun;
use function foo\func;

class MessageTemplateDataTable extends DataTable
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
                return $query->messagetypeid;
            })
            ->addColumn('message_type', function($query){
                return $query->messagetype;
            })
            ->addColumn('english_msg', function ($query){
                return $query->eng_message;
            })
            ->addColumn('kiswahili_msg', function ($query){
                return $query->kis_message;
            })
            ->editColumn('datetimeadded', function ($query){
                return date('Y-m-d H:i:s', strtotime($query->datetimeadded));
            })
            ->addColumn('added_by', function($query){
                return $query->user['name'];
            })
            ->addColumn('priority', function ($query){
                return $query->messagepriority;
            })
            ->addColumn('action', 'message_templates.datatables_actions');
    }

    /**
     * Get query source of dataTable.
     *
     * @param \App\Models\MessageTemplate $model
     * @return \Illuminate\Database\Eloquent\Builder
     */
    public function query(MessageTemplate $model)
    {
        return $model->with('user')->newQuery();
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
            'message_type',
            'english_msg',
            'kiswahili_msg',
            'priority',
            'datetimeadded',
            'added_by',
//            'ipaddress',
//            'partnerid',
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
