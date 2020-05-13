@extends('layouts.app')

@section('content')
    <section class="content-header">
        <h1 class="pull-left">Permissions</h1>
        <h1 class="pull-right">
            <a class="btn btn-primary pull-right" style="margin-top: -10px;margin-bottom: 5px" href="{{ route('permissions.create') }}">Add New</a>
        </h1>
    </section>
    <div class="content">
        <div class="clearfix"></div>

        @include('flash::message')

        <div class="clearfix"></div>
        <div class="box box-primary">
            <div class="box-body">
{{--                @include('permissions.table')--}}
                <table class="table table-striped table-hover table-fw-widget table-bordered" id="table1">
                    <thead>
                    <tr>
                        <th>Name</th>
                        <th>Description</th>

                        {{--                                <th>Remarks</th>--}}
                        {{--                                <th>Sync Message </th>--}}
                        {{--                                <th>Sync Message Response </th>--}}
                        {{--                                <th>AML Status</th>--}}
                        {{--                                <th>BO Status</th>--}}


                        {{--                                <th>TrackingNumber</th>--}}
                        {{--                                <th>RequestType</th>--}}
                        {{--                                <th>TransactionTime</th>--}}
                        {{--                                <th>TransactionStatus</th>--}}
                        {{--                                <th>Currency</th>--}}
                        {{--                                <th>Mobile</th>--}}
                        <th style="width:10%;">Actions</th>


                    </tr>
                    </thead>
                    <tbody>

                    @foreach($permissions as $permission)
                        <tr class="odd gradeX">
                            <td>{{ $permission->name  }}</td>
                            <td>{!!  $permission->description!!} </td>

                            <td class="text-right">
{{--                                <div class="btn-group btn-hspace">--}}
{{--                                    <button class="btn btn-secondary dropdown-toggle" type="button" data-toggle="dropdown">Open <span class="icon-dropdown mdi mdi-chevron-down"></span></button>--}}
{{--                                    <div class="dropdown-menu" role="menu"><a class="dropdown-item" href="#">View</a><a class="dropdown-item" href="#">Edit</a><a class="dropdown-item" href="#">Delete</a>--}}
{{--                                        <div class="dropdown-divider"></div><a class="dropdown-item" href="#">Separated link</a>--}}
{{--                                    </div>--}}
{{--                                </div>--}}
                                {!! Form::open(['route' => ['permissions.destroy', $permission->id], 'method' => 'delete']) !!}
                                <div class='btn-group'>
                                    <a href="{{ route('permissions.show', $permission->id) }}" class='btn btn-default btn-sm'>
                                        <i class="glyphicon glyphicon-eye-open"></i>
                                    </a>
                                    <a href="{{ route('permissions.edit', $permission->id) }}" class='btn btn-default btn-sm'>
                                        <i class="glyphicon glyphicon-edit"></i>
                                    </a>
                                    {!! Form::button('<i class="glyphicon glyphicon-trash"></i>', [
                                        'type' => 'submit',
                                        'class' => 'btn btn-danger btn-sm',
                                        'onclick' => "return confirm('Are you sure?')"
                                    ]) !!}
                                </div>
                                {!! Form::close() !!}
                            </td>
                        </tr>
                    @endforeach

                    </tbody>
                </table>

            </div>
        </div>
        <div class="text-center">

        </div>
    </div>
@endsection
