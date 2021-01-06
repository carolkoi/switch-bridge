@section('css')
    @include('layouts.datatables_css')

@endsection

<div class="loader"></div>

{{--    <div class="box-body">--}}

        <div class="table-responsive">
            <table class="table table-striped table-hover table-bordered table-fw-widget table no-margin" id="txn-table">
                <thead>
                <tr>
                    <th>Partner</th>
                    <th>TXN Date</th>
                    <th>Paid Date</th>
                    <th>TXN Status</th>
                    <th>TXN Type</th>
                    <th>Primary Txn Ref</th>
                    <th>Sync Msg Ref</th>
                    <th>TXN No</th>
                    <th>Sender Cur</th>
                    <th>Amount Sent</th>
                    <th>Rcver Cur</th>
                    <th>Amount Received</th>
{{--                    <th>Sender Cur</th>--}}
                    <th>Sender</th>
                    <th>Receiver</th>
                    <th>Receiver Acc/No </th>
                    <th>Response</th>
                    <th>Receiver Bank </th>
                    <th>Action</th>

                </tr>
                </thead>

{{--                <tbody>--}}

{{--                @foreach($transactions as $transaction)--}}

{{--                    @if ($transaction->res_field48 == 'COMPLETED')--}}
{{--                        <tr class="odd gradeX" style="color: #2E8B57;">--}}
{{--                    @elseif ($transaction->res_field48 == 'FAILED')--}}
{{--                        <tr class="odd gradeX" style="color: #ff0000;">--}}
{{--                    @elseif ($transaction->res_field48 == 'AML-APPROVED')--}}
{{--                        <tr class="odd gradeX" style="color: blue;">--}}
{{--                    @elseif ($transaction->res_field48 == 'UPLOAD-FAILED')--}}
{{--                        <tr class="odd gradeX" style="color: #ff0000;">--}}
{{--                    @else--}}
{{--                        <tr class="odd gradeX">--}}
{{--                            @endif--}}
{{--                                                            <tr class="odd gradeX">--}}

{{--                            <td>{{ $transaction->req_field123  }}</td>--}}
{{--                                                                <td>{{ $transaction->req_field7  }}</td>--}}
{{--                            <td>{{date('Y-m-d H:i:s',strtotime('+3 hours',strtotime(date('Y-m-d H:i:s', ($transaction->date_time_added / 1000)))))}}</td>--}}
{{--                            <td>{{!empty($transaction->paid_out_date) ? date("Y-m-d H:i:s", strtotime($transaction->paid_out_date)+10800):null}}</td>--}}
{{--                            <td>{{ $transaction->res_field48 }}</td>--}}
{{--                            <td>{{ $transaction->req_field41 }}</td>--}}
{{--                            <td>{{ $transaction->req_field34 }}</td>--}}
{{--                            <td>{{$transaction->sync_message ? $transaction->sync_message : "N/A" }}</td>--}}

{{--                            <td>{{ $transaction->req_field37 }}</td>--}}
{{--                            <td>{{ $transaction->req_field49. " ".intval($transaction->req_field4)/100 }}</td>--}}
{{--                            <td>{{$transaction->req_field50}}</td>--}}
{{--                            <td>{{intval($transaction->req_field5)/100  }}</td>--}}
{{--                                                            <td>{{ $transaction->req_field3 }}</td>--}}
{{--                            <td>{{ $transaction->req_field105  }}</td>--}}
{{--                            <td>{{ $transaction->req_field108   }}</td>--}}
{{--                            <td>{{ $transaction->req_field102  }}</td>--}}
{{--                            <td>{!! $transaction->res_field44 !!} </td>--}}
{{--                            <td>{{ $transaction->req_field112 }}</td>--}}
{{--                            <td>@include('transactions.datatables_actions')</td>--}}


{{--                        </tr>--}}
{{--                        @endforeach--}}

{{--                </tbody>--}}
            </table>

        </div>
{{--    </div>--}}
    <!-- /.box-body -->
{{--    <div class="box-footer clearfix">--}}
{{--        {{$transactions->render()}}--}}
{{--    </div>--}}
    <!-- /.box-footer -->
{{--</div>--}}
@section('scripts')
    @include('layouts.datatables_js')

