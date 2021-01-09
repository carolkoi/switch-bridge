<form id="date-form">
    <div class="row">
        <div class="col-md-12">

{{--            <form id="date-form">--}}
                <div class="col-md-4">
{{--                    <label>SELECT DATE</label>--}}

                    <select name="reportdate" id="report_time_id" class="form-control param select2">
                        <option>SELECT REPORTING DATE</option>
                        <option value="trn-date">TRANSACTION DATE</option>
                        <option value="paid-date">PAID OUT DATE</option>

                    </select>
                </div>
                <div class="col-md-6" style="" id="date_range">
                    <div class="input-group date">
                        <div class="input-group-addon">
                            <i class="fa fa-calendar"></i>
                        </div>

                        <input type="text" name="fromto" class="form-control param" id="date_filter"
                               autocomplete="off">
                    </div>

                </div>

{{--                <span class="pull-right">--}}
{{--                                        <div class="btn-group" id="button_filter" style="display: none">--}}
{{--                                                <button type="button" name="filter" id="filter-id" class=" btn btn-primary">Filter</button>--}}
{{--                                                <button type="button" name="refresh" id="refresh" class="btn btn-default">Refresh</button>--}}
{{--                                            </div>--}}
{{--                                    <input type="submit" class="btn btn-primary" value="Filter" id="filter-id">--}}
{{--                                </span>--}}


{{--            </form>--}}
        </div>
    </div>
    <div class="row">

        <div class="col-md-12">


            <div class="">
                <div class="col-md-4">
{{--                    <label>SELECT PARTNER</label>--}}
                    <div class="form-group" id="filter-partner-id" style="">
                        @if(Auth::check() && Auth::user()->company_id == 9)
                            <select name="partner" class="form-control param select2"
                                    id="filter-partner">
                                <option>SELECT PARTNER</option>
                                @foreach($upesi_partners as $partner)
                                    <option
                                        value="{{$partner->partner_name}}">{{$partner->partner_name}}
                                    </option>
                                @endforeach
                            </select>

                        @elseif(Auth::check() && Auth::user()->company_id == 10)
                            <select name="partner" class="form-control param select2"
                                    id="filter-partner">
                                <option>SELECT PARTNER</option>
                                <option
                                    value="10">CHIPPERCASH</option>
                            </select>

                        @elseif(Auth::check() && Auth::user()->company_id == 11)
                            <select name="partner" class="form-control param select2"
                                    id="filter-partner">
                                <option>SELECT PARTNER</option>

                                <option
                                    value="11">NGAO</option>
                            </select>

                        @else
                            <select name="partner" class="form-control param select2"
                                    id="filter-partner">
                                <option>SELECT PARTNER</option>
                                <option value="" selected disabled>SELECT PARTNER</option>
                                @foreach($partners as $partner)
                                    <option
                                        value="{{$partner->partner_name}}">{{$partner->partner_name}}</option>
                                @endforeach
                            </select>

                        @endif
                    </div>
                </div>
                <div class="col-md-4">

                    <div class="form-group" id="txn_type_id" style="">
                        <select name="txn-type" id="txn_type" class="form-control param select2">
                            <option value="" selected disabled>SELECT TYPE</option>
                            @foreach($txnTypes as $key => $txnType)
                                <option value="{{ trim($txnType) }}">{{ trim($txnType) }}</option>
                            @endforeach
                        </select>

                    </div>
                </div>
                <div class="form-group" id="date_filter_id" style="">

                </div>


            </div>
        </div>


    </div>
    <span class="pull-right">
                                        <div class="btn-group" id="button_filter" style="display: none">
                                                <button type="button" name="filter" id="filter-id" class=" btn btn-primary">Filter</button>
                                                <button type="button" name="refresh" id="refresh" class="btn btn-default">Refresh</button>
                                        </div>
                                                            <input type="submit" class="btn btn-primary" value="Filter" id="filter-id">
                                </span>

</form>



<div class="loader"></div>

