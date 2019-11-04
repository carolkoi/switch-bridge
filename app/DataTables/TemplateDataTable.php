<?php

namespace App\DataTables;

use App\Models\Template;
use Carbon\Carbon;
use Yajra\DataTables\Services\DataTable;
use Yajra\DataTables\EloquentDataTable;

class TemplateDataTable extends DataTable
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
            ->addColumn('Created By', function ($query){
                return $query->user->first_name. ' '.$query->user->last_name;
            })
            ->editColumn('type', function ($query){
                return $query->type;
            })
            ->editColumn('status', 'templates.datatables_status')
            ->editColumn('name','templates.datables_column_name')
            ->addColumn('no of Questions', 'templates.datatables_question')
            ->addColumn('action', 'templates.datatables_actions')
            ->editColumn('valid_from', function ($query){
                return $query->valid_from->format('Y-m-d');
            })
            ->editColumn('valid_until', function ($query){
                return $query->valid_until->format('Y-m-d');
            })
            ->rawColumns(['name','status','action', 'no of Questions']);
    }

    /**
     * Get query source of dataTable.
     *
     * @param \App\Models\Template $model
     * @return \Illuminate\Database\Eloquent\Builder
     */
    public function query(Template $model)
    {
        return $model->with(['user', 'questions'])->newQuery();
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
            'type',
            'name',
            'valid_from',
            'valid_until',
            'Created By',
            'no of Questions',
            'status'
//            'Questions'
        ];
    }

    /**
     * Get filename for export.
     *
     * @return string
     */
    protected function filename()
    {
        return 'templatesdatatable_' . time();
    }
}
