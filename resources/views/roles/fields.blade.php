<!-- Rolename Field -->
<div class="form-group col-sm-6">
    {!! Form::label('rolename', 'Rolename:') !!}
    {!! Form::text('rolename', null, ['class' => 'form-control']) !!}
</div>

<!-- Description Field -->
<div class="form-group col-sm-6">
    {!! Form::label('description', 'Description:') !!}
    {!! Form::text('description', null, ['class' => 'form-control']) !!}
</div>

<!-- Roletype Field -->
<div class="form-group col-sm-6">
    {!! Form::label('roletype', 'Roletype:') !!}
    {!! Form::text('roletype', null, ['class' => 'form-control']) !!}
</div>

<!-- Rolestatus Field -->
<div class="form-group col-sm-6">
    {!! Form::label('rolestatus', 'Rolestatus:') !!}
    {!! Form::text('rolestatus', null, ['class' => 'form-control']) !!}
</div>


<!-- Ipaddress Field -->
<div class="form-group col-sm-6">
    {!! Form::label('ipaddress', 'Ipaddress:') !!}
    {!! Form::text('ipaddress', null, ['class' => 'form-control']) !!}
</div>

<!-- Submit Field -->
<div class="form-group col-sm-12">
    {!! Form::submit('Save', ['class' => 'btn btn-primary']) !!}
    <a href="{!! route('roles.index') !!}" class="btn btn-default">Cancel</a>
</div>
