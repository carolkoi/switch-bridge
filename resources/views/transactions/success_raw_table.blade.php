@section('css')
    @include('layouts.datatables_css')

@endsection

<div class="loader"></div>

{{--    <div class="box-body">--}}

<div class="table-responsive">
    <div class="row">
    </div>
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

    </table>

</div>

@section('scripts')
    @include('layouts.datatables_js')

    <script>
        $(document).ready(function() {
            // fetch_data();

            // function fetch_data(partner = '', type = '', fromto = '') {
            let table = $('#txn-table').DataTable({
                processing: true,
                serverSide: true,
                pageLength: 30,
                retrieve: true,
                paginate: true,
                // bPaginate: true,
                bStateSave: true,
                {{--ajax: "{{ route('transactions.index') }}",--}}
                ajax:{
                    url: "{{ route('success-transactions.index') }}",
                    // data: {req_field123:req_field123}
                    data: function (d) {
                        d.to = $('input[name=to]').val(),
                            d.fromto = $('date_filter').val(),
                            d.req_field41 = $('#txn_type').val(),
                            d.req_field123 = $('#filter-partner').val(),
                            d.search = $('input[type="search"]').val(),
                            d.from = $('input[name=from]').val();
                    },
                },

                // buttons:['excel'],
                // buttons: ['csv', 'excel', 'pdf', 'print', 'reset', 'reload'],
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
                'lengthMenu': [
                    [10, 25, 50, -1],
                    ['10 rows', '25 rows', '50 rows', 'Show all']
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
                    "sProcessing": "Please wait..."
                },

                // "deferRender": true,

                // scrollY: 200,
                // scroller: {
                //     loadingIndicator: true
                // },
            }).load();
            $('#dateSearch').on('click', function() {
                table.draw();
            });
            $('#filter-partner, #txn_type').change(function(){
                table.draw();
            });
            $('#filter-id').click(function(){
                table.draw();
            });
            $('.input-daterange').datepicker({
                autoclose: true,
                todayHighlight: true,
                format: 'yyyy-mm-dd'
                // dateFormat: 'yy-mm-dd'
            });


            // }
            setInterval( function () {
                $('#txn-table').ajax.reload(); // user paging is not reset on reload
            }, 60000);


        } );
    </script>
@endsection


