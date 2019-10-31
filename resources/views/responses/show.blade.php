@extends('layouts.app')

@section('content')
    <section class="content-header">
        <h1>
            Responses
        </h1>
    </section>
    <div class="content">
        <div class="box box-primary">
            <div class="box-body">
                <div class="row" style="padding-left: 20px">
                    @include('responses.show_fields')
                    <a href="{!! route('responses.index') !!}" class="btn btn-default">Back</a>
                </div>
            </div>
        </div>
    </div>
@endsection
{{--@section('content')--}}
{{--    <div class="container">--}}
{{--        <div class="row justify-content-center">--}}
{{--            <div class="col-md-8">--}}
{{--                <div class="card">--}}
{{--                    <div class="card-header">Responses--}}
{{--                        <a href="{!! route('responses.index') !!}" class="btn btn-default">Back</a>--}}

{{--                        --}}{{--                        <a href="{{ route('export-responses', $id) }}" class="btn btn-success btn-sm pull-right">Export Responses</a>--}}
{{--                    </div>--}}

{{--                </div>--}}
{{--            </div>--}}
{{--        </div>--}}
{{--    </div>--}}
{{--@endsection--}}
