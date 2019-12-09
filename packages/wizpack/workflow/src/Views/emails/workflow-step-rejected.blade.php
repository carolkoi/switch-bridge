@extends('wizpack::layouts.default')
@section('content')
    <p>Hello</p>
    <p>
        {{auth()->user()->name}} Your approval request was not successful, kindly use
        this  <a href="{{env('APP_NAME').'wizpack/approvals/'.$workflow['id']}}">link</a> to view the request.
    </p>

    <p>
        Best Regards,
    </p>
@endsection
