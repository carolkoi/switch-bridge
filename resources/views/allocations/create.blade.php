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
                    {!! Form::open(['route' => 'allocations.store', 'name' => 'allocation', 'method'=>'post']) !!}

                    @include('allocations.fields')

                    {!! Form::close() !!}
                </div>
            </div>
        </div>
    </div>
@endsection
@section('scripts')
    <script>
        jQuery(document).ready(function () {
            $("#user_id, #client_id, #template_id").select2();
            $('#client_list').css({'display': 'none'});
            $('#client').on('click', function () {
                $('#client_list').show();
            });

            let selectedType = $('input[type=radio][name=type]:checked').val();
            setDropDownOptions(selectedType);

            $('.survey_type').on('change', function () {
                let type = $('input[type=radio][name=type]:checked').val();

                setDropDownOptions(type);

            });
        });

        let setDropDownOptions = function (type) {

            $.ajax({
                url: '/survey-type/' + type,
                type: 'get',
                dataType: "json",
                success: function (response) {
                    let template_id = $('#template_id');
                    let surveys =  response['data'];

                    template_id.empty();
                    template_id.append(new Option('', '', false, false)).trigger('change');

                    Object.keys(surveys).forEach(function (key)
                    {
                        let newOption = new Option(surveys[key], key, false, false);
                        template_id.append(newOption).trigger('change');
                    });

                },

            });


        }
        //     let rad = document.allocation.type;
        //     for(let i = 0; i < rad.length; i++) {
        //         rad[i].onclick = function () {
        //             if(this !== prev) {
        //                 prev = this;
        //             }
        //             //survey type
        //             let type = this.value;
        //
        //             // Empty the dropdown
        //             $('#template_id').find('option').not(':first').remove();
        //
        //             $.ajax({
        //                 url: '/survey-type/'+ type,
        //                 type: 'get',
        //                 dataType: "json",
        //                 success:function (response) {
        //                     // console.log(response['data']);
        //                     let len = 0;
        //                     if (response['data'] != null) {
        //                         len = response['data'].length;
        //                     }
        //                     if (len > 0) {
        //                         // Read data and create <option >
        //                         for (let i = 0; i < len; i++) {
        //
        //                             let id = response['data'][i].id;
        //                             let name = response['data'][i].name;
        //                             let option = "<option value='" + id + "'>" +name+ "</option>";
        //
        //                             $("#template_id").append(option);
        //                         }
        //                     }
        //                 }
        //             });
        //
        //             //(prev)? console.log(prev.value):null;
        //
        //             console.log(this.value)
        //         };
        //     }
        //
        //
        // });


    </script>
@endsection
