@extends('layouts.app')

@section('content')
    <section class="content-header">
        <h1>
            Response Reports
        </h1>
   </section>
   <div class="content">
       @include('adminlte-templates::common.errors')
       <div class="box box-primary">
           <div class="box-body">
               <div class="row">
                   {!! Form::model($responseReports, ['route' => ['responseReports.update', $responseReports->id], 'method' => 'patch']) !!}

                        @include('response_reports.fields')

                   {!! Form::close() !!}
               </div>
           </div>
       </div>
   </div>
@endsection