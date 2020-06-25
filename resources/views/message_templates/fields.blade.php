
<!-- Messagetype Field -->
<div class="form-group col-sm-6" style="padding-top: 50px">
    {!! Form::label('messagetype', 'Message Type:') !!}
    {!! Form::text('messagetype', null, ['class' => 'form-control']) !!}
</div>

<!-- Messagepriority Field -->
{{--<div class="form-group col-sm-6" style="padding-top: 50px">--}}
{{--    {!! Form::label('messagepriority', 'Message Priority:') !!}--}}
{{--    {!! Form::number('messagepriority', null, ['class' => 'form-control']) !!}--}}
{{--</div>--}}
<div class="form-group col-sm-6" style="padding-top: 50px">
    {!! Form::label('messagepriority', 'Message Priority:') !!}
    {!! Form::select('messagepriority',array('0'=>'0','1'=>'1', '2'=>'2'), null, ['class' => 'form-control select2']) !!}
</div>

<!-- Eng Message Field -->
<div class="form-group col-sm-6">
    {!! Form::label('eng_message', 'English Message:') !!}
    {!! Form::textarea('eng_message', null, ['id' => 'editor1']) !!}
</div>

<!-- Kis Message Field -->
<div class="form-group col-sm-6">
    {!! Form::label('kis_message', 'Kiswahili Message:') !!}
    {!! Form::textarea('kis_message', null, ['id' => 'editor']) !!}
</div>



{{--<!-- Datetimeadded Field -->--}}
{{--<div class="form-group col-sm-6">--}}
{{--    {!! Form::label('datetimeadded', 'Datetimeadded:') !!}--}}
{{--    {!! Form::date('datetimeadded', null, ['class' => 'form-control','id'=>'datetimeadded']) !!}--}}
{{--</div>--}}

{{--@push('scripts')--}}
{{--    <script type="text/javascript">--}}
{{--        $('#datetimeadded').datetimepicker({--}}
{{--            format: 'YYYY-MM-DD HH:mm:ss',--}}
{{--            useCurrent: false--}}
{{--        })--}}
{{--    </script>--}}
{{--@endpush--}}

{{--<!-- Addedby Field -->--}}
{{--<div class="form-group col-sm-6">--}}
{{--    {!! Form::label('addedby', 'Addedby:') !!}--}}
{{--    {!! Form::number('addedby', null, ['class' => 'form-control']) !!}--}}
{{--</div>--}}

<!-- Ipaddress Field -->
{{--<div class="form-group col-sm-6">--}}
{{--    {!! Form::label('ipaddress', 'Ipaddress:') !!}--}}
{{--    {!! Form::text('ipaddress', null, ['class' => 'form-control']) !!}--}}
{{--</div>--}}

<!-- Partnerid Field -->
{{--<div class="form-group col-sm-6">--}}
{{--    {!! Form::label('partnerid', 'Partnerid:') !!}--}}
{{--    {!! Form::number('partnerid', null, ['class' => 'form-control']) !!}--}}
{{--</div>--}}

<!-- Record Version Field -->
{{--<div class="form-group col-sm-6">--}}
{{--    {!! Form::label('record_version', 'Record Version:') !!}--}}
{{--    {!! Form::number('record_version', null, ['class' => 'form-control']) !!}--}}
{{--</div>--}}

<!-- Submit Field -->
<div class="form-group col-sm-12">
    {!! Form::submit('Save', ['class' => 'btn btn-primary']) !!}
    <a href="{{ route('messageTemplates.index') }}" class="btn btn-default">Cancel</a>
</div>
