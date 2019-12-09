@extends('wizpack::layouts.default')
@section('content')
    <p>Hello</p>
    <p>
        {{auth()->user()->name}} has submitted an approval request for <b>{{$workflow['name']}}</b>. Please review the request using
        this link <a href="{{env('APP_URL').'/'.$url}}" >View</a>
    </p>

    <p>
        Best Regards,
    </p>
@endsection
