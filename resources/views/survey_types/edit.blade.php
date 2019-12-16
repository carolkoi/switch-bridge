@extends('layouts.app')

@section('content')
    <section class="content-header">
        <h1>
            Survey Type
        </h1>
   </section>
   <div class="content">
       @include('adminlte-templates::common.errors')
       <div class="box box-primary">
           <div class="box-body">
               <div class="row">
                   {!! Form::model($surveyType, ['route' => ['surveyTypes.update', $surveyType->id], 'method' => 'patch']) !!}

                        @include('survey_types.fields')

                   {!! Form::close() !!}
               </div>
           </div>
       </div>
   </div>
@endsection
@section('scripts')
    <script>
        jQuery(document).ready(function () {
            if($("input[name='status']").is(":checked"))
                $(".addRatingRange").show();
            else
                $(".addRatingRange").hide();

            if($("input[name='status']").is(":checked"))
                $(".save").click(function() {
                    $(this).closest('form').find("input[type=number]").val();
                });
            else
                $(".save").click(function() {
                    $(this).closest('form').find("input[type=number]").val("");
                });

        })

        function valueChanged()
        {
            if($("input[name='status']").is(":checked"))
                $(".addRatingRange").show();
            else
                $(".addRatingRange").hide();

            if($("input[name='status']").is(":checked"))
            $(".save").click(function() {
                $(this).closest('form').find("input[type=number]").val();
            });
            else
            $(".save").click(function() {
                $(this).closest('form').find("input[type=number]").val("");
            });



        }
    </script>
@endsection
