@extends('layouts.app')

@section('content')
    <section class="content-header">
        <h1>
            Workflow Stages
        </h1>
    </section>
    <div class="content">
        @include('adminlte-templates::common.errors')
        <div class="box box-primary">

            <div class="box-body">
                <div class="row">
                    {!! Form::open(['route' => 'wizpack::workflowStages.store']) !!}

                        @include('wizpack::workflow_stages.fields')

                    {!! Form::close() !!}
                </div>
            </div>
        </div>
    </div>
@endsection
