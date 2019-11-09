@extends('layouts.app')

@section('content')
    <!-- Content Header (Page header) -->
    <section class="content-header">
{{--        <h1>--}}
{{--            Blank page--}}
{{--            <small>it all starts here</small>--}}
{{--        </h1>--}}
{{--        <ol class="breadcrumb">--}}
{{--            <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>--}}
{{--            <li><a href="#">Examples</a></li>--}}
{{--            <li class="active">Blank page</li>--}}
{{--        </ol>--}}

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
                        <span class="info-box-icon bg-aqua"><i class="ion ion-ios-gear-outline"></i></span>

                        <div class="info-box-content">
                            <span class="info-box-text">Surveys</span>
                            <span class="info-box-number">4</span>
                        </div>
                        <!-- /.info-box-content -->
                    </div>
                    <!-- /.info-box -->
                </div>
                <div class="col-md-4 col-sm-6 col-xs-12">
                    <div class="info-box">
                        <span class="info-box-icon bg-red"><i class="fa fa-google-plus"></i></span>

                        <div class="info-box-content">
                            <span class="info-box-text">Polls</span>
                            <span class="info-box-number">6</span>
                        </div>
                        <!-- /.info-box-content -->
                    </div>
                    <!-- /.info-box -->
                </div>
                <div class="col-md-4 col-sm-6 col-xs-12">
                    <div class="info-box">
                        <span class="info-box-icon bg-green"><i class="ion ion-ios-cart-outline"></i></span>

                        <div class="info-box-content">
                            <span class="info-box-text">Feedback</span>
                            <span class="info-box-number">2</span>
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
                                <td>Type</td>
                                <th>Name</th>
                                <th>Status</th>
                                <th>Allocations</th>
                                <th>Respondents</th>
                            </tr>
                            </thead>
                            <tbody>
                            <tr>
                                <td>Survey</td>
                                <td>Test Survey</td>
                                <td><span class="label label-success">inactive</span></td>
                                <td>
                                    20
                                </td>
                                <td>18</td>
                            </tr>
                            <tr>
                                <td>Survey</td>
                                <td>Test Survey</td>
                                <td><span class="label label-success">inactive</span></td>
                                <td>
                                    20
                                </td>
                                <td>18</td>
                            </tr>
                            <tr>
                                <td>Poll</td>
                                <td>Test Poll</td>
                                <td><span class="label label-success">active</span></td>
                                <td>
                                    15
                                </td>
                                <td>13</td>
                            </tr>
                            <tr>
                                <td>Survey</td>
                                <td>ICT Survey</td>
                                <td><span class="label label-success">inactive</span></td>
                                <td>
                                    20
                                </td>
                                <td>18</td>
                            </tr>


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