{{--    <div class="box-body">--}}
<div class="box box-info">
    <div class="box-header with-border">

    <div class="box-body">
{{--        <form>--}}
            <div class="input-group custom-search-form">
                <input type="text" name="search" id="search" class="form-control" style="width: 500px" placeholder="Search Transaction Data" />
{{--                <input type="text" class="form-control" name="search" id="search" style="width: 500px" placeholder="Search...">--}}
{{--                <span class="input-group-btn">--}}
    <button class="btn btn-default-sm" id="search-id" type="submit">
        <i class="fa fa-search"></i>
    </button>
{{--</span>--}}
            </div>
{{--        </form>--}}
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
                    <th>Amount Sent</th>
                    <th>Rcver Cur</th>
                    <th>Amount Received</th>
                    <th>Sender</th>
                    <th>Receiver</th>
                    <th>Receiver Acc/No </th>
                    <th>Response</th>
                    <th>Receiver Bank </th>
                    <th>Action</th>

                </tr>
                </thead>
                <tbody>
                @foreach($transactions as $transaction)

                                    @if ($transaction->res_field48 == 'COMPLETED')
                                        <tr class="odd gradeX" style="color: #2E8B57;">
                                    @elseif ($transaction->res_field48 == 'FAILED')
                                        <tr class="odd gradeX" style="color: #ff0000;">
                                    @elseif ($transaction->res_field48 == 'AML-APPROVED')
                                        <tr class="odd gradeX" style="color: blue;">
                                    @elseif ($transaction->res_field48 == 'UPLOAD-FAILED')
                                        <tr class="odd gradeX" style="color: #ff0000;">
                                    @else
                                        <tr>                                                                                                                                                                                                                  @endif                                                                                                                                                                                                                                                               <tr class="odd gradeX">

                                            <td>{{ $transaction->req_field123  }}</td>
                                            <td>{{date('Y-m-d H:i:s',strtotime('+3 hours',strtotime(date('Y-m-d H:i:s', ($transaction->date_time_added / 1000)))))}}</td>
                                            <td>{{!empty($transaction->paid_out_date) ? date("Y-m-d H:i:s", strtotime($transaction->paid_out_date)+10800):null}}</td>
                                            <td>{{ $transaction->res_field48 }}</td>
                                            <td>{{ $transaction->req_field41 }}</td>
                                            <td>{{ $transaction->req_field34 }}</td>
                                            <td>{{$transaction->sync_message ? $transaction->sync_message : "N/A" }}</td>
                                            <td>{{ $transaction->req_field37 }}</td>
                                            <td>{{ $transaction->req_field49. " ".intval($transaction->req_field4)/100 }}</td>
                                            <td>{{$transaction->req_field50}}</td>
                                            <td>{{intval($transaction->req_field5)/100  }}</td>
                                            <td>{{ $transaction->req_field105  }}</td>
                                            <td>{{ $transaction->req_field108   }}</td>
                                            <td>{{ $transaction->req_field102  }}</td>
                                            <td>{!! $transaction->res_field44 !!} </td>
                                            <td>{{ $transaction->req_field112 }}</td>
                                            <td>@include('transactions.datatables_actions')</td>

                </tr>
                @endforeach
                </tbody>

            </table>

        </div>
    </div>
        <div class="box-footer clearfix">
                                {{$transactions->render()}}
{{--            @if (Request::has('page') && Request::get('page') > 1)--}}
{{--                <a href="{{ route('transactions.index', ['page' => Request::get('page') - 1]) }}" class=" btn btn-primary">PREV</a>--}}
{{--            @endif--}}

{{--            @if (Request::has('page'))--}}
{{--                <a href="{{ route('transactions.index', ['page' => Request::get('page') + 1]) }}" class="btn btn-default">NEXT</a>--}}
{{--            @else--}}
{{--                <a href="{{ route('transactions.index', ['page' =>2]) }}" class=" btn btn-primary">Next page</a>--}}
{{--            @endif--}}
        </div>
        <!-- /.box-footer -->
    </div>
</div>
</div>
@section('js')
    <script type="text/javascript">
        $('#search-id').on('click',function(){
            $value=$('#search').val();
            let partner = $('#filter-partner').val();
            $.ajax({
                type : 'get',
                url : '{{URL::to('search')}}',
                data:{'search':$value},
                success:function(response){
                    console.log(response);
                    // response = JSON.parse(response);
                    // for (var transaction of response) {
                    //     console.log(transaction);
                    // }
                    $('tbody').html(response);
                }
            });
        });
    </script>
    <script type="text/javascript">
            $.ajaxSetup({ headers: { 'csrftoken' : '{{ csrf_token() }}' } });

@endsection

{{--@section('js')--}}
{{--    @include('layouts.datatables_js')--}}

