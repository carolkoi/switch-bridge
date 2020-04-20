@extends('layouts.app')

@section('content')
    <section class="content-header">
        <h1>
            Comp
        </h1>
    </section>
    <div class="content">
        @include('adminlte-templates::common.errors')
        <div class="box box-primary">
            <div class="box-body">
                <div class="row">
                    {!! Form::open(['route' => 'comps.store']) !!}

                        @include('comps.fields')

                    {!! Form::close() !!}
                </div>
            </div>
        </div>
    </div>
@endsection
