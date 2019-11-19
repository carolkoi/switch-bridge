@extends('layouts.app')

@section('content')
    <section class="content-header">
        <h1>
            Sent Surveys
        </h1>
   </section>
   <div class="content">
       @include('adminlte-templates::common.errors')
       <div class="box box-primary">
           <div class="box-body">
               <div class="row">
                   {!! Form::model($sentSurveys, ['route' => ['sentSurveys.update', $sentSurveys->id], 'method' => 'patch']) !!}

                        @include('sent_surveys.fields')

                   {!! Form::close() !!}
               </div>
           </div>
       </div>
   </div>
@endsection