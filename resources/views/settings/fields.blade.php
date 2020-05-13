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

<!-- Setting Profile Field -->
<div class="form-group col-sm-6">
    {!! Form::label('setting_profile', 'Setting Profile:') !!}
    {!! Form::text('setting_profile', null, ['class' => 'form-control']) !!}
</div>

<!-- Setting Name Field -->
<div class="form-group col-sm-6">
    {!! Form::label('setting_name', 'Setting Name:') !!}
    {!! Form::text('setting_name', null, ['class' => 'form-control']) !!}
</div>

<!-- Setting Value Field -->
<div class="form-group col-sm-6">
    {!! Form::label('setting_value', 'Setting Value:') !!}
    {!! Form::text('setting_value', null, ['class' => 'form-control']) !!}
</div>

<!-- Setting Type Field -->
<div class="form-group col-sm-6">
    {!! Form::label('setting_type', 'Setting Type:') !!}
    {!! Form::text('setting_type', null, ['class' => 'form-control']) !!}
</div>

<!-- Setting Status Field -->
<div class="form-group col-sm-6">
    {!! Form::label('setting_status', 'Setting Status:') !!}
    {!! Form::text('setting_status', null, ['class' => 'form-control']) !!}
</div>

<!-- Record Version Field -->
<div class="form-group col-sm-6">
    {!! Form::label('record_version', 'Record Version:') !!}
    {!! Form::number('record_version', null, ['class' => 'form-control']) !!}
</div>

<!-- Submit Field -->
<div class="form-group col-sm-12">
    {!! Form::submit('Save', ['class' => 'btn btn-primary']) !!}
    <a href="{!! route('settings.index') !!}" class="btn btn-default">Cancel</a>
</div>
