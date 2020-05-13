@extends('wizpack::layouts.default')
@section('content')
    <p>Hello</p>
    <p>
        {{auth()->user()->name}} has submitted a <b>{{$workflow['name']}}</b> request. Please review the request using
        this link <a href="{{env('APP_URL').'/'.$previewUrl}}" >View</a>
    </p>

    <p>
        Best Regards,
    </p>
@endsection
