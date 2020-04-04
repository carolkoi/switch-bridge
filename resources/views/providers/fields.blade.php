<!-- Companyid Field -->
<div class="form-group col-sm-6">
    {!! Form::label('companyid', 'Companyid:') !!}
    {!! Form::number('companyid', null, ['class' => 'form-control']) !!}
</div>

<!-- Moneyservicename Field -->
<div class="form-group col-sm-6">
    {!! Form::label('moneyservicename', 'Moneyservicename:') !!}
    {!! Form::text('moneyservicename', null, ['class' => 'form-control']) !!}
</div>

<!-- Provideridentifier Field -->
<div class="form-group col-sm-6">
    {!! Form::label('provideridentifier', 'Provideridentifier:') !!}
    {!! Form::number('provideridentifier', null, ['class' => 'form-control']) !!}
</div>

<!-- Accountnumber Field -->
<div class="form-group col-sm-6">
    {!! Form::label('accountnumber', 'Accountnumber:') !!}
    {!! Form::text('accountnumber', null, ['class' => 'form-control']) !!}
</div>

<!-- Serviceprovidercategoryid Field -->
<div class="form-group col-sm-6">
    {!! Form::label('serviceprovidercategoryid', 'Serviceprovidercategoryid:') !!}
    {!! Form::number('serviceprovidercategoryid', null, ['class' => 'form-control']) !!}
</div>

<!-- Cutofflimit Field -->
<div class="form-group col-sm-6">
    {!! Form::label('cutofflimit', 'Cutofflimit:') !!}
    {!! Form::number('cutofflimit', null, ['class' => 'form-control']) !!}
</div>

<!-- Settlementaccount Field -->
<div class="form-group col-sm-6">
    {!! Form::label('settlementaccount', 'Settlementaccount:') !!}
    {!! Form::text('settlementaccount', null, ['class' => 'form-control']) !!}
</div>

<!-- B2Cbalance Field -->
<div class="form-group col-sm-6">
    {!! Form::label('b2cbalance', 'B2Cbalance:') !!}
    {!! Form::number('b2cbalance', null, ['class' => 'form-control']) !!}
</div>

<!-- C2Bbalance Field -->
<div class="form-group col-sm-6">
    {!! Form::label('c2bbalance', 'C2Bbalance:') !!}
    {!! Form::number('c2bbalance', null, ['class' => 'form-control']) !!}
</div>

<!-- Processingmode Field -->
<div class="form-group col-sm-6">
    {!! Form::label('processingmode', 'Processingmode:') !!}
    {!! Form::text('processingmode', null, ['class' => 'form-control']) !!}
</div>

<!-- Addedby Field -->
<div class="form-group col-sm-6">
    {!! Form::label('addedby', 'Addedby:') !!}
    {!! Form::number('addedby', null, ['class' => 'form-control']) !!}
</div>

<!-- Serviceprovidertype Field -->
<div class="form-group col-sm-6">
    {!! Form::label('serviceprovidertype', 'Serviceprovidertype:') !!}
    {!! Form::text('serviceprovidertype', null, ['class' => 'form-control']) !!}
</div>

<!-- Status Field -->
<div class="form-group col-sm-6">
    {!! Form::label('status', 'Status:') !!}
    {!! Form::text('status', null, ['class' => 'form-control']) !!}
</div>

<!-- Submit Field -->
<div class="form-group col-sm-12">
    {!! Form::submit('Save', ['class' => 'btn btn-primary']) !!}
    <a href="{!! route('providers.index') !!}" class="btn btn-default">Cancel</a>
</div>
