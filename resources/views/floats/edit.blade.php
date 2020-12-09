@extends('layouts.app')

@section('content')
    <section class="content-header">
        <h1>
            Float
        </h1>
   </section>
   <div class="content">
       @include('adminlte-templates::common.errors')
       <div class="box box-primary">
           <div class="box-body">
               <div class="row">
                   {!! Form::model($float, ['route' => ['floats.update', $float->id], 'method' => 'patch']) !!}

                        @include('floats.fields')

                   {!! Form::close() !!}
               </div>
           </div>
       </div>
   </div>
@endsection