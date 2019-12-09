@extends('wizpack::layouts.default')
@section('content')
    <p>Hello</p>
    @if(!empty($approvalInfo['next_stage']))
        <p>
            <b>{{$workflow['name']}}</b> request submitted by {{$approvalInfo['sentBy']->name}};
            <b>{{$approvalInfo['approved_stage']}}</b> completed. Please review the next stage(
            <b>{{$approvalInfo['next_stage']}} </b>) using
            this link <a href="{{env('APP_NAME').'wizpack/approvals/'.$workflow['id']}}">View</a>.
        </p>
    @else
        <p>
            {{$approvalInfo['sentBy']->name}},
            <b>{{$approvalInfo['approved_stage']}}</b>  completed. Your request is now fully approved
            Please use this <a href="{{env('APP_NAME').'wizpack/approvals/'.$workflow['id']}}">link</a> to view it.
        </p>
    @endif

    <p>
        Best Regards,
    </p>
@endsection
