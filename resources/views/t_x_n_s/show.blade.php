@extends('layouts.app')

@section('content')
    <section class="content-header">
        <h1>
            T X N
        </h1>
    </section>
    <div class="content">
        <div class="box box-primary">
            <div class="box-body">
                <div class="row" style="padding-left: 20px">
                    @include('t_x_n_s.show_fields')
                    <a href="{{ route('tXNS.index') }}" class="btn btn-default">Back</a>
                </div>
            </div>
        </div>
    </div>
@endsection
