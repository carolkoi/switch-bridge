<!-- Serviceproviderid Field -->
<div class="form-group col-sm-6">
    {!! Form::label('serviceproviderid', 'Serviceproviderid:') !!}
    {!! Form::number('serviceproviderid', null, ['class' => 'form-control']) !!}
</div>

<!-- Product Field -->
<div class="form-group col-sm-6">
    {!! Form::label('product', 'Product:') !!}
    {!! Form::text('product', null, ['class' => 'form-control']) !!}
</div>

<!-- Productcode Field -->
<div class="form-group col-sm-6">
    {!! Form::label('productcode', 'Productcode:') !!}
    {!! Form::text('productcode', null, ['class' => 'form-control']) !!}
</div>

<!-- Description Field -->
<div class="form-group col-sm-6">
    {!! Form::label('description', 'Description:') !!}
    {!! Form::text('description', null, ['class' => 'form-control']) !!}
</div>

<!-- Charges Field -->
<div class="form-group col-sm-6">
    {!! Form::label('charges', 'Charges:') !!}
    {!! Form::number('charges', null, ['class' => 'form-control']) !!}
</div>

<!-- Commission Field -->
<div class="form-group col-sm-6">
    {!! Form::label('commission', 'Commission:') !!}
    {!! Form::number('commission', null, ['class' => 'form-control']) !!}
</div>

<!-- Transactiontype Field -->
<div class="form-group col-sm-6">
    {!! Form::label('transactiontype', 'Transactiontype:') !!}
    {!! Form::text('transactiontype', null, ['class' => 'form-control']) !!}
</div>

<!-- Status Field -->
<div class="form-group col-sm-6">
    {!! Form::label('status', 'Status:') !!}
    {!! Form::text('status', null, ['class' => 'form-control']) !!}
</div>

<!-- Addedby Field -->
<div class="form-group col-sm-6">
    {!! Form::label('addedby', 'Addedby:') !!}
    {!! Form::number('addedby', null, ['class' => 'form-control']) !!}
</div>

<!-- Modifiedby Field -->
<div class="form-group col-sm-6">
    {!! Form::label('modifiedby', 'Modifiedby:') !!}
    {!! Form::number('modifiedby', null, ['class' => 'form-control']) !!}
</div>

<!-- Submit Field -->
<div class="form-group col-sm-12">
    {!! Form::submit('Save', ['class' => 'btn btn-primary']) !!}
    <a href="{{ route('products.index') }}" class="btn btn-default">Cancel</a>
</div>
