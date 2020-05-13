@extends('layouts.app')

@section('content')
    <section class="content-header">
        <h1>
            Paybill
        </h1>
   </section>
   <div class="content">
       @include('adminlte-templates::common.errors')
       <div class="box box-primary">
           <div class="box-body">
               <div class="row">
                   {!! Form::model($paybill, ['route' => ['paybills.update', $paybill->id], 'method' => 'patch']) !!}

                        @include('paybills.fields')

                   {!! Form::close() !!}
               </div>
           </div>
       </div>
   </div>
@endsection