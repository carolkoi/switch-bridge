@extends('layouts.app')

@section('content')
    <section class="content-header">
        <h1>
            Message Template
        </h1>
    </section>
    <div class="content">
        @include('adminlte-templates::common.errors')
        <div class="box box-primary">
            <div class="box-body">
                <div class="col-sm-12" style="background-color: white;padding: 0px 10px 20px 10px;">
                    <h4 style="text-align: center"><b>Message Parameter Declaration</b></h4>
                    <hr>
                    <div class="col-sm-6"><p><b>${receiver_amount} </b>replaces the amount received.</p>
                        <p><b>${transaction_date}</b> replaces the transaction date.</p></div>
                    <div class="col-sm-6"><p><b>${partner_name}</b> replaces the partner name.</p>
                        <p><b>${receiver_full_name}</b> replaces the receiver name.</p></div>
                </div>
                <br/>
                <br/>
                <div class="row">
                    {!! Form::open(['route' => 'messageTemplates.store']) !!}

                        @include('message_templates.fields')

                    {!! Form::close() !!}
                </div>
            </div>
        </div>
    </div>
@endsection
@section('scripts')
    <script>
        jQuery(document).ready(function () {
            CKEDITOR.replace('editor1')
        })
    </script>
@endsection
