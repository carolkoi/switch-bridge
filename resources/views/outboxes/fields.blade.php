<!-- Messageid Field -->
<div class="form-group col-sm-6">
    {!! Form::label('messageid', 'Messageid:') !!}
    {!! Form::number('messageid', null, ['class' => 'form-control']) !!}
</div>

<!-- Messagetypeid Field -->
<div class="form-group col-sm-6">
    {!! Form::label('messagetypeid', 'Messagetypeid:') !!}
    {!! Form::number('messagetypeid', null, ['class' => 'form-control']) !!}
</div>

<!-- Messagestatus Field -->
<div class="form-group col-sm-6">
    {!! Form::label('messagestatus', 'Messagestatus:') !!}
    {!! Form::text('messagestatus', null, ['class' => 'form-control']) !!}
</div>

<!-- Messagepriority Field -->
<div class="form-group col-sm-6">
    {!! Form::label('messagepriority', 'Messagepriority:') !!}
    {!! Form::number('messagepriority', null, ['class' => 'form-control']) !!}
</div>

<!-- Datetimesent Field -->
<div class="form-group col-sm-6">
    {!! Form::label('datetimesent', 'Datetimesent:') !!}
    {!! Form::date('datetimesent', null, ['class' => 'form-control','id'=>'datetimesent']) !!}
</div>

@push('scripts')
    <script type="text/javascript">
        $('#datetimesent').datetimepicker({
            format: 'YYYY-MM-DD HH:mm:ss',
            useCurrent: false
        })
    </script>
@endpush

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

<!-- Attempts Field -->
<div class="form-group col-sm-6">
    {!! Form::label('attempts', 'Attempts:') !!}
    {!! Form::number('attempts', null, ['class' => 'form-control']) !!}
</div>

<!-- Record Version Field -->
<div class="form-group col-sm-6">
    {!! Form::label('record_version', 'Record Version:') !!}
    {!! Form::number('record_version', null, ['class' => 'form-control']) !!}
</div>

<!-- Submit Field -->
<div class="form-group col-sm-12">
    {!! Form::submit('Save', ['class' => 'btn btn-primary']) !!}
    <a href="{{ route('outboxes.index') }}" class="btn btn-default">Cancel</a>
</div>
