<!-- Companyname Field -->
<div class="form-group">
    {!! Form::label('companyname', 'Company Name:') !!}
    <p>{!! $company->companyname !!}</p>
</div>

<!-- Companyaddress Field -->
<div class="form-group">
    {!! Form::label('companyaddress', 'Company Address:') !!}
    <p>{!! $company->companyaddress !!}</p>
</div>

<!-- Companyemail Field -->
<div class="form-group">
    {!! Form::label('companyemail', 'Company Email:') !!}
    <p>{!! $company->companyemail !!}</p>
</div>

<!-- Contactperson Field -->
<div class="form-group">
    {!! Form::label('contactperson', 'Contact Person:') !!}
    <p>{!! $company->contactperson !!}</p>
</div>

<!-- Companytype Field -->
<div class="form-group">
    {!! Form::label('companytype', 'Company Type:') !!}
    <p>{!! $company->companytype !!}</p>
</div>

<!-- Addedby Field -->
<div class="form-group">
    {!! Form::label('addedby', 'Added by:') !!}
    <p>{!! \App\Models\User::where('id',$company->addedby)->first()->name !!}</p>
</div>

<!-- Ipaddress Field -->
<div class="form-group">
    {!! Form::label('ipaddress', 'Ipaddress:') !!}
    <p>{!! $company->ipaddress !!}</p>
</div>

