@extends('layouts.app')

@section('content')
    <section class="content-header">
        <h1>
            Float
        </h1>
    </section>
    <div class="content">
        @include('adminlte-templates::common.errors')
        <div class="box box-primary">
            <div class="box-body">
                <div class="row">
                    {!! Form::open(['route' => 'floats.store']) !!}

                        @include('floats.fields')

                    {!! Form::close() !!}
                </div>
            </div>
        </div>
    </div>
@endsection
