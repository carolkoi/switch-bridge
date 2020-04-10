<?php

namespace App\DataTables;

use App\Models\SwitchSetting;
use Yajra\DataTables\Services\DataTable;
use Yajra\DataTables\EloquentDataTable;

class SwitchSettingDataTable extends DataTable
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
                return $query->setting_id;
            })
            ->addColumn('service_provider', function ($query){
                return $query->setting_profile;
            })
            ->addColumn('setting', function ($query){
                return $query->setting_name;
            })
            ->addColumn('value_type', function ($query){
                return $query->setting_type;
            })
            ->addColumn('status', function ($query){
                return $query->setting_status;
            })
            ->addColumn('action', 'switch_settings.datatables_actions');
    }


    /**
     * Get query source of dataTable.
     *
     * @param \App\Models\SwitchSetting $model
     * @return \Illuminate\Database\Eloquent\Builder
     */
    public function query(SwitchSetting $model)
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
//            'date_time_added',
//            'added_by',
//            'date_time_modified',
//            'modified_by',
//            'source_ip',
//            'latest_ip',
            'id',
            'service_provider' => ['name' => 'setting_profile' ],
            'setting' => ['name' => 'setting_name' ],
            'setting_value',
            'value_type' => ['name' => 'setting_type' ],
            'status',
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
        return 'switch_settingsdatatable_' . time();
    }
}
