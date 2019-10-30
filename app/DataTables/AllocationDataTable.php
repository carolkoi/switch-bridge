<?php

namespace App\DataTables;

use App\Models\Allocation;
use Yajra\DataTables\Services\DataTable;
use Yajra\DataTables\EloquentDataTable;

class AllocationDataTable extends DataTable
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

        return $dataTable->addColumn('type', function ($query){
            return $query->template->type;
        })->addColumn('title', function ($query){
            return $query->template->name;
        })->editColumn('Sent to', function ($query){
            return $query->user_type;
        })->addColumn('No of users sent to', function ($query){
           return $query->CountUsersByTemplateId($query->template_id, $query->user_type);
//            return count($query['user_type']);
        })
        ->addColumn('action', 'allocations.datatables_actions');
    }

    /**
     * Get query source of dataTable.
     *
     * @param \App\Models\Allocation $model
     * @return \Illuminate\Database\Eloquent\Builder
     */
    public function query(Allocation $model)
    {
        return $model->with(['template'])->groupBy(['template_id', 'user_type'])->newQuery();
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
            'type',
            'title',
            'Sent to',
            'No of users sent to',
//            'no of respondents',
//            '%age responses'

        ];
    }

    /**
     * Get filename for export.
     *
     * @return string
     */
    protected function filename()
    {
        return 'allocationsdatatable_' . time();
    }
}
