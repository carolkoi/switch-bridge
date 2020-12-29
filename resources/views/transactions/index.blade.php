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
                        <div class="col-md-4">
                            <form method="POST" id="filter-form-a" action="">
                                <div class="form-group ">
                                    <select name="filter-parameter" id="filter-parameter-id"
                                            class="form-control select2" multiple>
                                        <option>SELECT FILTER PARAMETER</option>
                                        <option value="PARTNER" data-relation-id="filter-partner-id">PARTNER</option>
                                        <option value="TXN_TYPE" data-relation-id="txn_type_id">TRANSACTION TYPE
                                        </option>
                                        <option value="DATE" data-relation-id="date_filter_id">DATE</option>
                                    </select>
                                </div>
                            </form>
                        </div>
                        <div class="col-md-8">

                            <form action="" id="filtersForm">
                                <div class="">

                                    <div class="form-group" id="filter-partner-id" style="display:none">
                                        @if(Auth::check() && Auth::user()->company_id == 9)
                                            <select name="filter-partner" class="form-control param select2"
                                                    id="filter-partner">
                                                <option>SELECT PARTNER</option>
                                                @foreach($partners as $partner)
                                                    <option
                                                        value="{{$partner->partner_name}}">{{$partner->partner_name}}
                                                    </option>
                                                @endforeach
                                            </select>

                                        @elseif(Auth::check() && Auth::user()->company_id == 10)
                                            <select name="filter-partner" class="form-control param select2"
                                                    id="filter-partner">
                                                <option>SELECT PARTNER</option>
                                                                                                @foreach($partners as $partner)
                                                <option
                                                    value="10">CHIPPERCASH</option>
                                                                                                @endforeach
                                            </select>

                                        @elseif(Auth::check() && Auth::user()->company_id == 11)
                                            <select name="filter-partner" class="form-control param select2"
                                                    id="filter-partner">
                                                <option>SELECT PARTNER</option>
                                                                                                @foreach($partners as $partner)
                                                <option
                                                    value="11">NGAO</option>
                                                                                                @endforeach
                                            </select>

                                        @else
                                            <select name="filter-partner" class="form-control param select2"
                                                    id="filter-partner">
                                                <option>SELECT PARTNER</option>
                                                @foreach($partners as $partner)
                                                    <option
                                                        value="{{$partner->partner_name}}">{{$partner->partner_name}}</option>
                                                @endforeach
                                            </select>

                                        @endif
                                    </div>


                                    <div class="form-group" id="txn_type_id" style="display: none">
                                        <select name="txn-type" id="txn_type" class="form-control param select2">
                                            <option value="" selected disabled>Chooser one</option>
                                            @foreach($txnTypes as $key => $txnType)
                                                <option value="{{ trim($txnType) }}">{{ trim($txnType) }}</option>
                                                @endforeach
{{--                                            <option>SELECT TRANSACTION TYPE</option>--}}
{{--                                            <option value="BANK">BANK</option>--}}
{{--                                            <option value="CASH">CASH</option>--}}
{{--                                            <option value="MOBILE">MOBILE</option>--}}
{{--                                            <option value="PAYOUT">PAYOUT</option>--}}
                                        </select>
{{--                                        {{Form::label('', 'Select Partner')}}--}}
{{--                                        {{Form::select('txn-type', $txnTypes, null, ['class' => 'form-control param select2',--}}
{{--                                    'id' => 'txn_type'])}}--}}

                                    </div>
                                    <div class="form-group" id="date_filter_id" style="display: none">

                                        {{--                                        <div class="input-group-addon">--}}
                                        {{--                                            <i class="fa fa-calendar"></i>--}}
                                        {{--                                        </div>--}}
                                        <select name="report_time" id="report_time_id" class="form-control param select2">
                                            {{--                                            <option>SELECT REPORTING DATE</option>--}}
                                            <option value="trn_date">TRANSACTION DATE</option>
                                            <option value="paid_date">PAID OUT DATE</option>

                                        </select>
                                        <br><br>
{{--                                        <input type="text" name="from-to" class="form-control param" id="date_filter" autocomplete="off">--}}
{{--                                        {!! Form::label('paid_out_date', 'Paid Out Date:') !!}--}}
                                        <div class="input-group date">
                                            <div class="input-group-addon">
                                                <i class="fa fa-calendar"></i>
                                            </div>
                                            <input type="text" name="from-to" class="form-control param" id="date_filter"
                                                   autocomplete="off">
{{--                                            {!! Form::text('paid_out_date', null, ['class' => 'form-control', 'autocomplete' => 'off', 'id' => 'paid-out-id']) !!}--}}
                                        </div>
                                    </div>
                                    <span class="pull-right">
                                    <input type="submit" class="btn btn-primary" value="Filter" id="filter-id">
                                </span>
                                </div>
                                {{--                            </div>--}}
                            </form>
                        </div>
                    </div>

                </div>
                <br/>
{{--                <div class="loader"></div>--}}


                @include('transactions.table')
            </div>
        </div>
        <div class="text-center">

        </div>
    </div>
@endsection
@section('js')
    <script>
        $(document).ready(function () {
            $("#filter-parameter-id").change(function () {
                $("#filter-partner-id, #txn_type_id, #date_filter_id").hide();
                $(".param").attr('disabled', 'disabled').val('');
                if ($(this).val()) {
                    for (var i = 0; i < $(this).val().length; i++) {
                        if ($(this).val()[i] == "PARTNER") {
                            $("#filter-partner-id").fadeIn("fast")['show']();
                            $("#filter-partner").removeAttr('disabled');
                        } else if ($(this).val()[i] == "TXN_TYPE") {
                            $("#txn_type_id").fadeIn("fast")['show']();
                            $("#txn_type").removeAttr('disabled')
                        } else if ($(this).val()[i] == "DATE") {
                            $('#filter-id').hide();
                            $("#date_filter_id").fadeIn("fast")['show']();
                            $("#report_time_id").removeAttr('disabled');
                        }
                    }

                }
            }).trigger('change');
            $("#report_time_id").change(function () {
                $('#date_filter').hide();
                // $("#filter-id").attr('disabled', 'disabled').val('');
                $("#date_filter").fadeIn("fast")['show']();
                $("#date_filter").removeAttr('disabled');
            }).trigger('change');
            $('#date_filter').on('click', function () {
                $("#filter-id").fadeIn("fast")['show']();
            })


            // let searchParams = new URLSearchParams(window.location.search);
            // $('#filter-form').on('submit', function(e) {
            //     table.draw();
            //     e.preventDefault();
            // });
            let searchParams = (new URL(location)).searchParams;
            console.log(">>>PARAM>>> "+searchParams);
            // alert(searchParams);
            let dateInterval = searchParams.get('from-to');
            let filterPartner = searchParams.get('filter-partner');
            // alert(filterPartner);
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
        })

    </script>

@endsection

