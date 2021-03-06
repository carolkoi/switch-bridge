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
        @if(Auth::check() && auth()->user()->can('Can View Running Balance'))
        <div class="row">
            <div class="col-md-6 col-sm-6 col-xs-12">
                <div class="info-box">
                    <span class="info-box-icon bg-aqua"><i class="fa fa-money"></i></span>

                    <div class="info-box-content">
                        <span class="info-box-text"><h1>RUNNING BALANCE : {{App\Models\FloatBalance::orderBy('floattransactionid', 'desc')
->where('partnerid', 'CHIPPERCASH')->first()->runningbal}}</h1></span>
{{--                        <span class="info-box-number">{{App\Models\FloatBalance::sum('amount')}}</span>--}}
                    </div>
                    <!-- /.info-box-content -->
                </div>
                <!-- /.info-box -->
            </div>
            @endif
            @if(Auth::check() && auth()->user()->can('Can Top Up Float'))
            <div class="col-md-6 col-sm-12 col-xs-12">
{{--                <div class="info-box">--}}
                    <!-- Trigger/Open The Modal -->
{{--                    <button id="myBtn">Open Modal</button>--}}

{{--                    <span class="info-box-icon bg-yellow addFunds" id="addFunds"><i class="glyphicon glyphicon-plus"></i></span>--}}

                    <div class="info-box-content">
                        <button type="button" class="btn btn-info btn-lg pull-right" data-toggle="modal" data-target="#myModal">ADD FUNDS</button>
{{--                        <span class="info-box-text"><h1>ADD FUNDS</h1></span>--}}
                    </div>
                    <!-- /.info-box-content -->
                </div>
                <!-- /.info-box -->
            </div>
        @endif
            <!-- /.col -->
{{--        </div>--}}
        <div class="row">
            <div class="col-md-12">
                <div class="box box-info">
                    <div class="box-header with-border">
                        <h3 class="box-title">Overall Recap Report</h3>
                    </div>

                </div>
                <!-- /.row -->
            </div>
            <!-- ./box-body -->
            <div class="box-footer">
{{--                <div class="row">--}}
{{--                    <div class="col-sm-3 col-xs-6">--}}
{{--                        <div class="description-block border-right">--}}
{{--                            <span class="description-percentage text-green"><i class="fa fa-caret-up"></i> 17%</span>--}}

{{--                            <span class=" badge bg-aqua"><h5 class="description-header">{{$txn_no}}</h5></span>--}}
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
                <!-- /.row -->
            </div>
            <!-- /.box-footer -->
        </div>
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
{{--                    {{$transactions->render()}}--}}
                    @if (Request::has('page') && Request::get('page') > 1)
                        <a href="{{ route('home', ['page' => Request::get('page') - 1]) }}" class=" btn btn-primary">PREV</a>
                    @endif

                    @if (Request::has('page'))
                        <a href="{{ route('home', ['page' => Request::get('page') + 1]) }}" class="btn btn-default">NEXT</a>
                    @else
                        <a href="{{ route('home', ['page' =>2]) }}" class=" btn btn-primary">Next page</a>
                    @endif
                </div>
                <!-- /.box-footer -->
            </div>

            <!-- Modal -->
            <div class="modal fade" id="myModal" role="dialog">
                <div class="modal-dialog">

                    <!-- Modal content-->
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal">&times;</button>
                            <h4 class="modal-title">Float Top Up</h4>
                        </div>
                        <div class="modal-body">
                            @include('float_balances.home_float')
{{--                            <p>Some text in the modal.</p>--}}
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                        </div>
                    </div>

                </div>
            </div>


    </section>
@endsection

