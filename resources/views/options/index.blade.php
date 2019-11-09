@extends('layouts.app')

@section('content')
    <section class="content-header">
        <h1 class="pull-left">Optional Settings</h1>
        <h1 class="pull-right">
            <a class="btn btn-primary pull-right" style="margin-top: -10px;margin-bottom: 5px"
               href="{!! route('options.create') !!}">Add New</a>
        </h1>
    </section>
    <div class="content">
        <div class="clearfix"></div>

        @include('flash::message')

        <div class="clearfix"></div>
        <div class="box box-primary">
            <div></div>
            <div class="box-body">

                <div class="card">

                    <br/><br/>
                    <div class="card-body">
                        {!! Form::open(['route' => 'options.store']) !!}
                        <div class="form-group">
                            <div class="col-md-6">
                                {!! Form::label('automatic_survey_send', 'Allow automatic sending of surveys') !!}

                            </div>
                            <div class="col-md-4">
                                <input type="checkbox" checked data-toggle="toggle" data-on="YES" data-off="NO"
                                       name="automatic_survey_send" id="automatic_survey_send" data-size="small" value="1">
                            </div>
                        </div>
                        <br/><br/><br/>

                        <div class="form-group">
                            <div class="col-md-6">
                            {!! Form::label('receive_late_response', 'Receive responses after valid end date') !!}
                            </div>
                            <div class="col-md-4">
                                <input type="checkbox" checked data-toggle="toggle" data-on="YES" data-off="NO"
                                       name="receive_late_response" data-size="small" value="1">
                            </div>

                        </div>
                        <br/><br/>

                        <!-- Submit Field -->
                        <div class="form-group col-md-6">
                            {!! Form::submit('Save', ['class' => 'btn btn-primary']) !!}
                        </div>

                        {!! Form::close() !!}
                    </div>
                </div>
            </div>
        </div>
    </div>

@endsection
@section('scripts')
    <script>

        jQuery(document).ready(function () {
            $('input[type=checkbox]').bootstrapToggle();
        });

    </script>


@endsection

