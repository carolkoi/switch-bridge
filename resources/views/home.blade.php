@extends('layouts.app')

@section('content')
    <!-- Content Header (Page header) -->
    <section class="content-header">


    </section>

    <!-- Main content -->
    <section class="content">

        <!-- Default box -->
        <div class="box">
            <div class="box-header with-border">

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
                {{--                <div class="col-12 col-lg-6 col-xl-3">--}}
                {{--                    <div class="widget widget-tile">--}}
                {{--                        <div class="chart sparkline" id="spark1"></div>--}}
                {{--                        <div class="data-info">--}}
                {{--                            <div class="desc">Total</div>--}}
                {{--                            <div class="value"><span class="indicator indicator-equal mdi mdi-chevron-right"></span><span class="number" data-toggle="counter" data-end="113">0</span>--}}
                {{--                            </div>--}}
                {{--                        </div>--}}
                {{--                    </div>--}}
                {{--                </div>--}}
                <div class="col-md-3 col-sm-6 col-xs-12">
                    <div class="info-box">
                        <span class="info-box-icon bg-aqua"><i class="fa fa-file"></i></span>

                        <div class="info-box-content">
                            <span class="info-box-text">All Transactions</span>
                            <span class="info-box-number">
{{--                                    {{$templates->where('survey_type_id', 1)->count()}}--}}
                                27
                                </span>
                        </div>
                        <!-- /.info-box-content -->
                    </div>
                    <!-- /.info-box -->
                </div>
                <div class="col-md-3 col-sm-6 col-xs-12">
                    <div class="info-box">
                        <span class="info-box-icon bg-red"><i class="fa fa-file-text"></i></span>

                        <div class="info-box-content">
                            <span class="info-box-text">Failed Transactions</span>
                            <span class="info-box-number">
{{--                                    {{$templates->where('survey_type_id', 2)->count()}}--}}12
                                </span>
                        </div>
                        <!-- /.info-box-content -->
                    </div>
                    <!-- /.info-box -->
                </div>
                <div class="col-md-3 col-sm-6 col-xs-12">
                    <div class="info-box">
                        <span class="info-box-icon bg-green"><i class="fa fa-file-text"></i></span>

                        <div class="info-box-content">
                            <span class="info-box-text">Successful Transactions</span>
                            <span class="info-box-number">
{{--                            {{$templates->where('survey_type_id', 3)->count()}}--}}
7
                            </span>
                        </div>
                        <!-- /.info-box-content -->
                    </div>
                    <!-- /.info-box -->
                </div>
                <div class="col-md-3 col-sm-6 col-xs-12">
                    <div class="info-box">
                        <span class="info-box-icon bg-yellow"><i class="fa fa-file-text"></i></span>

                        <div class="info-box-content">
                            <span class="info-box-text">Pending Transactions</span>
                            <span class="info-box-number">
{{--                            {{$templates->where('survey_type_id', 4)->count()}}--}}
2
                            </span>
                        </div>
                        <!-- /.info-box-content -->
                    </div>
                    <!-- /.info-box -->
                </div>



            </div>
            <div class="box box-info">
                <div class="box-header with-border">
                    <h3 class="box-title">All Transactions</h3>

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
                                    <td>{{ $transaction->req_field7  }}</td>
                                    <td>{{ $transaction->res_field48 }}</td>
                                    <td>{{ $transaction->req_field122 }}</td>
                                    <td>{{ $transaction->req_field37 }}</td>
                                    <td>{{ $transaction->req_field49. " ".$transaction->req_field4 }}</td>
                                    <td>{{ $transaction->req_field5  }}</td>
                                    {{--                                <td>{{ $transaction->req_field3 }}</td>--}}
                                    <td>{{ $transaction->req_field105  }}</td>
                                    <td>{{ $transaction->req_field108   }}</td>
                                    <td>{{ $transaction->req_field102  }}</td>
                                    <td>{{ $transaction->res_field44. " ". "(".$transaction->res_field39.")"}}</td>
                                    <td>{{ $transaction->req_field112 }}</td>
                                    {{--                                <td>{{ $transaction->req_field104  }}</td>--}}
                                    {{--                                <td>{{ $transaction->sync_message  }}</td>--}}
                                    {{--                                <td>{{ $transaction->sent }}</td>--}}
                                    {{--                                <td>{{ $transaction->aml_check_sent }}</td>--}}
                                    {{--                                <td>{{ $transaction->posted }}</td>--}}
                                    {{--                                <td>{{ $transaction->aml_check_sent }}</td>--}}

                                    {{--                                <td class="text-success">Successful</td>--}}
                                    {{--                                <td>{{ $transaction->res_field4 }}</td>--}}
                                    {{--                                <td>USD</td>--}}
                                    {{--                                <td>{{ $transaction->req_field2 }}</td>--}}

                                    {{--                <td class="text-right">--}}
                                    {{--                    <div class="btn-group btn-hspace">--}}
                                    {{--                        <button class="btn btn-secondary dropdown-toggle" type="button" data-toggle="dropdown">Open <span class="icon-dropdown mdi mdi-chevron-down"></span></button>--}}
                                    {{--                        <div class="dropdown-menu" role="menu"><a class="dropdown-item" href="{{url('/show/transaction/'.$transaction->iso_id)}}">View</a><a class="dropdown-item" href="#">Edit</a><a class="dropdown-item" href="#">Delete</a>--}}
                                    {{--                            <div class="dropdown-divider"></div><a class="dropdown-item" href="#">Separated link</a>--}}
                                    {{--                        </div>--}}
                                    {{--                    </div>--}}
                                    {{--                </td>--}}
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

        </div>
        <!-- /.box -->
    </section>
@endsection
