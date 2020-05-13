<!-- Company Id Field -->
<div class="form-group">
    {!! Form::label('company_id', 'Company:') !!}
    <p>{!! \App\Models\Company::where('companyid', $user->company_id)->first()->companyname !!}</p>
</div>

<!-- Role Id Field -->
<div class="form-group">
    {!! Form::label('role_id', 'Role:') !!}
    <p>{!! implode(' ,', $user->getRoleNames()->toArray()) !!}</p>
</div>

<!-- Name Field -->
<div class="form-group">
    {!! Form::label('name', 'Name:') !!}
    <p>{!! $user->name !!}</p>
</div>

<!-- Contact Person Field -->
<div class="form-group">
    {!! Form::label('contact_person', 'Contact Person:') !!}
    <p>{!! $user->contact_person !!}</p>
</div>

<!-- Email Field -->
<div class="form-group">
    {!! Form::label('email', 'Email:') !!}
    <p>{!! $user->email !!}</p>
</div>

<!-- Password Field -->
{{--<div class="form-group">--}}
{{--    {!! Form::label('password', 'Password:') !!}--}}
{{--    <p>{!! $user->password !!}</p>--}}
{{--</div>--}}

<!-- Msisdn Field -->
<div class="form-group">
    {!! Form::label('msisdn', 'Msisdn:') !!}
    <p>{!! $user->msisdn !!}</p>
</div>

<!-- Status Field -->
<div class="form-group">
    {!! Form::label('status', 'Status:') !!}
    <p>{!! $user->status !!}</p>
</div>

{{--<!-- Remember Token Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('remember_token', 'Remember Token:') !!}--}}
{{--    <p>{!! $user->remember_token !!}</p>--}}
{{--</div>--}}

<div class="form-group">
    {!! Form::label('', 'Permissions /Rights:') !!}
    @foreach($user->getPermissionsViaRoles() as $permission)
        <ul>
            <li>  {!! $permission['name'];!!}
            </li>
        </ul>
        @endforeach

</div>
