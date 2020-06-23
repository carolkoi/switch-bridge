<!-- Messagetypeid Field -->
<div class="form-group col-sm-6">
    {!! Form::label('messagetypeid', 'Messagetypeid:') !!}
    {!! Form::number('messagetypeid', null, ['class' => 'form-control']) !!}
</div>

<!-- Messageoutboxid Field -->
<div class="form-group col-sm-6">
    {!! Form::label('messageoutboxid', 'Messageoutboxid:') !!}
    {!! Form::number('messageoutboxid', null, ['class' => 'form-control']) !!}
</div>

<!-- Mobilenumber Field -->
<div class="form-group col-sm-6">
    {!! Form::label('mobilenumber', 'Mobilenumber:') !!}
    {!! Form::number('mobilenumber', null, ['class' => 'form-control']) !!}
</div>

<!-- Messagelanguage Field -->
<div class="form-group col-sm-6">
    {!! Form::label('messagelanguage', 'Messagelanguage:') !!}
    {!! Form::text('messagelanguage', null, ['class' => 'form-control']) !!}
</div>

<!-- Message Field -->
<div class="form-group col-sm-6">
    {!! Form::label('message', 'Message:') !!}
    {!! Form::text('message', null, ['class' => 'form-control']) !!}
</div>

<!-- Contents Field -->
<div class="form-group col-sm-12 col-lg-12">
    {!! Form::label('contents', 'Contents:') !!}
    {!! Form::textarea('contents', null, ['class' => 'form-control']) !!}
</div>

<!-- Messagestatus Field -->
<div class="form-group col-sm-6">
    {!! Form::label('messagestatus', 'Messagestatus:') !!}
    {!! Form::text('messagestatus', null, ['class' => 'form-control']) !!}
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

<!-- Source Field -->
<div class="form-group col-sm-6">
    {!! Form::label('source', 'Source:') !!}
    {!! Form::text('source', null, ['class' => 'form-control']) !!}
</div>

<!-- Record Version Field -->
<div class="form-group col-sm-6">
    {!! Form::label('record_version', 'Record Version:') !!}
    {!! Form::number('record_version', null, ['class' => 'form-control']) !!}
</div>

<!-- Submit Field -->
<div class="form-group col-sm-12">
    {!! Form::submit('Save', ['class' => 'btn btn-primary']) !!}
    <a href="{{ route('messages.index') }}" class="btn btn-default">Cancel</a>
</div>
