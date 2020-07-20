@extends('layouts.app')

@section('content')
    <section class="content-header">
        <h1>
            Upload Profile Picture
        </h1>
    </section>
    <div class="content">
        @include('adminlte-templates::common.errors')
        <div class="box box-primary">
            <div class="box-body">
                <div class="row">
                    {!! Form::model($user,['url' => '/upload-profile/'.$user->id, 'method' => 'patch']) !!}

                    @include('users.upload_pic_field')

                    {!! Form::close() !!}
                </div>
            </div>
        </div>
    </div>
@endsection
