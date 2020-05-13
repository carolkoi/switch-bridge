@extends('layouts.app')

@section('content')
    <section class="content-header col-sm-offset-2" >
        <h1>
            Workflow Stage Types
        </h1>
   </section>
   <div class="content">
       @include('adminlte-templates::common.errors')
       <div class="row">
           <div class="col-md-8 col-sm-offset-2">
               <div class="box box-primary">

                   <div class="box-body" style="margin-left: 50px; margin-right: 50px">
                       <div class="row">
                   {!! Form::model($workflowStageTypes, ['route' => ['upesi::approval-partners.update', $workflowStageTypes->id], 'method' => 'patch']) !!}

                        @include('wizpack::workflow_stage_types.fields')

                   {!! Form::close() !!}
               </div>
           </div>
       </div>
   </div>
       </div></div>
@endsection
