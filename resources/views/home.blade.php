@extends('layouts.app')

@section('content')
    <!-- Content Header (Page header) -->
    <section class="content-header">


    </section>

    <!-- Main content -->
    <section class="content">

        <!-- Default box -->
        <div class="box">
            <div class="box-header with-border">

                <div class="box-tools pull-right">
                    <button type="button" class="btn btn-box-tool" data-widget="collapse" data-toggle="tooltip" title=""
                            data-original-title="Collapse">
                        <i class="fa fa-minus"></i></button>
                    <button type="button" class="btn btn-box-tool" data-widget="remove" data-toggle="tooltip" title=""
                            data-original-title="Remove">
                        <i class="fa fa-times"></i></button>
                </div>
            </div>
            <div class="box-body">
                <div class="col-md-4 col-sm-6 col-xs-12">
                    <div class="info-box">
                        <span class="info-box-icon bg-aqua"><i class="fa fa-file"></i></span>

                        <div class="info-box-content">
                            <span class="info-box-text">Surveys</span>
                            <span class="info-box-number">{{$templates->where('type', 'Survey')->count()}}</span>
                        </div>
                        <!-- /.info-box-content -->
                    </div>
                    <!-- /.info-box -->
                </div>
                <div class="col-md-4 col-sm-6 col-xs-12">
                    <div class="info-box">
                        <span class="info-box-icon bg-red"><i class="fa fa-file-text"></i></span>

                        <div class="info-box-content">
                            <span class="info-box-text">Polls</span>
                            <span class="info-box-number">{{$templates->where('type', 'Poll')->count()}}</span>
                        </div>
                        <!-- /.info-box-content -->
                    </div>
                    <!-- /.info-box -->
                </div>
                <div class="col-md-4 col-sm-6 col-xs-12">
                    <div class="info-box">
                        <span class="info-box-icon bg-green"><i class="fa fa-file-text"></i></span>

                        <div class="info-box-content">
                            <span class="info-box-text">Feedback</span>
                            <span class="info-box-number">{{$templates->where('type', 'Feedback')->count()}}</span>
                        </div>
                        <!-- /.info-box-content -->
                    </div>
                    <!-- /.info-box -->
                </div>
{{--                    <span class="info-box-icon bg-yellow"><i class="ion ion-ios-people-outline"></i></span>--}}

{{--                    <div class="info-box-content">--}}
{{--                        <span class="info-box-text">New Members</span>--}}
{{--                        <span class="info-box-number">2,000</span>--}}
{{--                    </div>--}}
                    <!-- /.info-box-content -->
            </div>

            <!-- /.box-body -->
            <div class="box-footer">
                <div class="box-header with-border">
                    <h3 class="box-title">Templates</h3>

                    <div class="box-tools pull-right">
                        <button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i>
                        </button>
                        <button type="button" class="btn btn-box-tool" data-widget="remove"><i class="fa fa-times"></i></button>
                    </div>
                </div>
                <div class="box-body">
                    <div class="table-responsive">
                        <table class="table no-margin">
                            <thead>
                            <tr>
                                <th>Type</th>
                                <th>Name</th>
                                <th>Allocations</th>
{{--                                <th>Respondents</th>--}}
{{--                                <th>%age responses</th>--}}
                            </tr>
                            </thead>
                            <tbody>

                            @foreach($templates as $template)
                                <tr>
                                    <td>{{$template->type}}</td>
                                    <td>{{$template->name}}</td>
                                    <td>{{$template->allocations->count()}}</td>
{{--                                    <td>--}}
{{--                                    {{$responses->where('template_id', $template->id)->groupBy('template_id')->count()}}<td>--}}
{{--                                        <td>--}}
{{--                                        {{$template->allocations->count() == 0 ? 0 : ($responses->where('template_id', $template->id)->groupBy('$template_id')->count() / $template->allocations->count())*100}}--}}
{{--                                    </td>--}}
                                </tr>

                            @endforeach


                            </tbody>
                        </table>
                    </div>
                    <!-- /.table-responsive -->
                </div>
            </div>
            <!-- /.box-footer-->
        </div>
        <!-- /.box -->
    </section>
@endsection
