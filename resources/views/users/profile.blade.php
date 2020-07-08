@extends('layouts.app')

@section('content')
    <section class="content-header">
        <h1>
            {{Auth::user()->name}}
        </h1>
    </section>
    <div class="content">
{{--        @include('adminlte-templates::common.errors')--}}
        <div class="box box-primary">
            <div class="box-body">
                <div class="row">
                    {!! Form::model($user, ['route' => ['password.change', $user->id], 'method' => 'patch', 'autocomplete' =>'off']) !!}

                    @include('users.profile_fields')
                    {!! Form::close() !!}

{{--                    <a href="{!! route('users.index') !!}" class="btn btn-default">Back</a>--}}
                </div>
            </div>
        </div>
    </div>
@endsection
@section('scripts')
    <script>
        jQuery(document).ready(function () {
            $('#reset-id').on('click', function () {
                $('#reset-password-wrap').show();
            });
            $("#password_confirmation_id").keyup(checkPasswordMatch);
            $("#submit").on('click', function () {
                var password = $("#password_id").val();
                var confirmPassword = $("#password_confirmation_id").val();

                if (password !== confirmPassword)
                    // $("#confirmMessageId").html("Passwords do not match!").css('color', 'red');
                    alert('Passwords do not match!')

            })

        });
        function checkPasswordMatch() {
            var password = $("#password_id").val();
            var confirmPassword = $("#password_confirmation_id").val();

            if (password != confirmPassword)
                $("#confirmMessageId").html("Passwords do not match!").css('color', 'red');
            else
                $("#confirmMessageId").html("Passwords match.").css('color', 'green');
        }
    </script>
    @endsection

