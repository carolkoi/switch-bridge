@extends('layouts.app')

@section('content')
    <section class="content-header">
        <h1>
            Outbox
        </h1>
   </section>
   <div class="content">
       @include('adminlte-templates::common.errors')
       <div class="box box-primary">
           <div class="box-body">
               <div class="row">
                   {!! Form::model($outbox, ['route' => ['outboxes.update', $outbox->id], 'method' => 'patch']) !!}

                        @include('outboxes.fields')

                   {!! Form::close() !!}
               </div>
           </div>
       </div>
   </div>
@endsection