@extends('workflow.layouts.default')
@section('content')
    <p>Hello</p>
    <p>
        {{auth()->user()->name}} has submitted an approval request. Please go {{env('APP_NAME')}} and review it using
        this link {!!  $model->previewLink() !!}.
    </p>

    <p>
        Best Regards,
    </p>
@endsection
