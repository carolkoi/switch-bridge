
<!-- SurveyType Id Field -->
@if(isset($template))
<div class="form-group">
    {!! Form::label('survey_type_id', 'Type:') !!}
    <select class="form-control select2" name="survey_type_id" id="select2">
        @foreach($survey_types as $survey_type)
            <option value="{{$survey_type->id}}"{{$template->survey_type_id ==$survey_type->id ? 'selected="selected"' : ''}}>{{$survey_type->type}}</option>
        @endforeach
    </select>
</div>
@else
    <div class="form-group">
        {!! Form::label('survey_type_id', 'Type:') !!}
        <select class="form-control select2" name="survey_type_id" id="survey_type_id">
            @foreach($survey_types as $survey_type)
                <option value="{{$survey_type->id}}">{{$survey_type->type}}</option>
            @endforeach
        </select>
    </div>
    @endif

<!-- Name Field -->
<div class="form-group">
    {!! Form::label('name', 'Title:') !!}
    {!! Form::text('name', null, ['class' => 'form-control']) !!}
</div>

<!-- Description Field -->
<div class="form-group">
    {!! Form::label('description', 'Description:') !!}
    {!! Form::textarea('description', null, ['class' => 'form-control', 'rows' => 2, 'required' => 'required']) !!}
</div>

<!-- Valid From Field -->
@if(isset($template))
<div class="form-group">
    {!! Form::label('valid_from', 'Valid From:') !!}
    <div class="input-group date">
        <div class="input-group-addon">
            <i class="fa fa-calendar"></i>
        </div>
    {!! Form::text('valid_from', $template->valid_from, ['class' => 'form-control','id'=>'valid_from', 'autocomplete' => 'off']) !!}
    </div></div>
@else
    <div class="form-group">
        {!! Form::label('valid_from', 'Valid From:') !!}
        <div class="input-group date">
            <div class="input-group-addon">
                <i class="fa fa-calendar"></i>
            </div>
        {!! Form::text('valid_from',null , ['class' => 'form-control','id'=>'valid_from', 'autocomplete' => 'off']) !!}
        </div>
    </div>
    @endif

{{--@section('js')--}}
{{--    <script type="text/javascript">--}}
{{--        $('#survey_type_id').select2();--}}
{{--        $('#email_msg').summernote();--}}
{{--        $('#valid_from, #valid_until').datetimepicker({--}}
{{--            format: 'YYYY-MM-DD',--}}
{{--            useCurrent: false--}}
{{--        })--}}
{{--    </script>--}}
{{--@endsection--}}


<!-- Valid Until Field -->
@if(isset($template))
<div class="form-group">
    {!! Form::label('valid_until', 'Valid Until:') !!}
    <div class="input-group date">
        <div class="input-group-addon">
            <i class="fa fa-calendar"></i>
        </div>
    {!! Form::text('valid_until', $template->valid_until, ['class' => 'form-control', 'id'=>'valid_until', 'autocomplete' => 'off']) !!}
    </div></div>
@else
    <div class="form-group">
        {!! Form::label('valid_until', 'Valid Until:') !!}
        <div class="input-group date">
            <div class="input-group-addon">
                <i class="fa fa-calendar"></i>
            </div>
        {!! Form::text('valid_until',null , ['class' => 'form-control valid_until','id'=>'valid_until', 'autocomplete' => 'off']) !!}
    </div></div>
    @endif

<!-- Email Msg Field -->
<div class="form-group">
    {!! Form::label('email_msg', 'Email Message:') !!}
    {!! Form::textarea('email_msg', null, ['id' => 'editor1', 'required' => 'required', 'class' => 'textarea']) !!}
</div>

<!-- Submit Field -->
<div class="form-group">
    {!! Form::submit('Save', ['class' => 'btn btn-primary']) !!}
    <a href="{!! route('templates.index') !!}" class="btn btn-default">Cancel</a>
</div>

@section('js')

    <script>
        CKEDITOR.replace('editor1')
        $('#valid_from, #valid_until').datetimepicker({
            format: 'YYYY-MM-DD',
            useCurrent: false
        })
    </script>
    @endsection
