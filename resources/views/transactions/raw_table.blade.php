<div class="box box-info">
    <div class="box-header with-border">
        <h3 class="box-title">Latest Transactions</h3>

{{--        <div class="box-tools pull-right">--}}
{{--            <button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i>--}}
{{--            </button>--}}
{{--            <button type="button" class="btn btn-box-tool" data-widget="remove"><i class="fa fa-times"></i></button>--}}
{{--        </div>--}}
    </div>
    <!-- /.box-header -->
    <div class="box-body">

        <div class="table-responsive">
            <table class="table table-striped table-hover table-bordered table-fw-widget table no-margin" id="table1">
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
                    {{--                                <th>Sender Currency Code</th>--}}
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
                        <tr class="odd gradeX">
                            @endif
                            {{--                                <tr class="odd gradeX">--}}

                            <td>{{ $transaction->req_field123  }}</td>
                            {{--                                    <td>{{ $transaction->req_field7  }}</td>--}}
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
                            {{--                                <td>{{ $transaction->req_field3 }}</td>--}}
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
    <!-- /.box-body -->
    <div class="box-footer clearfix">
        {{$transactions->render()}}
    </div>
    <!-- /.box-footer -->
</div>
