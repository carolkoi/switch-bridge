@extends('workflow.layouts.default')
@section('content')
    <p>Hello</p>
    <p>
        {{auth()->user()->name}} has submitted an approval request. Please go {{env('APP_NAME')}} and review it using
        this link <a href="{{env('APP_NAME').'approvals/'.$workflow['id']}}">View</a>.
    </p>

    <p>
        Best Regards,
    </p>
@endsection
