@extends('layouts.app')

@section('content')
    <section class="content-header">
        <h1>
            Session Txn
        </h1>
    </section>
    <div class="content">
        <div class="box box-primary">
            <div class="box-body">
                <div class="row" style="padding-left: 20px">
                    @include('session_txns.show_fields')
                    <a href="{{ route('sessionTxns.index') }}" class="btn btn-default">Back</a>
                </div>
            </div>
        </div>
    </div>
@endsection
