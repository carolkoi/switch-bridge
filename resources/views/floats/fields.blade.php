<!-- Partnerid Field -->
<div class="form-group col-sm-6">
    {!! Form::label('partnerid', 'Partnerid:') !!}
    {!! Form::number('partnerid', null, ['class' => 'form-control']) !!}
</div>

<!-- Description Field -->
<div class="form-group col-sm-6">
    {!! Form::label('description', 'Description:') !!}
    {!! Form::text('description', null, ['class' => 'form-control']) !!}
</div>

<!-- Transactionnumber Field -->
<div class="form-group col-sm-6">
    {!! Form::label('transactionnumber', 'Transactionnumber:') !!}
    {!! Form::text('transactionnumber', null, ['class' => 'form-control']) !!}
</div>

<!-- Debit Field -->
<div class="form-group col-sm-6">
    {!! Form::label('debit', 'Debit:') !!}
    {!! Form::number('debit', null, ['class' => 'form-control']) !!}
</div>

<!-- Credit Field -->
<div class="form-group col-sm-6">
    {!! Form::label('credit', 'Credit:') !!}
    {!! Form::number('credit', null, ['class' => 'form-control']) !!}
</div>

<!-- Amount Field -->
<div class="form-group col-sm-6">
    {!! Form::label('amount', 'Amount:') !!}
    {!! Form::number('amount', null, ['class' => 'form-control']) !!}
</div>

<!-- Runningbal Field -->
<div class="form-group col-sm-6">
    {!! Form::label('runningbal', 'Runningbal:') !!}
    {!! Form::number('runningbal', null, ['class' => 'form-control']) !!}
</div>

<!-- Datetimeadded Field -->
<div class="form-group col-sm-6">
    {!! Form::label('datetimeadded', 'Datetimeadded:') !!}
    {!! Form::date('datetimeadded', null, ['class' => 'form-control','id'=>'datetimeadded']) !!}
</div>

@push('scripts')
    <script type="text/javascript">
        $('#datetimeadded').datetimepicker({
            format: 'YYYY-MM-DD HH:mm:ss',
            useCurrent: false
        })
    </script>
@endpush

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
    <a href="{{ route('floats.index') }}" class="btn btn-default">Cancel</a>
</div>