{{--<script>--}}
{{--    $(document).ready(function() {--}}
{{--        // fetch_data();--}}

{{--        // function fetch_data(partner = '', type = '', fromto = '') {--}}
{{--            let table = $('#txn-table').DataTable({--}}
{{--                processing: true,--}}
{{--                serverSide: true,--}}
{{--                pageLength: 30,--}}
{{--                retrieve: true,--}}
{{--                paginate: true,--}}
{{--                bPaginate: true,--}}
{{--                bStateSave: true,--}}
{{--                --}}{{--ajax: "{{ route('transactions.index') }}",--}}
{{--                ajax:{--}}
{{--                    url: "{{ route('transactions.index') }}",--}}
{{--                    // data: {req_field123:req_field123}--}}
{{--                    data: function (d) {--}}
{{--                        d.req_field123 = $('#filter-partner').val(),--}}
{{--                            d.req_field41 = $('#txn_type').val()--}}
{{--                            d.search = $('input[type="search"]').val(),--}}
{{--                        // d.range = $('#date_filter').val()--}}
{{--                        //         d.paid_out_date = $('#date_filter').val()--}}
{{--                                dateInterval = $('#date_filter').val().split(' - ');--}}
{{--                        d.paid_out_date_to= dateInterval[0]--}}
{{--                        d.paid_out_date_to=dateInterval[1]--}}
{{--                    },--}}
{{--                },--}}

{{--                // buttons:['excel'],--}}
{{--                // buttons: ['csv', 'excel', 'pdf', 'print', 'reset', 'reload'],--}}
{{--                columns: [--}}
{{--                    // {data: 'DT_RowIndex', name: 'DT_RowIndex'},--}}
{{--                    {data: 'req_field123', name: 'req_field123'},--}}
{{--                    // {data: 'req_field7', name: 'req_field7'},--}}
{{--                    {data: 'date_time_added', name: 'date_time_added'},--}}
{{--                    {data: 'paid_out_date', name: 'paid_out_date'},--}}
{{--                    {data: 'res_field48', name: 'res_field48'},--}}
{{--                    {data: 'req_field41', name: 'req_field41'},--}}
{{--                    {data: 'req_field34', name: 'req_field34'},--}}
{{--                    {data: 'sync_message', name: 'sync_message'},--}}
{{--                    {data: 'req_field37', name: 'req_field37'},--}}
{{--                    {data: 'req_field49', name: 'req_field49'},--}}
{{--                    {data: 'req_field4', name: 'req_field4'},--}}
{{--                    {data: 'req_field50', name: 'req_field50'},--}}
{{--                    {data: 'req_field5', name: 'req_field5'},--}}
{{--                    // {data: 'req_field3', name: 'req_field3'},--}}
{{--                    {data: 'req_field105', name: 'req_field105'},--}}
{{--                    {data: 'req_field108', name: 'req_field108'},--}}
{{--                    {data: 'req_field102', name: 'req_field102'},--}}
{{--                    {data: 'res_field44', name: 'res_field44'},--}}
{{--                    {data: 'req_field112', name: 'req_field112'},--}}

{{--                    {data: 'action', name: 'action', orderable: false, searchable: false},--}}
{{--                ],--}}
{{--                dom: 'Bfrtip',--}}
{{--                buttons: [--}}
{{--                    'copy', 'csv', 'excel', 'pdf', 'print', 'reset', 'reload'--}}
{{--                ],--}}
{{--                'lengthMenu': [--}}
{{--                    [10, 25, 50, -1],--}}
{{--                    ['10 rows', '25 rows', '50 rows', 'Show all']--}}
{{--                ],--}}
{{--                "dom": "<'row'<'col-md-4 col-sm-12'<'pull-left'f>><'col-md-8 col-sm-12'<'table-group-actions pull-right'B>>r><'table-container't><'row'<'col-md-12 col-sm-12'pli>>", // datatable layout--}}
{{--                // "pagingType": "bootstrap_extended",--}}
{{--                "renderer": "bootstrap",--}}
{{--                "searchDelay": 800,--}}
{{--                "bDeferRender": true,--}}
{{--                "autoWidth": false, // disable fixed width and enable fluid table--}}
{{--                "language": { // language settings--}}
{{--                    "lengthMenu": "<span class='dt-length-style'><i class='fa fa-bars'></i> &nbsp;View &nbsp;&nbsp;_MENU_ &nbsp;records&nbsp;&nbsp; </span>",--}}
{{--                    "info": "<span class='dt-length-records'><i class='fa fa-globe'></i> &nbsp;Found&nbsp;<span class='badge bold badge-dt'>_TOTAL_</span>&nbsp;total records </span>",--}}
{{--                    "infoEmpty": "<span class='dt-length-records'>No records found to show</span>",--}}
{{--                    "emptyTable": "No data available in table",--}}
{{--                    "infoFiltered": "<span class=' '>(filtered from <span class='badge bold badge-dt'>_MAX_</span> total records)</span>",--}}
{{--                    "zeroRecords": "No matching records found",--}}
{{--                    "search": "<i class='fa fa-search'></i>",--}}
{{--                    "paginate": {--}}
{{--                        "previous": "Prev",--}}
{{--                        "next": "Next",--}}
{{--                        "last": "Last",--}}
{{--                        "first": "First",--}}
{{--                        "page": "<span class=' '><i class='fa fa-eye'></i> &nbsp;Page&nbsp;&nbsp;</span>",--}}
{{--                        "pageOf": "<span class=' '>&nbsp;of&nbsp;</span>"--}}
{{--                    },--}}
{{--                    "sProcessing": "Please wait..."--}}
{{--                },--}}

{{--                // "deferRender": true,--}}

{{--                // scrollY: 200,--}}
{{--                // scroller: {--}}
{{--                //     loadingIndicator: true--}}
{{--                // },--}}
{{--            });--}}
{{--        setInterval( function () {--}}
{{--            table.ajax.reload(); // user paging is not reset on reload--}}
{{--        }, 60000);--}}
{{--        $('#filter-partner, #txn_type').change(function(){--}}
{{--            table.draw();--}}
{{--        });--}}
{{--        $('#filter-id').click(function(){--}}
{{--                    dateInterval = $('#date_filter').val().split(' - ');--}}
{{--            paid_out_date_from= dateInterval[0],--}}
{{--            paid_out_date_to=dateInterval[1]--}}
{{--            table.draw();--}}
{{--        });--}}



{{--    } );--}}
{{--</script>--}}
{{--    @endsection--}}


