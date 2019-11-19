@extends('layouts.def')

@section('content')
    <div class="container" style="margin-left: 150px">
        <div class="row">
            <div class="col-md-8 offset-md-2">
                <div class="card">

                    <div class="card-header">
                        <section class="content-header">
                            <h1>
                                {{  $questions->name}}
                            </h1>
                        </section>

                    </div>

                    <div class="card-body">
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
                                <div class="box box-primary">

                                    <div class="box-body" style="margin-left: 50px; margin-right: 50px">
                                        <div class="row">
                                            {!! Form::open(['route' => 'survey.store', 'style' => 'width:100%']) !!}

                                                @include('surveys.fields')

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
    </div>
@endsection
@section('scripts')
    <script>
        jQuery(document).ready(function () {
            $('#dropdown').select2();
        });
    </script>
    @endsection
