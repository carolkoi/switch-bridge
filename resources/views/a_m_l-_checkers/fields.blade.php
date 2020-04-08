<!-- Date Time Added Field -->
<div class="form-group col-sm-6">
    {!! Form::label('date_time_added', 'Date Time Added:') !!}
    {!! Form::number('date_time_added', null, ['class' => 'form-control']) !!}
</div>

<!-- Added By Field -->
<div class="form-group col-sm-6">
    {!! Form::label('added_by', 'Added By:') !!}
    {!! Form::number('added_by', null, ['class' => 'form-control']) !!}
</div>

<!-- Date Time Modified Field -->
<div class="form-group col-sm-6">
    {!! Form::label('date_time_modified', 'Date Time Modified:') !!}
    {!! Form::number('date_time_modified', null, ['class' => 'form-control']) !!}
</div>

<!-- Modified By Field -->
<div class="form-group col-sm-6">
    {!! Form::label('modified_by', 'Modified By:') !!}
    {!! Form::number('modified_by', null, ['class' => 'form-control']) !!}
</div>

<!-- Source Ip Field -->
<div class="form-group col-sm-6">
    {!! Form::label('source_ip', 'Source Ip:') !!}
    {!! Form::text('source_ip', null, ['class' => 'form-control']) !!}
</div>

<!-- Latest Ip Field -->
<div class="form-group col-sm-6">
    {!! Form::label('latest_ip', 'Latest Ip:') !!}
    {!! Form::text('latest_ip', null, ['class' => 'form-control']) !!}
</div>

<!-- Partner Id Field -->
<div class="form-group col-sm-6">
    {!! Form::label('partner_id', 'Partner Id:') !!}
    {!! Form::text('partner_id', null, ['class' => 'form-control']) !!}
</div>

<!-- Customer Idnumber Field -->
<div class="form-group col-sm-6">
    {!! Form::label('customer_idnumber', 'Customer Idnumber:') !!}
    {!! Form::text('customer_idnumber', null, ['class' => 'form-control']) !!}
</div>

<!-- Transaction Number Field -->
<div class="form-group col-sm-6">
    {!! Form::label('transaction_number', 'Transaction Number:') !!}
    {!! Form::text('transaction_number', null, ['class' => 'form-control']) !!}
</div>

<!-- Customer Name Field -->
<div class="form-group col-sm-6">
    {!! Form::label('customer_name', 'Customer Name:') !!}
    {!! Form::text('customer_name', null, ['class' => 'form-control']) !!}
</div>

<!-- Mobile Number Field -->
<div class="form-group col-sm-6">
    {!! Form::label('mobile_number', 'Mobile Number:') !!}
    {!! Form::text('mobile_number', null, ['class' => 'form-control']) !!}
</div>

<!-- Blacklist Status Field -->
<div class="form-group col-sm-6">
    {!! Form::label('blacklist_status', 'Blacklist Status:') !!}
    {!! Form::text('blacklist_status', null, ['class' => 'form-control']) !!}
</div>

<!-- Response Field -->
<div class="form-group col-sm-12 col-lg-12">
    {!! Form::label('response', 'Response:') !!}
    {!! Form::textarea('response', null, ['class' => 'form-control']) !!}
</div>

<!-- Blacklist Source Field -->
<div class="form-group col-sm-6">
    {!! Form::label('blacklist_source', 'Blacklist Source:') !!}
    {!! Form::text('blacklist_source', null, ['class' => 'form-control']) !!}
</div>

<!-- Remarks Field -->
<div class="form-group col-sm-6">
    {!! Form::label('remarks', 'Remarks:') !!}
    {!! Form::text('remarks', null, ['class' => 'form-control']) !!}
</div>

<!-- Blacklisted Field -->
<div class="form-group col-sm-6">
    {!! Form::label('blacklisted', 'Blacklisted:') !!}
    <label class="checkbox-inline">
        {!! Form::hidden('blacklisted', 0) !!}
        {!! Form::checkbox('blacklisted', '1', null) !!}
    </label>
</div>


<!-- Blacklist Version Field -->
<div class="form-group col-sm-6">
    {!! Form::label('blacklist_version', 'Blacklist Version:') !!}
    {!! Form::number('blacklist_version', null, ['class' => 'form-control']) !!}
</div>

<!-- Submit Field -->
<div class="form-group col-sm-12">
    {!! Form::submit('Save', ['class' => 'btn btn-primary']) !!}
    <a href="{!! route('aMLCheckers.index') !!}" class="btn btn-default">Cancel</a>
</div>
