@extends('wizpack::layouts.default')
@section('content')
    <p>Hello</p>
    <p>
        {{auth()->user()->name}} Your approval request to update a transaction was not successful, kindly use
        this  <a href="{{env('APP_URL').'wizpack/approvals/'.$workflow['id']}}">link</a> to view the request.
    </p>

    <p>
        Best Regards,
    </p>
@endsection
