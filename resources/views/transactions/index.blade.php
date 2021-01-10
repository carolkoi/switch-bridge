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
                        {{--                        <div class="col-md-4">--}}
                        {{--                            <form method="POST" id="filter-form-a" action="">--}}
                        {{--                                <div class="form-group ">--}}
                        {{--                                    <select name="filter-parameter" id="filter-parameter-id"--}}
                        {{--                                            class="form-control select2" multiple>--}}
                        {{--                                        <option>SELECT FILTER PARAMETER</option>--}}
                        {{--                                        <option value="PARTNER" data-relation-id="filter-partner-id">PARTNER</option>--}}
                        {{--                                        <option value="TXN_TYPE" data-relation-id="txn_type_id">TRANSACTION TYPE--}}
                        {{--                                        </option>--}}
                        {{--                                        <option value="DATE" data-relation-id="date_filter_id">DATE</option>--}}
                        {{--                                    </select>--}}
                        {{--                                </div>--}}
                        {{--                            </form>--}}
                        {{--                        </div>--}}
                        {{--                        <div class="col-md-12">--}}

                        {{--                            <form action="" id="filtersForm">--}}
                        <div class="">
                            <div class="col-md-3">
                                {{--                                        <label>SELECT PARTNER</label>--}}
                                <div class="form-group" id="filter-partner-id" style="">
                                    @if(Auth::check() && Auth::user()->company_id == 9)
                                        <select name="filter-partner" class="form-control param select2"
                                                id="filter-partner">
                                            <option>SELECT PARTNER</option>
                                            @foreach($upesi_partners as $partner)
                                                <option
                                                    value="{{$partner->partner_name}}">{{$partner->partner_name}}
                                                </option>
                                            @endforeach
                                        </select>

                                    @elseif(Auth::check() && Auth::user()->company_id == 10)
                                        <select name="filter-partner" class="form-control param select2"
                                                id="filter-partner">
                                            <option disabled>SELECT PARTNER</option>
                                            <option
                                                value="CHIPPERCASH">CHIPPERCASH</option>
                                        </select>

                                    @elseif(Auth::check() && Auth::user()->company_id == 11)
                                        <select name="partner" class="form-control param select2"
                                                id="filter-partner">
                                            <option disabled>SELECT PARTNER</option>

                                            <option
                                                value="NGAO">NGAO</option>
                                        </select>

                                    @else
                                        <select name="req_field123" class="form-control param select2"
                                                id="filter-partner">
                                            {{--                                                <option>SELECT PARTNER</option>--}}
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
                                {{--                                        <label>SELECT TRANSACTION TYPE</label>--}}

                                <div class="form-group" id="txn_type_id" style="">
                                    <select name="req_field41" id="txn_type" class="form-control param select2">
                                        <option value="" selected disabled>SELECT TYPE</option>
                                        @foreach($txnTypes as $key => $txnType)
                                            <option value="{{ trim($txnType) }}">{{ trim($txnType) }}</option>
                                        @endforeach
                                    </select>
                                    {{--                                        {{Form::label('', 'Select Partner')}}--}}
                                    {{--                                        {{Form::select('txn-type', $txnTypes, null, ['class' => 'form-control param select2',--}}
                                    {{--                                    'id' => 'txn_type'])}}--}}

                                </div>
                            </div>


                            <form>

                                <div class="col-md-6">
                                    <div class="col-xs-12 form-inline" style="">
                                        <div class="input-daterange input-group" id="datepicker">
                                            <input type="text" class="input-sm form-control" name="from" value="{{\Carbon\Carbon::now()->subDays(7)->format('Y-m-d') }}" />
                                            <span class="input-group-addon">to</span>
                                            <input type="text" class="input-sm form-control" name="to" value="{{ \Carbon\Carbon::now()->addDay(2)->format('Y-m-d') }}"/>
                                        </div>
                                        <button type="button" id="dateSearch" class="btn btn-sm btn-primary">Search</button>
                                    </div>

                                    {{--                                    <div class="input-group date">--}}
{{--                                        <div class="input-group-addon">--}}
{{--                                            <i class="fa fa-calendar"></i>--}}
{{--                                        </div>--}}

{{--                                        <input type="text" name="fromto" class="form-control param" id="date_filter"--}}
{{--                                               autocomplete="off">--}}
{{--                                        --}}{{--                                            {!! Form::text('paid_out_date', null, ['class' => 'form-control', 'autocomplete' => 'off', 'id' => 'paid-out-id']) !!}--}}
{{--                                    </div>--}}
                                    {{--                                            <label>SELECT DATE</label>--}}

{{--                                    <select name="report_time" id="report_time_id" class="form-control param select2">--}}
{{--                                        <option>SELECT REPORTING DATE</option>--}}
{{--                                        <option value="trn_date">TRANSACTION DATE</option>--}}
{{--                                        <option value="paid_date">PAID OUT DATE</option>--}}

{{--                                    </select>--}}
                                </div>
                                <br><br>
                                {{--                                        <input type="text" name="from-to" class="form-control param" id="date_filter" autocomplete="off">--}}
                                {{--                                        {!! Form::label('paid_out_date', 'Paid Out Date:') !!}--}}

{{--                                <span class="">--}}
{{--                                        <div class="btn-group" id="button_filter" style="display: none">--}}
{{--                    <button type="button" name="filter" id="filter-id" class=" btn btn-primary">Filter</button>--}}
{{--                    <button type="button" name="refresh" id="refresh" class="btn btn-default">Refresh</button>--}}
{{--                </div>--}}
{{--                                    <input type="submit" class="btn btn-primary" value="Filter" id="filter-id">--}}
{{--                                </span>--}}
                            </form>

                        </div>
                        {{--                            </div>--}}
                    </div>

                    {{--                    </div>--}}

                </div>
                <br>



                @include('transactions.raw_table')
            </div>
        </div>
        <div class="text-center">

        </div>
    </div>
@endsection

