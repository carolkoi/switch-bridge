@extends('layouts.app')

@section('content')
    <section class="content-header">
        <h1>
            Allocation
        </h1>
   </section>
   <div class="content">
       @include('adminlte-templates::common.errors')
       <div class="box box-primary">
           <div class="box-body">
               <div class="row">
                   {!! Form::model($template, ['route' => ['allocations.update', $template->id], 'method' => 'patch']) !!}

                        @include('allocations.editfields')

                   {!! Form::close() !!}
               </div>
           </div>
       </div>
   </div>
@endsection
@section('scripts')
    <script>
        $(document).ready(function () {
            $("#user_id, #client_id, #template_id").select2({
            });

        })

    </script>
@endsection
