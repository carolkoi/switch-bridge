@extends('layouts.app')

@section('content')
    <section class="content-header">
        <h1>
            Approvals
        </h1>
   </section>
   <div class="content">
       @include('adminlte-templates::common.errors')
       <div class="box box-primary">
           <div class="box-body">
               <div class="row">
                   {!! Form::model($approvals, ['route' => ['wizpack::approvals.update', $approvals->id], 'method' => 'patch']) !!}

                        @include('wizpack::approvals.fields')

                   {!! Form::close() !!}
               </div>
           </div>
       </div>
   </div>
@endsection