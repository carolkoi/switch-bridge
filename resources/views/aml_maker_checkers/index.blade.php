@extends('layouts.app')

@section('content')
    <section class="content-header">
        <h1 class="pull-left">Aml Maker Checkers</h1>
{{--        <h1 class="pull-right">--}}
        @if(Auth::check() && auth()->user()->can('Can Add / Import Blacklist Records'))
            <div class='btn-group pull-right'>
           <a class="btn btn-primary" style="margin-top: -10px;margin-bottom: 5px" href="{!! route('aml-listing.create') !!}">Add New Blacklist Record</a>
                <a class="btn btn-warning" style="margin-top: -10px;margin-bottom: 5px" href="{!! route('source.import') !!}">Import Excel/CSV</a>

            </div>
        @endif
{{--        </h1>--}}
    </section>
    <div class="content">
        <div class="clearfix"></div>

        @include('flash::message')

        <div class="clearfix"></div>
        <div class="box box-primary">
            <div class="box-body">
                    @include('aml_maker_checkers.table')
            </div>
        </div>
        <div class="text-center">

        </div>
    </div>
@endsection
@section('js')
    <script>
        jQuery(document).ready(function () {


        })
    </script>
    @endsection

