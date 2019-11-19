@extends('layouts.app')
@section('content')
    <section class="content-header col-sm-offset-2" >
        <h1>
            Add Survey
        </h1>
    </section>
    <div class="content">
        @include('adminlte-templates::common.errors')
        <div class="row">
            <div class="col-md-8 col-sm-offset-2">
                <div class="box box-primary">

                    <div class="box-body" style="margin-left: 50px; margin-right: 50px">
                        <div class="row">
                            {!! Form::open(['route' => 'templates.store', 'style' => 'width:auto', 'name' => 'my_templates']) !!}

                            @include('templates.fields')

                            {!! Form::close() !!}
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
@endsection

