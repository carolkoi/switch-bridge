@extends('layouts.app')

@section('content')
    <section class="content-header col-sm-offset-2" >
        <h1>
            Update Transaction
        </h1>
   </section>
   <div class="content">
       @include('adminlte-templates::common.errors')
       <div class="row">
           <div class="col-md-8 col-sm-offset-2">
               <div class="box box-primary">

                   <div class="box-body" style="margin-left: 50px; margin-right: 50px">
                       <div class="row">
                   {!! Form::model($transactions, ['route' => ['transactions.update', $transactions->iso_id], 'method' => 'patch', 'style' => 'width:auto']) !!}

                        @include('transactions.fields')

                   {!! Form::close() !!}
               </div>
           </div>
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
