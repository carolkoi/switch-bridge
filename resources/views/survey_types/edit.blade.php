@extends('layouts.app')

@section('content')
    <section class="content-header">
        <h1>
            Survey Type
        </h1>
   </section>
   <div class="content">
       @include('adminlte-templates::common.errors')
       <div class="box box-primary">
           <div class="box-body">
               <div class="row">
                   {!! Form::model($surveyType, ['route' => ['surveyTypes.update', $surveyType->id], 'method' => 'patch']) !!}

                        @include('survey_types.fields')

                   {!! Form::close() !!}
               </div>
           </div>
       </div>
   </div>
@endsection