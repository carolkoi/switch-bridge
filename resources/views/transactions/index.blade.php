@extends('layouts.app')

@section('content')
    <section class="content-header">
        <h1 class="pull-left"> All Transactions</h1>
{{--        <h1 class="pull-right">--}}
{{--           <a class="btn btn-primary pull-right" style="margin-top: -10px;margin-bottom: 5px" href="{!! route('transactions.create') !!}">Add New</a>--}}
{{--        </h1>--}}
    </section>
    <div class="content">
        <div class="clearfix"></div>

        @include('flash::message')

        <div class="clearfix"></div>
        <div class="box box-primary">
            <div class="box-body">

{{--                <div class="form-group">--}}
{{--                    <label>Date range:</label>--}}

{{--                    <div class="input-group">--}}
{{--                        <div class="input-group-addon">--}}
{{--                            <i class="fa fa-calendar"></i>--}}
{{--                        </div>--}}
{{--                        <input type="text" name="range" class="form-control pull-right" id="reservation">--}}

{{--                        <span class="input-group-btn">--}}
{{--                    <button class="btn btn-default" type="button" id="range"><i class="fa fa-search"></i></button>--}}
{{--                             <a href="{{ route('daterange.fetch_data') }}" type="button" id="range" class='btn btn-primary'>--}}
{{--                                     <i class="fa fa-search"></i>--}}
{{--    </a>--}}
{{--                </span>--}}
{{--                    </div>--}}
{{--                </div>--}}
                <div class="row">
                    <div class="col-md-6 pull-right">
                        <form action="" id="filtersForm">
                            <div class="input-group">
                                <input type="text" name="from-to" class="form-control mr-2" id="date_filter">
                                <span class="input-group-btn">
            <input type="submit" class="btn btn-primary" value="Filter">
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
            // $(document).ready(function(){
            //     $('#reservation').daterangepicker();
            // });
            let searchParams = new URLSearchParams(window.location.search)
            let dateInterval = searchParams.get('from-to');
            let start = moment().subtract(29, 'days');
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
                    'Today': [moment(), moment()],
                    'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
                    'Last 7 Days': [moment().subtract(6, 'days'), moment()],
                    'Last 30 Days': [moment().subtract(29, 'days'), moment()],
                    'This Month': [moment().startOf('month'), moment().endOf('month')],
                    'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')],
                    'This Year': [moment().startOf('year'), moment().endOf('year')],
                    'Last Year': [moment().subtract(1, 'year').startOf('year'), moment().subtract(1, 'year').endOf('year')],
                    'All time': [moment().subtract(30, 'year').startOf('month'), moment().endOf('month')],
                }
            });
        });

</script>

@endsection

