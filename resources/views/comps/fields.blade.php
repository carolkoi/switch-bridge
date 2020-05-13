<!-- Companyname Field -->
<div class="form-group col-sm-6">
    {!! Form::label('companyname', 'Companyname:') !!}
    {!! Form::text('companyname', null, ['class' => 'form-control']) !!}
</div>

<!-- Companyaddress Field -->
<div class="form-group col-sm-6">
    {!! Form::label('companyaddress', 'Companyaddress:') !!}
    {!! Form::text('companyaddress', null, ['class' => 'form-control']) !!}
</div>

<!-- Companyemail Field -->
<div class="form-group col-sm-6">
    {!! Form::label('companyemail', 'Companyemail:') !!}
    {!! Form::text('companyemail', null, ['class' => 'form-control']) !!}
</div>

<!-- Contactperson Field -->
<div class="form-group col-sm-6">
    {!! Form::label('contactperson', 'Contactperson:') !!}
    {!! Form::text('contactperson', null, ['class' => 'form-control']) !!}
</div>

<!-- Companytype Field -->
<div class="form-group col-sm-6">
    {!! Form::label('companytype', 'Companytype:') !!}
    {!! Form::text('companytype', null, ['class' => 'form-control']) !!}
</div>

<!-- Addedby Field -->
<div class="form-group col-sm-6">
    {!! Form::label('addedby', 'Addedby:') !!}
    {!! Form::number('addedby', null, ['class' => 'form-control']) !!}
</div>

<!-- Ipaddress Field -->
<div class="form-group col-sm-6">
    {!! Form::label('ipaddress', 'Ipaddress:') !!}
    {!! Form::text('ipaddress', null, ['class' => 'form-control']) !!}
</div>

<!-- Submit Field -->
<div class="form-group col-sm-12">
    {!! Form::submit('Save', ['class' => 'btn btn-primary']) !!}
    <a href="{{ route('comps.index') }}" class="btn btn-default">Cancel</a>
</div>
