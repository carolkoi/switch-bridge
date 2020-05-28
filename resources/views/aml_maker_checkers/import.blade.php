@extends('layouts.app')

@section('content')
    <section class="content-header col-sm-offset-2" >
        <h1>
            Aml Listing Import
        </h1>
    </section>
    <div class="content">
        @include('adminlte-templates::common.errors')
        <div class="row">
            <div class="col-md-8 col-sm-offset-2">
                <div class="box box-primary">

                    <div class="box-body" style="margin-left: 50px; margin-right: 50px">
                        <div class="row">
                    {!! Form::open(['route' => 'aml-listing.store', 'files' => true]) !!}

                    @include('aml_maker_checkers.import_field')

                    {!! Form::close() !!}
                </div>
            </div>
        </div>
    </div>
        </div>
    </div>
@endsection
@section('scripts')
    <script>
       jQuery(document).ready(function () {
           // $('#csv_header_id').prop('disabled', true)

       })
    </script>
@endsection
