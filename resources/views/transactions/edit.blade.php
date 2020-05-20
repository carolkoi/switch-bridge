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
@section('scripts')
    <script>
        jQuery(document).ready(function () {
            $("#res_field48_id_upload_failed").change(function () {
                let status = $("#res_field48_id_upload_failed option:selected").data("relation-id");
                //Hide sync message field
                $("#sync_message_id").hide();
                if (status) {
                    $("#" + status).show();
                }
            });
        });
    </script>
    @endsection
