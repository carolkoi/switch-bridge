@extends('layouts.app')

@section('content')
    <section class="content-header">
        <h1>
            {{$template->name}}
        </h1>
    </section>
    <div class="content">
        <div class="box box-primary">
            <div class="col-md-12">
                <!-- Custom Tabs -->
                <div class="nav-tabs-custom">
                    <ul class="nav nav-tabs">
                        <li class="active"><a href="#tab_1" data-toggle="tab" aria-expanded="true">Survey Details</a></li>
                        <li class=""><a href="#tab_2" data-toggle="tab" aria-expanded="false">Questions</a></li>
                        <li class="pull-right"><a href="#" class="text-muted"><i class="fa fa-gear"></i></a></li>
                    </ul>
                    <div class="tab-content">
                        <div class="tab-pane active" id="tab_1">
                            @include('templates.show_fields')
                            <a href="{!! route('templates.index') !!}" class="btn btn-default">Back</a>
                        </div>
                        <!-- /.tab-pane -->
                        <div class="tab-pane" id="tab_2" style="padding: 10px; margin: 10px">
                            @if(count($questions) < 1)
                                <div class="alert alert-danger"> No Questions yet</div>
                            @endif
                            @php($count =1)
                            @foreach($questions as $question)
                                <table class="table-bordered" style="padding: 10px; margin: 10px">
                                    <tr>
                                        <div class="row form-group">
                                            {{ $count ++}} . {{$question->question}}

                                        </div>
                                    </tr>
                                </table>
                            @endforeach
                        </div>
                        <!-- /.tab-pane -->
                    </div>
                    <!-- /.tab-content -->
                </div>
                <!-- nav-tabs-custom -->
            </div>
            </div>
        </div>
    </div>
@endsection
