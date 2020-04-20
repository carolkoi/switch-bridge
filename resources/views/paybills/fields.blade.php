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

<!-- Paybill Type Field -->
<div class="form-group col-sm-6">
    {!! Form::label('paybill_type', 'Paybill Type:') !!}
    {!! Form::text('paybill_type', null, ['class' => 'form-control']) !!}
</div>

<!-- Api Application Name Field -->
<div class="form-group col-sm-6">
    {!! Form::label('api_application_name', 'Api Application Name:') !!}
    {!! Form::text('api_application_name', null, ['class' => 'form-control']) !!}
</div>

<!-- Api Consumer Key Field -->
<div class="form-group col-sm-6">
    {!! Form::label('api_consumer_key', 'Api Consumer Key:') !!}
    {!! Form::text('api_consumer_key', null, ['class' => 'form-control']) !!}
</div>

<!-- Api Consumer Secret Field -->
<div class="form-group col-sm-6">
    {!! Form::label('api_consumer_secret', 'Api Consumer Secret:') !!}
    {!! Form::text('api_consumer_secret', null, ['class' => 'form-control']) !!}
</div>

<!-- Api Consumer Code Field -->
<div class="form-group col-sm-6">
    {!! Form::label('api_consumer_code', 'Api Consumer Code:') !!}
    {!! Form::text('api_consumer_code', null, ['class' => 'form-control']) !!}
</div>

<!-- Api Endpoint Field -->
<div class="form-group col-sm-6">
    {!! Form::label('api_endpoint', 'Api Endpoint:') !!}
    {!! Form::text('api_endpoint', null, ['class' => 'form-control']) !!}
</div>

<!-- Api Host Field -->
<div class="form-group col-sm-6">
    {!! Form::label('api_host', 'Api Host:') !!}
    {!! Form::text('api_host', null, ['class' => 'form-control']) !!}
</div>

<!-- Shortcode Field -->
<div class="form-group col-sm-6">
    {!! Form::label('shortcode', 'Shortcode:') !!}
    {!! Form::text('shortcode', null, ['class' => 'form-control']) !!}
</div>

<!-- Partnercode Field -->
<div class="form-group col-sm-6">
    {!! Form::label('partnercode', 'Partnercode:') !!}
    {!! Form::text('partnercode', null, ['class' => 'form-control']) !!}
</div>

<!-- Paybill Status Field -->
<div class="form-group col-sm-6">
    {!! Form::label('paybill_status', 'Paybill Status:') !!}
    {!! Form::text('paybill_status', null, ['class' => 'form-control']) !!}
</div>

<!-- Record Version Field -->
<div class="form-group col-sm-6">
    {!! Form::label('record_version', 'Record Version:') !!}
    {!! Form::number('record_version', null, ['class' => 'form-control']) !!}
</div>

<!-- Submit Field -->
<div class="form-group col-sm-12">
    {!! Form::submit('Save', ['class' => 'btn btn-primary']) !!}
    <a href="{{ route('paybills.index') }}" class="btn btn-default">Cancel</a>
</div>
