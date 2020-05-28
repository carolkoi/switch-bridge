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

<!-- Partner Idx Field -->
<div class="form-group col-sm-6">
    {!! Form::label('partner_idx', 'Partner Idx:') !!}
    {!! Form::number('partner_idx', null, ['class' => 'form-control']) !!}
</div>

<!-- Setting Profile Field -->
<div class="form-group col-sm-6">
    {!! Form::label('setting_profile', 'Setting Profile:') !!}
    {!! Form::text('setting_profile', null, ['class' => 'form-control']) !!}
</div>

<!-- Partner Name Field -->
<div class="form-group col-sm-6">
    {!! Form::label('partner_name', 'Partner Name:') !!}
    {!! Form::text('partner_name', null, ['class' => 'form-control']) !!}
</div>

<!-- Partner Type Field -->
<div class="form-group col-sm-6">
    {!! Form::label('partner_type', 'Partner Type:') !!}
    {!! Form::text('partner_type', null, ['class' => 'form-control']) !!}
</div>

<!-- Partner Username Field -->
<div class="form-group col-sm-6">
    {!! Form::label('partner_username', 'Partner Username:') !!}
    {!! Form::text('partner_username', null, ['class' => 'form-control']) !!}
</div>

<!-- Partner Password Field -->
<div class="form-group col-sm-6">
    {!! Form::label('partner_password', 'Partner Password:') !!}
    {!! Form::text('partner_password', null, ['class' => 'form-control']) !!}
</div>

<!-- Partner Api Endpoint Field -->
<div class="form-group col-sm-6">
    {!! Form::label('partner_api_endpoint', 'Partner Api Endpoint:') !!}
    {!! Form::text('partner_api_endpoint', null, ['class' => 'form-control']) !!}
</div>

<!-- Allowed Transaction Types Field -->
<div class="form-group col-sm-6">
    {!! Form::label('allowed_transaction_types', 'Allowed Transaction Types:') !!}
    {!! Form::text('allowed_transaction_types', null, ['class' => 'form-control']) !!}
</div>

<!-- Unlock Time Field -->
<div class="form-group col-sm-6">
    {!! Form::label('unlock_time', 'Unlock Time:') !!}
    {!! Form::number('unlock_time', null, ['class' => 'form-control']) !!}
</div>

<!-- Lock Status Field -->
<div class="form-group col-sm-6">
    {!! Form::label('lock_status', 'Lock Status:') !!}
    {!! Form::text('lock_status', null, ['class' => 'form-control']) !!}
</div>

<!-- Partner Status Field -->
<div class="form-group col-sm-6">
    {!! Form::label('partner_status', 'Partner Status:') !!}
    {!! Form::text('partner_status', null, ['class' => 'form-control']) !!}
</div>

<!-- Record Version Field -->
<div class="form-group col-sm-6">
    {!! Form::label('record_version', 'Record Version:') !!}
    {!! Form::number('record_version', null, ['class' => 'form-control']) !!}
</div>

<!-- Submit Field -->
<div class="form-group col-sm-12">
    {!! Form::submit('Save', ['class' => 'btn btn-primary']) !!}
    <a href="{{ route('partners.index') }}" class="btn btn-default">Cancel</a>
</div>
