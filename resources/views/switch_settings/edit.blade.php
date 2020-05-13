@extends('layouts.app')

@section('content')
    <section class="content-header">
        <h1>
            Switch Setting
        </h1>
   </section>
   <div class="content">
       @include('adminlte-templates::common.errors')
       <div class="box box-primary">
           <div class="box-body">
               <div class="row">
                   {!! Form::model($switchSetting, ['route' => ['switchSettings.update', $switchSetting->id], 'method' => 'patch']) !!}

                        @include('switch_settings.fields')

                   {!! Form::close() !!}
               </div>
           </div>
       </div>
   </div>
@endsection