@extends('layouts.app')

@section('content')
    <section class="content-header">
        <h1>
            Transactions
        </h1>
    </section>
    <div class="content">
        @include('adminlte-templates::common.errors')
        <div class="box box-primary">
            <div class="box-body">
                <div class="row">
                    {!! Form::open(['route' => 'transactions.store']) !!}

                        @include('transactions.fields')

                    {!! Form::close() !!}
                </div>
            </div>
        </div>
    </div>
@endsection
@section('scripts')
<script>
alert('here')
    CKEDITOR.replace('editor')

</script>
@endsection
