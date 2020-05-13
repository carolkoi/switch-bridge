<!-- Name Field -->
<div class="form-group">
    {!! Form::label('name', 'Name:') !!}
    <p>{{ $role->name }}</p>
</div>

<!-- Guard Name Field -->
<div class="form-group">
    {!! Form::label('guard_name', 'Guard Name:') !!}
    <p>{{ $role->guard_name }}</p>
</div>

<div class="form-group">
    {!! Form::label(' ', 'Permissions /Rights:') !!}
    @foreach($role->getAllPermissions() as $permission)
        <ul>
            <li>  {!! $permission['name'];!!}
            </li>
        </ul>
    @endforeach

</div>
