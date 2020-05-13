@extends('layouts.app')

@section('content')
    <section class="content-header">
        <h1>
            T X N
        </h1>
   </section>
   <div class="content">
       @include('adminlte-templates::common.errors')
       <div class="box box-primary">
           <div class="box-body">
               <div class="row">
                   {!! Form::model($tXN, ['route' => ['tXNS.update', $tXN->id], 'method' => 'patch']) !!}

                        @include('t_x_n_s.fields')

                   {!! Form::close() !!}
               </div>
           </div>
       </div>
   </div>
@endsection