@extends('layouts.app')

@section('content')
    <section class="content-header">
        <h1 class="pull-left"> All Transactions</h1>
{{--        <h1 class="pull-right">--}}
{{--           <a class="btn btn-primary pull-right" style="margin-top: -10px;margin-bottom: 5px" href="{!! route('transactions.create') !!}">Add New</a>--}}
{{--        </h1>--}}
    </section>
    <div class="content">
        <div class="clearfix"></div>

        @include('flash::message')

        <div class="clearfix"></div>
        <div class="box box-primary">
            <div class="box-body">
                    @include('transactions.table')
            </div>
        </div>
        <div class="text-center">

        </div>
    </div>
@endsection
@section('js')
{{--    <script>--}}
{{--        // alert('here')--}}
{{--        $('#dataTableBuilder').dataTable()._fnAjaxUpdate();--}}
{{--    </script>--}}
{{--<script>--}}
{{--    let table = $('#dataTableBuilder').DataTable( {--}}
{{--        paging: false,--}}
{{--        searching: false,--}}
{{--        ajax: "data.json"--}}
{{--    } );--}}

{{--    setInterval( function () {--}}
{{--        table.ajax.reload( null, false ); // user paging is not reset on reload--}}
{{--    }, 10000 );--}}
{{--    // $('#dataTableBuilder').DataTable().ajax.reload(null, false);--}}
{{--</script>--}}

@endsection