<script>
    $(document).ready(function() {
        let table = $('#txn-table').DataTable( {
            processing: true,
            serverSide: true,
            pageLength:30,
            retrieve: true,
            paginate: true,
            bPaginate: true,
            bStateSave: true,
            ajax: "{{ route('transactions.index') }}",
            // buttons:['excel'],
            buttons : ['csv', 'excel', 'pdf', 'print', 'reset', 'reload'],
            columns: [
                // {data: 'DT_RowIndex', name: 'DT_RowIndex'},
                {data: 'req_field123', name: 'req_field123'},
                // {data: 'req_field7', name: 'req_field7'},
                {data: 'date_time_added', name: 'date_time_added'},
                {data: 'paid_out_date', name: 'paid_out_date'},
                {data: 'res_field48', name: 'res_field48'},
                {data: 'req_field41', name: 'req_field41'},
                {data: 'req_field34', name: 'req_field34'},
                {data: 'sync_message', name: 'sync_message'},
                {data: 'req_field37', name: 'req_field37'},
                {data: 'req_field49', name: 'req_field49'},
                {data: 'req_field4', name: 'req_field4'},
                {data: 'req_field50', name: 'req_field50'},
                {data: 'req_field5', name: 'req_field5'},
                // {data: 'req_field3', name: 'req_field3'},
                {data: 'req_field105', name: 'req_field105'},
                {data: 'req_field108', name: 'req_field108'},
                {data: 'req_field102', name: 'req_field102'},
                {data: 'res_field44', name: 'res_field44'},
                {data: 'req_field112', name: 'req_field112'},

                {data: 'action', name: 'action', orderable: false, searchable: false},
                ],
            dom: 'Bfrtip',
            buttons: [
                'copy', 'csv', 'excel', 'pdf', 'print'
            ],
            'lengthMenu' : [
            [ 10, 25, 50, -1 ],
            [ '10 rows', '25 rows', '50 rows', 'Show all' ]
        ],
            "dom": "<'row'<'col-md-4 col-sm-12'<'pull-left'f>><'col-md-8 col-sm-12'<'table-group-actions pull-right'B>>r><'table-container't><'row'<'col-md-12 col-sm-12'pli>>", // datatable layout
            // "pagingType": "bootstrap_extended",
            "renderer": "bootstrap",
            "searchDelay": 800,
            "bDeferRender": true,
            "autoWidth": false, // disable fixed width and enable fluid table
            "language": { // language settings
                "lengthMenu": "<span class='dt-length-style'><i class='fa fa-bars'></i> &nbsp;View &nbsp;&nbsp;_MENU_ &nbsp;records&nbsp;&nbsp; </span>",
                "info": "<span class='dt-length-records'><i class='fa fa-globe'></i> &nbsp;Found&nbsp;<span class='badge bold badge-dt'>_TOTAL_</span>&nbsp;total records </span>",
                "infoEmpty": "<span class='dt-length-records'>No records found to show</span>",
                "emptyTable": "No data available in table",
                "infoFiltered": "<span class=' '>(filtered from <span class='badge bold badge-dt'>_MAX_</span> total records)</span>",
                "zeroRecords": "No matching records found",
                "search": "<i class='fa fa-search'></i>",
                "paginate": {
                    "previous": "Prev",
                    "next": "Next",
                    "last": "Last",
                    "first": "First",
                    "page": "<span class=' '><i class='fa fa-eye'></i> &nbsp;Page&nbsp;&nbsp;</span>",
                    "pageOf": "<span class=' '>&nbsp;of&nbsp;</span>"
                },
                "sProcessing": "Please wait..."
            }

            // "deferRender": true,

            // scrollY: 200,
            // scroller: {
            //     loadingIndicator: true
            // },
        } );
        setInterval( function () {
            table.ajax.reload(); // user paging is not reset on reload
        }, 180000);
    } );
</script>
    @endsection


