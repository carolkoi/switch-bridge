@extends('layouts.app')

@section('content')
    <section class="content-header">
        <h1>
            A M L- Checker
        </h1>
   </section>
   <div class="content">
       @include('adminlte-templates::common.errors')
       <div class="box box-primary">
           <div class="box-body">
               <div class="row">
                   {!! Form::model($aMLChecker, ['route' => ['aMLCheckers.update', $aMLChecker->id], 'method' => 'patch']) !!}

                        @include('a_m_l-_checkers.fields')

                   {!! Form::close() !!}
               </div>
           </div>
       </div>
   </div>
@endsection