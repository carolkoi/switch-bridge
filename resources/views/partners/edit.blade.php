@extends('layouts.app')

@section('content')
    <section class="content-header">
        <h1>
            Partner
        </h1>
   </section>
   <div class="content">
       @include('adminlte-templates::common.errors')
       <div class="box box-primary">
           <div class="box-body">
               <div class="row">
                   {!! Form::model($partner, ['route' => ['partners.update', $partner->id], 'method' => 'patch']) !!}

                        @include('partners.fields')

                   {!! Form::close() !!}
               </div>
           </div>
       </div>
   </div>
@endsection