@extends('layouts.app')

@section('content')
    <!-- Content Header (Page header) -->
    <section class="content-header">
            <h1>
                Statistical Report
            </h1>

    </section>

    <!-- Main content -->
    <section class="content">
{{--        <div class="row">--}}
{{--            <div class="col-md-12">--}}
{{--                <div class="box box-info">--}}
{{--                    <div class="box-header with-border">--}}
{{--                        <h3 class="box-title">Overall Recap Report</h3>--}}
{{--                    </div>--}}

{{--                </div>--}}
{{--                <!-- /.row -->--}}
{{--            </div>--}}
{{--            <!-- ./box-body -->--}}
{{--            <div class="box-footer">--}}
{{--                <div class="row">--}}
{{--                    <div class="col-sm-3 col-xs-6">--}}
{{--                        <div class="description-block border-right">--}}
{{--                            <span class="description-percentage text-green"><i class="fa fa-caret-up"></i> 17%</span>--}}

{{--                            <span class=" badge bg-aqua"><h5 class="description-header">{{count($all_transactions)}}</h5></span>--}}
{{--                            <br>--}}
{{--                            <span class="description-text">ALL TRANSACTIONS</span>--}}
{{--                        </div>--}}
{{--                        <!-- /.description-block -->--}}
{{--                    </div>--}}
{{--                    <!-- /.col -->--}}
{{--                    <div class="col-sm-3 col-xs-6">--}}
{{--                        <div class="description-block border-right">--}}
{{--                            <span class="description-percentage text-yellow"><i class="fa fa-caret-left"></i> 0%</span>--}}
{{--                            <span class=" badge bg-green"><h5 class="description-header">{{$all_transactions->where('res_field48', 'COMPLETED')->count()}}</h5></span>--}}
{{--                            <br>--}}
{{--                            <span class="description-text">SUCCESSFUL TRANSACTIONS</span>--}}
{{--                        </div>--}}
{{--                        <!-- /.description-block -->--}}
{{--                    </div>--}}
{{--                    <!-- /.col -->--}}
{{--                    <div class="col-sm-3 col-xs-6">--}}
{{--                        <div class="description-block border-right">--}}
{{--                            <span class="description-percentage text-green"><i class="fa fa-caret-up"></i> 20%</span>--}}
{{--                            <span class=" badge bg-yellow"> <h5 class="description-header">{{$all_transactions->WhereNotIn('res_field48', ['COMPLETED', 'FAILED'])->count()}}</h5></span>--}}
{{--                           <br>--}}
{{--                            <span class="description-text">PENDING TRANSACTIONS</span>--}}
{{--                        </div>--}}
{{--                        <!-- /.description-block -->--}}
{{--                    </div>--}}
{{--                    <!-- /.col -->--}}
{{--                    <div class="col-sm-3 col-xs-6">--}}
{{--                        <div class="description-block">--}}
{{--                            <span class="description-percentage text-red"><i class="fa fa-caret-down"></i> 18%</span>--}}
{{--                            <span class=" badge bg-red"><h5 class="description-header">{{$all_transactions->where('res_field48', 'FAILED')->count()}}</h5></span>--}}
{{--                            <br>--}}
{{--                            <span class="description-text">FAILED TRANSACTIONS</span>--}}
{{--                        </div>--}}
{{--                        <!-- /.description-block -->--}}
{{--                    </div>--}}
{{--                </div>--}}
{{--                <!-- /.row -->--}}
{{--            </div>--}}
{{--            <!-- /.box-footer -->--}}
{{--        </div>--}}
        <br>
        <div class="row">
            <div class="col-md-12">
                <div class="box box-info">
                    <div class="box-header with-border">
                        <h1 class="box-title">Daily Report</h1>

                        <div class="box-tools pull-right">
                            <button type="button" class="btn btn-box-tool" data-widget="collapse" data-toggle="tooltip" title=""
                                    data-original-title="Collapse">
                                <i class="fa fa-minus"></i></button>
                            <button type="button" class="btn btn-box-tool" data-widget="remove" data-toggle="tooltip" title=""
                                    data-original-title="Remove">
                                <i class="fa fa-times"></i></button>
                        </div>
                    </div>
                    <div class="box-body">
                        <table  class="table table-striped table-hover table-bordered table-fw-widget table no-margin">
                            <thead>
                            <th></th>
                            <th>Yesterday's Report</th>
                            <th>Today's Report</th>
                            </thead>
                            <tbody>
                            <tr><td>All Transactions</td><td><span class=" badge bg-aqua">{{count($yesterday_txns)}}</span></td><td><span class="badge bg-aqua">{{count($today_transactions)}}</span></td></tr>
                            <tr><td>Successful Transactions</td><td><span class=" badge bg-green">{{$yesterday_txns->where('res_field48', 'COMPLETED')->count()}}</span></td><td><span class="badge bg-green">{{$today_transactions->where('res_field48', 'COMPLETED')->count()}}</span></td></tr>
                            <tr><td>Pending Transaction</td><td><span class=" badge bg-yellow">{{$yesterday_txns->WhereNotIn('res_field48', ['COMPLETED', 'FAILED'])->count()}}</span></td><td><span class="badge bg-yellow">{{$today_transactions->WhereNotIn('res_field48', ['COMPLETED', 'FAILED'])->count()}}</span></td></tr>
                            <tr><td>Failed Transaction</td><td><span class=" badge bg-red">{{$yesterday_txns->where('res_field48', 'FAILED')->count()}}</span></td><td><span class="badge bg-red">{{$today_transactions->where('res_field48', 'FAILED')->count()}}</span></td></tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
                </div>

