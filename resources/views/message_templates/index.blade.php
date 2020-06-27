@extends('layouts.app')

@section('content')
    <section class="content-header">
        <h1 class="pull-left">Message Templates</h1>
        <h1 class="pull-right">
           <a class="btn btn-primary pull-right" style="margin-top: -10px;margin-bottom: 5px" href="{{ route('messageTemplates.create') }}">Add New</a>
        </h1>
    </section>
    <div class="content">
        <div class="clearfix"></div>

        @include('flash::message')

        <div class="clearfix"></div>
        <div class="box box-primary">
            <div class="box-body">
                    <div class="col-sm-12" style="background-color: white;padding: 0px 10px 20px 10px;">
                        <h4 style="text-align: center"><b>Message Parameter Declaration</b></h4>
                        <hr>
                        <div class="col-sm-6"><p><b>${receiver_amount} </b>replaces the amount received.</p>
                            <p><b>${transaction_date}</b> replaces the transaction date.</p></div>
                        <div class="col-sm-6">
                            <p><b>${partner_name}</b> replaces the partner name.</p>
                            <p><b>${receiver_full_name}</b> replaces the receiver name.</p>
                        </div>
                    </div>
                    <div class="row" style="padding: 20px"></div>
                    @include('message_templates.table')
            </div>
        </div>
        <div class="text-center">

        </div>
    </div>
@endsection

