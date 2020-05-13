@extends('layouts.app')

@section('content')
    <section class="content-header">
        <h1>
            A M L- Checker
        </h1>
    </section>
    <div class="content">
        <div class="box box-primary">
            <div class="box-body">
                <div class="row" style="padding-left: 20px">
                    @include('a_m_l-_checkers.show_fields')
                    <a href="{!! route('aMLCheckers.index') !!}" class="btn btn-default">Back</a>
                </div>
            </div>
        </div>
    </div>
@endsection
