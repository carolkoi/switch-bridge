@extends('layouts.app')

@section('content')
    <section class="content-header">
        <h1 class="pull-left">Options</h1>
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
                            {!! Form::checkbox('automatic_survey_send') !!}
                            &nbsp;&nbsp;

                            {!! Form::label('automatic_survey_send', 'Allow automatic sending of surveys') !!}

                        </div>

                        <div class="form-group">
                            {!! Form::checkbox('receive_late_response') !!}
                            &nbsp;&nbsp;

                            {!! Form::label('receive_late_response', 'Receive responses after valid end date') !!}

                        </div>

                        <!-- Submit Field -->
                        <div class="form-group">
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
            $(document).ready(function(){
                // $('#automatic_survey_send').bootstrapToggle({
                //     on: 'Yes',
                //     off: 'Disabled'
                // });
                $('[name="value"]').change(function() {
                    console.log(this.value)
                })
            });
        });

    </script>


@endsection

