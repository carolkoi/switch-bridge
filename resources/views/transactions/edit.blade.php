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
                   {!! Form::model($transactions, ['route' => ['transactions.update', $transactions->iso_id], 'method' => 'patch']) !!}

                        @include('transactions.fields')

                   {!! Form::close() !!}
               </div>
           </div>
       </div>
   </div>
@endsection
@section('js')
    <script>
        jQuery(document).ready(function () {
            let selectedStatus = $('#txn-status-id:selected').val();
            // alert(selectedStatus)
            $("#txn-status-id").change(function () {
                let status = $('#txn-status-id:selected').val();
                // alert(status)
                $.each(this.options, function (i, item) {
                    // alert(item.selected)
                    if (item.selected) {
                        $(item).prop("disabled", true);
                    } else {
                        $(item).prop("disabled", false);
                    }
                });
            });
        });
    </script>
    @endsection
