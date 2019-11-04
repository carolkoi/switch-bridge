@extends('layouts.app')

@section('content')
    <section class="content-header">
        <h1>
            {{$template->name}}
        </h1>
    </section>
    <div class="content">
        <div class="box box-primary">
            <div class="col-md-6">
                @include('templates.show_fields')
                <a href="{!! route('templates.index') !!}" class="btn btn-default">Back</a>
            </div>
            <div class="col-md-6">
                <section class="content-header">
                    <h3>
                        Questions
                    </h3>
                </section>
                <div class="card-body">
                    @if(count($questions) < 1)
                        <div class="alert alert-danger"> No Questions yet</div>
                    @endif
                    @php($count =1)
                    @foreach($questions as $question)
                        <table class="table-bordered">
                            <tr>
                                <div class="row form-group">
                                        {{ $count ++}} . {{$question->question}}

                                </div>
                            </tr>
                        </table>
                    @endforeach
                </div>

            </div>
            <div class="box-body">
                <div class="row" style="padding-left: 20px">

                </div>
            </div>
        </div>
    </div>
@endsection
