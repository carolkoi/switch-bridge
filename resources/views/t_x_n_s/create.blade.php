@extends('layouts.app')

@section('content')
    <section class="content-header">
        <h1>
            T X N
        </h1>
    </section>
    <div class="content">
        @include('adminlte-templates::common.errors')
        <div class="box box-primary">
            <div class="box-body">
                <div class="row">
                    {!! Form::open(['route' => 'tXNS.store']) !!}

                        @include('t_x_n_s.fields')

                    {!! Form::close() !!}
                </div>
            </div>
        </div>
    </div>
@endsection
