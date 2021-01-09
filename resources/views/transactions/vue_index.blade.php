@extends('layouts.app')

@section('content')
    <section class="content-header">
        <h1>
            Recent Transactions
        </h1>
    </section>
    <div class="content">
        @include('adminlte-templates::common.errors')

{{--        <permission-component :data={{$role->id}}></permission-component>--}}
        <all-transactions-component></all-transactions-component>

    </div>
@endsection
