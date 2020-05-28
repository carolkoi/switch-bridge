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

                            <div class="input-group">
                                <select name="filter_partner" id="filter_partner" class="form-control mr-2">
                                    @foreach($parners as $partner)
                                        <option disabled>Filter By Partner</option>
                                        <option value="{{$partner->partner_name}}">{{$partner->partner_name}}</option>
                                    @endforeach
                                </select>
{{--                                {{Form::select('filter_partner', $partners, null, ['class' => 'form-control mr-2'])}}--}}

                                <div class="input-group-addon">
                                                        <i class="fa fa-calendar"></i>
                                                    </div>
                                <input type="text" name="from-to" class="form-control mr-2" id="date_filter" autocomplete="off">
                                <span class="input-group-btn">
            <input type="submit" class="btn btn-primary" value="Filter">
{{--                                    <input type="submit" class="btn btn-default" value="Refresh" id="refresh">--}}
        </span>
                            </div>
                        </form>
                    </div>

                </div>
{{--                <div class="row my-2" id="chart">--}}
{{--                    <div class="{{ $chart->options['column_class'] }}">--}}
{{--                        <h3>{!! $chart->options['chart_title'] !!}</h3>--}}
{{--                        {!! $chart->renderHtml() !!}--}}
{{--                    </div>--}}
{{--                </div>--}}
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
        $(document).ready(function() {

            let searchParams = new URLSearchParams(window.location.search);
            let dateInterval = searchParams.get('from-to');
            let start = moment().startOf('month');
            let end = moment();

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
        //
        })
</script>

@endsection

