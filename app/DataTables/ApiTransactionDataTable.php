<?php

namespace App\DataTables;

use App\Models\ApiTransaction;
use Yajra\DataTables\Services\DataTable;
use Yajra\DataTables\EloquentDataTable;

class ApiTransactionDataTable extends DataTable
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

        return $dataTable->addColumn('action', 'api_transactions.datatables_actions');
    }

    /**
     * Get query source of dataTable.
     *
     * @param \App\Models\ApiTransaction $model
     * @return \Illuminate\Database\Eloquent\Builder
     */
    public function query(ApiTransaction $model)
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
            'user_activity_log_id',
            'source_ip',
            'latest_ip',
            'request_id',
            'request_number',
            'partner_id',
            'partner_name',
            'transaction_ref',
            'transaction_date',
            'collection_branch',
            'transaction_type',
            'service_type',
            'sender_type',
            'sender_full_name',
            'sender_address',
            'sender_city',
            'sender_country_code',
            'sender_currency_code',
            'sender_mobile',
            'send_amount',
            'sender_id_type',
            'sender_id_number',
            'receiver_type',
            'receiver_full_name',
            'receiver_country_code',
            'receiver_currency_code',
            'receiver_amount',
            'receiver_city',
            'receiver_address',
            'receiver_mobile',
            'mobile_operator',
            'receiver_id_type',
            'receiver_id_number',
            'receiver_account',
            'receiver_bank',
            'receiver_bank_code',
            'receiver_swiftcode',
            'receiver_branch',
            'receiver_branch_code',
            'exchange_rate',
            'commission_amount',
            'remarks',
            'paybill',
            'transaction_number',
            'transaction_hash',
            'transaction_status',
            'original_message',
            'transaction_response',
            'switch_response',
            'query_status',
            'query_response',
            'callbacks',
            'callbacks_status',
            'queued_callbacks',
            'completed_callbacks',
            'callback_status',
            'record_version',
            'need_syncing',
            'synced',
            'sent',
            'incident_code',
            'incident_description',
            'incident_note'
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
