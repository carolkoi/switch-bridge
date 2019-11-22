<?php

namespace App\DataTables;

use App\Models\Template;
use App\Models\SentSurveys;
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
            ->addColumn('created by', 'templates.datatables_created_by')
            ->addColumn('type', 'templates.datatables_type')
            ->editColumn('name', 'templates.datables_column_name')
            ->addColumn('Questions', 'templates.datatables_question')
            ->addColumn('action', 'templates.datatables_actions')
            ->editColumn('valid_from', function ($query) {

                return Carbon::parse($query->valid_from)->format('d-m-Y');
            })
            ->editColumn('valid_until', function ($query) {
                return Carbon::parse($query->valid_until)->format('d-m-Y');
            })
            ->rawColumns(['name', 'status', 'action', 'Questions', 'Created By', 'type']);
    }

    /**
     * Get query source of dataTable.
     *
     * @param \App\Models\Template $model
     * @return \Illuminate\Database\Eloquent\Builder
     */
    public function query(Template $model)
    {
        return $model->with(['user', 'questions', 'surveyType'])->newQuery();
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
                'dom' => 'Bfrtip',
//                'stateSave' => true,
                'order' => [[0, 'desc']],
                'buttons' => [
                    ['extend' => 'create', 'className' => 'btn btn-default btn-sm no-corner',],
                    ['extend' => 'export', 'className' => 'btn btn-default btn-sm no-corner',],
                    ['extend' => 'print', 'className' => 'btn btn-default btn-sm no-corner',],
//                    ['extend' => 'reset', 'className' => 'btn btn-default btn-sm no-corner',],
                    ['extend' => 'reload', 'className' => 'btn btn-default btn-sm no-corner',],
//                    ['extend' => 'colvis', 'className' => 'btn btn-default btn-sm no-corner',],
                ],
//                'filters'=>[
//
//                ]
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
            'id'=>[
                'visible' => false
            ],
            'type' => [
                'name' => 'surveyType.type'
            ],
            'name',
            'valid_from',
            'valid_until',
            'created by' => [
                'name' => 'user.first_name', 'user.last_name'
            ],
            'Questions',
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
