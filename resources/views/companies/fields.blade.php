<!-- Companyname Field -->
<div class="form-group col-sm-6">
    {!! Form::label('companyname', 'Company Name:') !!}
    {!! Form::text('companyname', null, ['class' => 'form-control']) !!}
</div>

<!-- Companyaddress Field -->
<div class="form-group col-sm-6">
    {!! Form::label('companyaddress', 'Company Address:') !!}
    {!! Form::text('companyaddress', null, ['class' => 'form-control']) !!}
</div>

<!-- Companyemail Field -->
<div class="form-group col-sm-6">
    {!! Form::label('companyemail', 'Company Email:') !!}
    {!! Form::text('companyemail', null, ['class' => 'form-control']) !!}
</div>

<!-- Contactperson Field -->
<div class="form-group col-sm-6">
    {!! Form::label('contactperson', 'Contact Person:') !!}
    {!! Form::text('contactperson', null, ['class' => 'form-control']) !!}
</div>

<!-- Companytype Field -->
<div class="form-group col-sm-6">
    {!! Form::label('companytype', 'Company Type:') !!}
    {!! Form::text('companytype', null, ['class' => 'form-control']) !!}
</div>

<!-- Addedby Field -->
{{--<div class="form-group col-sm-6">--}}
{{--    {!! Form::label('addedby', 'Addedby:') !!}--}}
    {!! Form::hidden('addedby', Auth::user()->id,  ['class' => 'form-control']) !!}
{{--</div>--}}

<!-- Ipaddress Field -->
<div class="form-group col-sm-6">
    {!! Form::label('ipaddress', 'Ip Address:') !!}
    {!! Form::text('ipaddress', null, ['class' => 'form-control']) !!}
</div>

<!-- Submit Field -->
<div class="form-group col-sm-12">
    {!! Form::submit('Save', ['class' => 'btn btn-primary']) !!}
    <a href="{!! route('companies.index') !!}" class="btn btn-default">Cancel</a>
</div>
