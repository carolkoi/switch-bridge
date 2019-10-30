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
                    {!! Form::open(array('name' => 'allocation'),['route' => 'allocations.store']) !!}

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
            let rad = document.allocation.type;
            let prev = 'survey';
            for(let i = 0; i < rad.length; i++) {
                rad[i].onclick = function () {
                    alert('here')
                    if(this !== prev) {
                        prev = this;
                    }
                    //survey type
                    let type = this.value;

                    // Empty the dropdown
                    $('#template_id').find('option').not(':first').remove();

                    $.ajax({
                        url: '/survey-type/'+ type,
                        type: 'get',
                        dataType: "json",
                        success:function (response) {
                            // console.log(response['data']);
                            let len = 0;
                            if (response['data'] != null) {
                                len = response['data'].length;
                            }
                            if (len > 0) {
                                // Read data and create <option >
                                for (let i = 0; i < len; i++) {

                                    let id = response['data'][i].id;
                                    let name = response['data'][i].name;
                                    let option = "<option value='" + id + "'>" +name+ "</option>";

                                    $("#template_id").append(option);
                                }
                            }
                        }
                    });

                    //(prev)? console.log(prev.value):null;

                    console.log(this.value)
                };
            }


        });


    </script>
    @endsection
