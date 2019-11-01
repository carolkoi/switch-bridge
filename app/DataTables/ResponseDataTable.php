<?php

namespace App\DataTables;

use App\Models\Response;
use Yajra\DataTables\Services\DataTable;
use Yajra\DataTables\EloquentDataTable;

class ResponseDataTable extends DataTable
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
            ->addColumn('Title', 'responses.datatables_title')
//            ->addColumn('Description', function ($query){
//                return $query->template->description;
//            })
            ->addColumn('users sent', function ($query){
              return  $query->template->allocations->count();
//                foreach ($query->template->allocations as $all){
//                    dd($all);
//                    return $all->groupBy('template_id')->count();
//                }
            })
            ->addColumn('no of respondents', function ($query){
//                dd($query->countRespondentsByTemplateId($query->template_id));
                $no = $query->countRespondentsByTemplateId($query->template_id) / $query->template->questions->count();
                return $no;
            })
            ->addColumn('%age response', function ($query){
                $no = $query->groupBy('template_id')->count()/$query->template->questions->count();
                foreach ($query->template->allocations as $all){
                    $no2 = $all->groupBy('template_id')->count();
                    return ($no/$no2) * 100;
                }

            })
            ->addColumn('action', 'responses.datatables_actions')
            ->rawColumns(['Title','action']);
    }

    /**
     * Get query source of dataTable.
     *
     * @param \App\Models\Response $model
     * @return \Illuminate\Database\Eloquent\Builder
     */
    public function query(Response $model)
    {
        return $model->with(['template','template.allocations'])->groupBy('template_id')->newQuery();
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
            'Title',
//            'Description',
            'users sent',
            'no of respondents',
            '%age response'
        ];
    }

    /**
     * Get filename for export.
     *
     * @return string
     */
    protected function filename()
    {
        return 'responsesdatatable_' . time();
    }
}
