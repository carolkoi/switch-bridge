@extends('layouts.app')

@section('content')
    <section class="content-header">
        <h1>
            Workflow Stage Check List
        </h1>
   </section>
   <div class="content">
       @include('adminlte-templates::common.errors')
       <div class="box box-primary">
           <div class="box-body">
               <div class="row">
                   {!! Form::model($workflowStageCheckList, ['route' => ['wizpack::workflowStageCheckLists.update', $workflowStageCheckList->id], 'method' => 'patch']) !!}

                        @include('wizpack::workflow_stage_check_lists.fields')

                   {!! Form::close() !!}
               </div>
           </div>
       </div>
   </div>
@endsection