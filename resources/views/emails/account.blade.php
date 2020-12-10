@component('mail::message')
# Dear {!! $user['name'] !!}

Welcome to Switchlink Africa Limited. Your account has been successfully created.
Use below credentials to login:

@component('mail::table')
    | Username              | Password             |
    | ----------------------|:--------------------:|
    | {!! $user['email'] !!} |  {!! $password!!}    |
@endcomponent

@component('mail::button', ['url' => url('/')])
Login
@endcomponent

Thanks,<br>
{{ config('app.name') }}
@endcomponent
