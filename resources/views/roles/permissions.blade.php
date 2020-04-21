@extends('layouts.app')

@section('content')
    <section class="content-header">
        <h1>
            Permission Assignment Form for the role: <b>{{$role->name}}</b>
        </h1>
    </section>
    <div class="content">
        @include('adminlte-templates::common.errors')
        {{--        <div class="box box-primary">--}}
        {{--            <div class="box-body">--}}
        {{--                <div class="row">--}}
        {{--                    {!! Form::open(['route' => 'reorders.store']) !!}--}}

        {{--                        @include('reorders.fields')--}}

        {{--                    {!! Form::close() !!}--}}
        {{--                </div>--}}
        {{--            </div>--}}
        {{--        </div>--}}
        <permission-component :data={{$role->id}}></permission-component>

    </div>
@endsection
