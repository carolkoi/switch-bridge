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
                        <form>

                            <div class="form-group col-md-4">
                                <select name="filter-parameter" id="filter-parameter-id" class="form-control select2">
                                    <option>SELECT FILTER PARAMETER</option>
                                    <option value="PARTNER" data-relation-id="filter-partner-id">PARTNER</option>
                                    <option value="TXN_TYPE" data-relation-id="txn_type_id">TRANSACTION TYPE</option>
                                    <option value="DATE" data-relation-id="date_filter_id">DATE</option>
                                </select>
                            </div>
                        </form>

                        <form action="" id="filtersForm">
                            <div class="">
                                <div class="form-group col-md-6" id="filter-partner-id" style="display:none">
                                    {{Form::select('filter-partner', $partners, null, ['class' => 'form-control select2',
                                'id' => 'filter-partner'])}}
                                </div>

                                <div class="form-group col-md-6" id="txn_type_id" style="display: none">
                                    <select name="txn-type" id="txn_type" class="form-control select2">
                                        <option value="BANK">BANK</option>
                                        <option value="CASH">CASH</option>
                                        <option value="MOBILE">MOBILE</option>
                                    </select>
                                </div>
                                <div class="form-group col-md-6" id="date_filter_id" style="display: none">

                                    {{--                                <div class="input-group-addon">--}}
                                    {{--                                    <i class="fa fa-calendar"></i>--}}
                                    {{--                                </div>--}}
                                    <input type="text" name="from-to" class="form-control" id="date_filter"
                                           autocomplete="off">
                                </div>
                                <span class="pull-right">
                                    <input type="submit" class="btn btn-primary" value="Filter">
                                </span>
                            </div>
                            {{--                            </div>--}}
                        </form>
                    </div>

                </div>
                <br/>

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
                let status = $("#filter-parameter-id option:selected").data("relation-id");

                //Hide sync message field
                $("#filter-partner-id, #txn_type_id, #date_filter_id").hide();
                // $("#filter-partner, #txn_type, #date_filter").attr('disabled', 'disabled').val('');
                if (status) {
                    $("#" + status).show();
                }
                if ($("#filter-parameter-id").val() === 'PARTNER') {
                    $("#filter-partner").removeAttr('disabled');
                } else {
                    $("#filter-partner").attr('disabled', 'disabled').val('');
                }
                if ($("#filter-parameter-id").val() === 'TXN_TYPE') {
                    $("#txn_type").removeAttr('disabled');
                } else {
                    $("#txn_type").attr('disabled', 'disabled').val('');
                }
                if ($("#filter-parameter-id").val() === 'DATE') {
                    $("#date_filter").removeAttr('disabled');
                } else {
                    $("#date_filter").attr('disabled', 'disabled').val('');
                }
            }).trigger('change');


            let searchParams = new URLSearchParams(window.location.search);
            let dateInterval = searchParams.get('from-to');
            let filterPartner = searchParams.get('filter-partner');
            let filterTxnType = searchParams.get('txn-type');
            let selectedPartner = null;
            let start = moment().startOf('month');
            let end = moment();
            if (filterPartner) {
                selectedPartner = filterPartner;
            }

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

