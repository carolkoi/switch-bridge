@extends('layouts.app')

@section('content')
    <section class="content-header">
        <h1>
            Survey Reports
        </h1>
   </section>
   <div class="content">
       @include('adminlte-templates::common.errors')
       <div class="box box-primary">
           <div class="box-body">
               <div class="row">
                   {!! Form::model($surveyReports, ['route' => ['surveyReports.update', $surveyReports->id], 'method' => 'patch']) !!}

                        @include('survey_reports.fields')

                   {!! Form::close() !!}
               </div>
           </div>
       </div>
   </div>
@endsection