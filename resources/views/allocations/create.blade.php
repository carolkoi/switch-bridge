@extends('layouts.app')
<style>
    .select2-container--default .select2-selection--multiple .select2-selection__choice {
        background-color: #3c8dbc !important;
    }
    .modal {
        display:    none;
        position:   fixed;
        z-index:    1000;
        top:        0;
        left:       0;
        height:     100%;
        width:      100%;
        background: rgba( 255, 255, 255, .8 )
        url('http://i.stack.imgur.com/FhHRx.gif')
        50% 50%
        no-repeat;
    }
    body.loading {
        overflow: hidden;
    }

    body.loading .modal {
        display: block;
    }
</style>

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
    <div class="modal"><!-- Place at bottom of page -->
    <p>Please Wait...</p></div>
@endsection
@section('scripts')
    <script>
        jQuery(document).ready(function () {
            $("#user_id, #client_id, #template_id, #mails, #survey_type_id").select2({
                tags: true,
                tokenSeparators: [',', ' '],
            });
            $('#client_list, #others_email').css({'display': 'none'});
            $('#client').on('click', function () {
                $('#client_list').show();
            });
            $('#others').on('click', function () {
                $('#others_email').show();
            });

            //changing survey types
            let selectedType = $('#survey_type_id :selected').val();
            setDropDownOptions(selectedType);

            $('#survey_type_id').on('change', function () {
                let type = $('#survey_type_id :selected').val();
                setDropDownOptions(type);
            });
        });

        let setDropDownOptions = function (type) {

            $.ajax({
                url: '/survey-type/' + type,
                beforeSend: function() { $('.modal').show(); },
                complete: function() { $('.modal').hide(); },
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
            return false;
        }
    </script>
@endsection