{{--        </div>--}}


            <div class="box box-info">
                <div class="box-header with-border">
                    <h3 class="box-title">Latest Transactions</h3>

                    <div class="box-tools pull-right">
                        <button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i>
                        </button>
                        <button type="button" class="btn btn-box-tool" data-widget="remove"><i class="fa fa-times"></i></button>
                    </div>
                </div>
                <!-- /.box-header -->
                <div class="box-body">

                    <div class="table-responsive">
                        <table class="table table-striped table-hover table-bordered table-fw-widget table no-margin" id="table1">
                            <thead>
                            <tr>
                                <th>Partner</th>
                                <th>TXN Time</th>
                                <th>TXN Status</th>
                                <th>TXN Type</th>
                                <th>TXN Ref</th>
                                <th>Amount Sent</th>
                                <th>Amount Received</th>
                                {{--                                <th>Sender Currency Code</th>--}}
                                <th>Sender</th>
                                <th>Receiver</th>
                                <th>Receiver Acc/No </th>
                                <th>Response</th>
                                <th>Receiver Bank </th>
                                {{--                                <th>Remarks</th>--}}
                                {{--                                <th>Sync Message </th>--}}
                                {{--                                <th>Sync Message Response </th>--}}
                                {{--                                <th>AML Status</th>--}}
                                {{--                                <th>BO Status</th>--}}


                                {{--                                <th>TrackingNumber</th>--}}
                                {{--                                <th>RequestType</th>--}}
                                {{--                                <th>TransactionTime</th>--}}
                                {{--                                <th>TransactionStatus</th>--}}
                                {{--                                <th>Currency</th>--}}
                                {{--                                <th>Mobile</th>--}}
                                {{--            <th style="width:10%;">Actions</th>--}}


                            </tr>
                            </thead>
                            <tbody>
                            {{--                        @php--}}
                            {{--                            $txnStatus = null;--}}
                            {{--                            $row_class = null;--}}
                            {{--                            $completed_row_class = 'green';--}}
                            {{--                            $failed_row_class = 'red';--}}
                            {{--                        @endphp--}}

                            @foreach($transactions as $transaction)
                                <tr class="odd gradeX">
                                    <td>{{ $transaction->req_field123  }}</td>
                                    {{--                                    <td>{{ $transaction->req_field7  }}</td>--}}
                                    <td>{{date('Y-m-d H:i:s',strtotime('+3 hours',strtotime(date('Y-m-d H:i:s', ($transaction->date_time_added / 1000)))))}}</td>

                                    <td>{{ $transaction->res_field48 }}</td>
                                    <td>{{ $transaction->req_field41 }}</td>
                                    <td>{{ $transaction->req_field37 }}</td>
                                    <td>{{ $transaction->req_field49. " ".intval($transaction->req_field4)/100 }}</td>
                                    <td>{{ intval($transaction->req_field5)/100  }}</td>
                                    {{--                                <td>{{ $transaction->req_field3 }}</td>--}}
                                    <td>{{ $transaction->req_field105  }}</td>
                                    <td>{{ $transaction->req_field108   }}</td>
                                    <td>{{ $transaction->req_field102  }}</td>
                                    <td>{!! $transaction->res_field44 !!} </td>
                                    <td>{{ $transaction->req_field112 }}</td>


                                </tr>
                            @endforeach

                            </tbody>
                        </table>
                    </div>
                </div>
                <!-- /.box-body -->
                <div class="box-footer clearfix">
                    {{--                    <a href="javascript:void(0)" class="btn btn-sm btn-info btn-flat pull-left">Place New Order</a>--}}
                    {{--                    <a href="javascript:void(0)" class="btn btn-sm btn-default btn-flat pull-right">View All Orders</a>--}}
                    {{$transactions->links()}}
                </div>
                <!-- /.box-footer -->
            </div>


    </section>
@endsection
