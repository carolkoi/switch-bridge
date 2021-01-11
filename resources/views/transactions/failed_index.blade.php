@extends('layouts.app')

@section('content')
    <section class="content-header">
        <h1 class="pull-left"> All Transactions</h1>
    </section>
    <div class="content">
        <div class="clearfix"></div>

        @include('flash::message')

        <div class="clearfix"></div>
        <div class="box box-primary">
            <div class="box-body">
                <div class="row">

                    <div class="col-md-12">

                        <form action="" id="filtersForm">
                            {{--                                        <div class="">--}}
                            <div class="col-md-3">
                                {{--                                                                                        <label>SELECT PARTNER</label>--}}
                                <div class="form-group" id="filter-partner-id" style="">
                                    @if(Auth::check() && Auth::user()->company_id == 9)
                                        <select name="partner" class="form-control param select2"
                                                id="filter-partner">
                                            <option selected disabled>SELECT PARTNER</option>
                                            @foreach($upesi_partners as $partner)
                                                <option
                                                    value="{{$partner->partner_name}}">{{$partner->partner_name}}
                                                </option>
                                            @endforeach
                                        </select>
                                        {{--                                                </div>--}}
                                        {{--                                            </div>--}}

                                    @elseif(Auth::check() && Auth::user()->company_id == 10)
                                        <select name="partner" class="form-control param select2"
                                                id="filter-partner">
                                            <option selected disabled>SELECT PARTNER</option>
                                            <option
                                                value="CHIPPERCASH">CHIPPERCASH</option>
                                        </select>

                                    @elseif(Auth::check() && Auth::user()->company_id == 11)
                                        <select name="partner" class="form-control param "
                                                id="filter-partner">
                                            <option disabled>SELECT PARTNER</option>

                                            <option
                                                value="NGAO">NGAO</option>
                                        </select>

                                    @else
                                        <select name="partner" class="form-control param select2"
                                                id="filter-partner">
                                            <option selected disabled>SELECT PARTNER</option>
                                            @foreach($partners as $partner)
                                                <option
                                                    value="{{$partner->partner_name}}">{{$partner->partner_name}}</option>
                                            @endforeach
                                        </select>

                                    @endif
                                </div>
                            </div>
                            <div class="col-md-3">

                                <div class="form-group" id="txn_type_id" style="">
                                    <select name="txn-type" id="txn_type" class="form-control param select2">
                                        <option selected disabled>SELECT TYPE</option>
                                        @foreach($txnTypes as $key => $txnType)
                                            <option value="{{ trim($txnType) }}">{{ trim($txnType) }}</option>
                                        @endforeach
                                    </select>

                                </div>
                            </div>



                            <div class="col-md-4">
                                {{--                                                    <div class="col-xs-12 form-inline" style="">--}}
                                {{--                                                        <div class="input-daterange input-group" id="datepicker">--}}
                                {{--                                                            <input type="text" class="input-sm form-control" name="from" value="{{\Carbon\Carbon::now()->subDays(3)->format('Y-m-d') }}" />--}}
                                {{--                                                            <span class="input-group-addon">to</span>--}}
                                {{--                                                            <input type="text" class="input-sm form-control" name="to" value="{{ \Carbon\Carbon::now()->addDay(2)->format('Y-m-d') }}"/>--}}
                                {{--                                                        </div>--}}
                                {{--                                                    </div>--}}
                                <div class="input-group date">
                                    <div class="input-group-addon">
                                        <i class="fa fa-calendar"></i>
                                    </div>
                                    <input type="text" name="fromto" class="form-control param" id="date_filter"
                                           autocomplete="off">
                                    {{--                                            {!! Form::text('paid_out_date', null, ['class' => 'form-control', 'autocomplete' => 'off', 'id' => 'paid-out-id']) !!}--}}
                                </div>
                            </div>
                            <span>
                                                        <button type="submit" id="dateSearch" class="btn btn-sm btn-primary">Filter</button>

                                                                        </span>


                            {{--                                                </div>--}}


                            {{--                                        </div>--}}

                        </form>
                    </div>
                </div>
            </div>

            <hr style="color: darkblue">
            <div class="box-body">




                <div>
{{--                    @if(Auth::check() && Auth::user()->company_id == 9)--}}

{{--                    <a class="btn btn-primary pull-right" href="{{route('failed-transaction.export')}}">--}}
{{--                        Export to Excel--}}
{{--                    </a>--}}
{{--                    @endif--}}
                    <form>
                        <div class="form-group" style="width: 800px">
                            <input type="text" name="search" style="width: 500px">
                            <button type="submit">Search</button>
                        </div>
                    </form>


                </div>
            </div>


            @include('transactions.normal_table')
            <div class="box-footer clearfix">
                            {{$transactions->render()}}
{{--                @if (Request::has('page') && Request::get('page') > 1)--}}
{{--                    <a href="{{ route('failed-transactions.index', ['page' => Request::get('page') - 1]) }}" class=" btn btn-primary">PREV</a>--}}
{{--                @endif--}}

{{--                @if (Request::has('page'))--}}
{{--                    <a href="{{ route('failed-transactions.index', ['page' => Request::get('page') + 1]) }}" class="btn btn-default">NEXT</a>--}}
{{--                @else--}}
{{--                    <a href="{{ route('failed-transactions.index', ['page' =>2]) }}" class=" btn btn-primary">Next page</a>--}}
{{--                @endif--}}
            </div>

        </div>
    </div>
    <div class="text-center">

    </div>
    </div>
@endsection
@section('scripts')
    <script>
        // $(document).load(function () {
        $('.input-daterange').datepicker({
            autoclose: true,
            todayHighlight: true,
            format: 'yyyy-mm-dd'
            // dateFormat: 'yy-mm-dd'
        });
        let searchParams = new URLSearchParams(window.location.search);
        let dateInterval = searchParams.get('report_time, from-to');
        // let filterPartner = searchParams.get('filter-partner');
        // let filterTxnType = searchParams.get('txn-type');
        // let selectedPartner = null;
        let start = moment().startOf('month');
        let end = moment();
        // if (filterPartner) {
        //     selectedPartner = filterPartner;
        // }
        if (dateInterval) {
            dateInterval = dateInterval.split(' - ');
            start = dateInterval[0];
            end = dateInterval[1];
        }
        $('#date_filter').daterangepicker({
            "showDropdowns": true,
            "showWeekNumbers": true,
            "alwaysShowCalendars": true,
            startDate: start,
            endDate: end,
            locale: {
                format: 'YYYY-MM-DD',
                firstDay: 1,
            },
            ranges: {
                'Today': [moment(), moment().add(1, 'days')],
                'Yesterday': [moment().subtract(1, 'days'), moment()],
                'Last 7 Days': [moment().subtract(6, 'days'), moment()],
                'Last 30 Days': [moment().subtract(29, 'days'), moment()],
                'This Month': [moment().startOf('month'), moment().endOf('month')],
                'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')],
                'This Year': [moment().startOf('year'), moment().endOf('year')],
                'Last Year': [moment().subtract(1, 'year').startOf('year'), moment().subtract(1, 'year').endOf('year')],
                'All time': [moment().subtract(30, 'year').startOf('month'), moment().endOf('month')],
            }
        });
        // })
    </script>
@endsection

