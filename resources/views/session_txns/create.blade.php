@extends('layouts.app')

@section('content')
    <section class="content-header">
        <h1>
            Session Txn
        </h1>
    </section>
    <div class="content">
        @include('adminlte-templates::common.errors')
        <div class="box box-primary">
            <div class="box-body">
                <div class="row">
                    {!! Form::open(['route' => 'sessionTxns.store']) !!}

                        @include('session_txns.fields')

                    {!! Form::close() !!}
                </div>
            </div>
        </div>
    </div>
@endsection
