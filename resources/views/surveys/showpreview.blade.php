@extends('layouts.app')

@section('content')
    <div class="container" style="margin-left: 150px">
        <div class="row">
            <div class="col-md-8 offset-md-2">
                <div class="card">

                        <section class="content-header">
                            <h1>
                                {{  $questions->name}} {{$questions->type}}
                                <a  href="{{ url('/questions',$questions->id)}}" class="btn btn-default pull-right"> Back</a>
                            </h1>
                        </section>
<br>
                    <div class="box box-primary">
                        <div class="box-body" style="margin-left: 50px; margin-right: 50px">
                        @if(session('filled'))
                            <div class="alert alert-success">
                                Thank you for participating. We appreciate your time and effort in taking the survey.
                            </div>
                        @else
                            @if(session('passed'))
                                <div class="alert alert-warning">
                                    Survey deadline passed.
                                </div>
                            @endif
                            @if(session('error'))
                                <div class="alert alert-danger">
                                    URL Expired
                                </div>
                            @endif

                            @if(count($questions->questions) == 0)
                                <div class="alert alert-danger"> No Questions yet</div>
                            @endif
                            @php($count =1)
                            <div class="content">
                                @include('adminlte-templates::common.errors')
{{--                                <div class="box box-primary">--}}

{{--                                    <div class="box-body" style="margin-left: 50px; margin-right: 50px">--}}
                                        <div class="row">
                                            {!! Form::open(['style' => 'width:100%', 'id' => 'surveyForm']) !!}

                                            @include('surveys.preview')

                                            {!! Form::close() !!}
                                        </div>
                                    </div>
                                </div>
                            </div>
                        @endif
                    </div>
                    </div>
                </div>
            </div>

@endsection
@section('scripts')
    <script type="text/javascript">
        // $('#dropdown').select2();
        $('#date_id').datetimepicker({
            format: 'YYYY-MM-DD',
            useCurrent: false
        });
        var somethingChanged = false;
        $('.rating-survey').change(function() {
            somethingChanged = true;
            // get all the inputs into an array.
            var $inputs = $('#surveyForm :input.rating');
            // get an associative array of just the values.
            var total = 0;
            $inputs.each(function() {
                if(typeof total == 'number') {
                    total = parseInt($(this).val()) + parseInt(total);
                }
            });
            console.log(total);
            $("#score").html(total);
        });
    </script>
@endsection
