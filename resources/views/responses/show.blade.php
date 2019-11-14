@extends('layouts.app')

@section('content')
    <section class="content-header">
        <h1 class="pull-left">
            Responses for: {{$template->name}} {{$template->type}}</h1>
        <h1 class="pull-right">
            <a  href="{{ route('export-responses', $id) }}" class="btn btn-primary pull-right"> Export Responses</a>
        </h1>
    </section>
    <br/>
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

