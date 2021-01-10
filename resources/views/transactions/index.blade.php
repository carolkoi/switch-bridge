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
                <form id="date-form">
                    <div class="row">
                        <div class="col-md-12">

                            {{--            <form id="date-form">--}}
{{--                            <div class="col-md-4">--}}
{{--                                --}}{{--                    <label>SELECT DATE</label>--}}

{{--                                <select name="reportdate" id="report_time_id" class="form-control param select2">--}}
{{--                                    <option disabled>SELECT REPORTING DATE</option>--}}
{{--                                    <option value="trn-date">TRANSACTION DATE</option>--}}
{{--                                    <option value="paid-date">PAID OUT DATE</option>--}}

{{--                                </select>--}}
{{--                            </div>--}}
{{--                            <div class="col-md-6" style="" id="date_range">--}}
{{--                                <div class="input-group date">--}}
{{--                                    <div class="input-group-addon">--}}
{{--                                        <i class="fa fa-calendar"></i>--}}
{{--                                    </div>--}}

{{--                                    <input type="text" name="fromto" class="form-control param" id="date_filter"--}}
{{--                                           autocomplete="off">--}}
{{--                                </div>--}}

{{--                            </div>--}}

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
                                <div class="col-md-3" style="" id="date_range">
                                    <div class="input-group date">
                                        <div class="input-group-addon">
                                            <i class="fa fa-calendar"></i>
                                        </div>
                                        <label>Choose Paid date</label>

                                        <input type="text" name="fromto" class="form-control param" id="date_filter"
                                               autocomplete="off">
                                    </div>

                                </div>

                                <div class="col-md-3">
                                                        <label>SELECT PARTNER</label>
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
                                <div class="col-md-3">
                                    <label>SELECT TRANSACTION TYPE</label>

                                    <div class="form-group" id="txn_type_id" style="">
                                        <select name="txn-type" id="txn_type" class="form-control param select2">
                                            <option value="" selected disabled>SELECT TYPE</option>
                                            @foreach($txnTypes as $key => $txnType)
                                                <option value="{{ trim($txnType) }}">{{ trim($txnType) }}</option>
                                            @endforeach
                                        </select>

                                    </div>
                                </div>
{{--                                <span class="pull-right">--}}
{{--                                        <div class="btn-group" id="button_filter" style="display: none">--}}
{{--                                                <button type="button" name="filter" id="filter-id" class=" btn btn-primary">Filter</button>--}}
{{--                                                <button type="button" name="refresh" id="refresh" class="btn btn-default">Refresh</button>--}}
{{--                                        </div>--}}
                                <label></label>
                                                            <input type="submit" class="btn btn-primary" value="Filter" id="filter-id">
{{--                                </span>--}}




                            </div>
                        </div>


                    </div>

                </form>
            </div>
                <br>



                @include('transactions.raw_table')
            </div>
        </div>
        <div class="text-center">

        </div>
    </div>

@endsection
@section('scripts')
    <script>
        $(document).ready(function () {
            // $('#date_range, #button_filter').hide();
            // $('#report_time_id').on('change', function () {
            //     // alert('here')
            //     $('#date_range, #button_filter').show();
            //
            // })
            // $('#filter-id').on('click', function () {
            //    let report = $('#report_time_id').val();
            //     let range = $('#date_filter').val();
            // })

            // $("#date-form").submit(function(e) {
            //     let data = $("#date-form").serialize();
            //     alert(data)
            //     let dateInteval = data.get('fromtto');
            //     alert(dateInteval)
            //     if (dateInterval) {
            //         dateInterval = dateInterval.split('%20');
            //         start = dateInterval[0];
            //         end = dateInterval[2];
            //     }
            //     e.preventDefault();
            // });

            let searchParams = new URLSearchParams(window.location.search);
            //
            // // alert(searchParams);
            let dateInterval = searchParams.get('fromtto');
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

