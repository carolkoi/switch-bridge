@extends('layouts.app')

@section('content')
    <section class="content-header">
        <h1>
            Permission Assignment Form for the role: <b>{{$role->name}}</b>
        </h1>
    </section>
    <div class="content">
        @include('adminlte-templates::common.errors')

        <permission-component :data={{$role->id}}></permission-component>

    </div>
@endsection
