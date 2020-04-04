@extends('layouts.app')

@section('content')
    <section class="content-header">
        <h1>
            Switch Setting
        </h1>
    </section>
    <div class="content">
        @include('adminlte-templates::common.errors')
        <div class="box box-primary">
            <div class="box-body">
                <div class="row">
                    {!! Form::open(['route' => 'switchSettings.store']) !!}

                        @include('switch_settings.fields')

                    {!! Form::close() !!}
                </div>
            </div>
        </div>
    </div>
@endsection
