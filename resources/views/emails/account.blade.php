@component('mail::message')
# Dear {!! $user['name'] !!}

Welcome to Upesi Money Transfer Limited. Your account has been successfully created.
Use below credentials to login:

@component('mail::table')
    | ------------- |:--------------------:|
    | Username     | {!! $user['name'] !!} |
    | Password     | {!! $password!!}      |
@endcomponent

@component('mail::button', ['url' => url('/')])
Login
@endcomponent

Thanks,<br>
{{ config('app.name') }}
@endcomponent
