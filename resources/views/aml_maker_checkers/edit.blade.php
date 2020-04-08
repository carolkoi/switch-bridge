@extends('layouts.app')

@section('content')
    <section class="content-header">
        <h1>
            Aml Maker Checker
        </h1>
   </section>
   <div class="content">
       @include('adminlte-templates::common.errors')
       <div class="box box-primary">
           <div class="box-body">
               <div class="row">
                   {!! Form::model($amlMakerChecker, ['route' => ['amlMakerCheckers.update', $amlMakerChecker->blacklist_id], 'method' => 'patch']) !!}

                        @include('aml_maker_checkers.fields')

                   {!! Form::close() !!}
               </div>
           </div>
       </div>
   </div>
@endsection
