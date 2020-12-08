@extends('layouts.app')

@section('content')
    <section class="content-header">
        <h1 class="pull-left"> Failed Transactions</h1>
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
                            <form>
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
                                        {{--                                                                            {{Form::label('', 'Select Partner')}}--}}
                                        {{--                                                                            {{Form::select('filter-partner', $partners, null, ['class' => 'form-control param select2',--}}
                                        {{--                                                                        'id' => 'filter-partner'])}}--}}
                                        <select name="filter-partner" class="form-control param select2"
                                                id="filter-partner">
                                            <option>SELECT PARTNER</option>
                                            @foreach($partners as $partner)
                                                <option
                                                    value="{{$partner->partner_name}}">{{$partner->partner_name}}</option>
                                            @endforeach
                                        </select>
                                    </div>

                                    <div class="form-group" id="txn_type_id" style="display: none">
                                        <select name="txn-type" id="txn_type" class="form-control param select2">
                                            <option>SELECT TRANSACTION TYPE</option>
                                            <option value="BANK">BANK</option>
                                            <option value="CASH">CASH</option>
                                            <option value="MOBILE">MOBILE</option>
                                            <option value="PAYOUT">PAYOUT</option>
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
                                            <option value="modified_date">MODIFIED DATE</option>

                                        </select>
                                        <br><br>
                                        <br><br>
                                        <div class="input-group date">
                                            <div class="input-group-addon">
                                                <i class="fa fa-calendar"></i>
                                            </div>
                                            <input type="text" name="from-to" class="form-control param" id="date_filter"
                                                   autocomplete="off">
                                            {{--                                            {!! Form::text('paid_out_date', null, ['class' => 'form-control', 'autocomplete' => 'off', 'id' => 'paid-out-id']) !!}--}}
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

                @include('transactions.failed_table')
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
                // let status = $('#filter-parameter-id option:selected[value=""]').data("relation-id");
                //
                // //Hide sync message field
                // $(".param").attr('disabled', 'disabled').val('');
                // if (status) {
                //     $("#" + status).show();
                // }
                // $(".param").attr("disabled", status.length > 0);
                //
                // if ($("#filter-parameter-id").val() === 'PARTNER') {
                //     $("#filter-partner").removeAttr('disabled');
                // } else {
                //     $("#filter-partner").attr('disabled', 'disabled').val('');
                // }
                // if ($("#filter-parameter-id").val() === 'TXN_TYPE') {
                //     $("#txn_type").removeAttr('disabled');
                // } else {
                //     $("#txn_type").attr('disabled', 'disabled').val('');
                // }
                // if ($("#filter-parameter-id").val() === 'DATE') {
                //     $("#date_filter").removeAttr('disabled');
                // } else {
                //     $("#date_filter").attr('disabled', 'disabled').val('');
                // }
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


            let searchParams = new URLSearchParams(window.location.search);
            let dateInterval = searchParams.get('from-to');
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
        })

    </script>

@endsection

