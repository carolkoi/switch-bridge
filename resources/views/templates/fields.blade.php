<!-- Type Field -->
<div class="form-group">
    {!! Form::label('type', 'Type') !!}

    <br>

    {!! Form::radio('type', 'survey' , true) !!}
    {!! Form::label('survey', 'Survey') !!}

    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    {!! Form::radio('type', 'poll' , false) !!}
    {!! Form::label('poll', 'Poll') !!}

    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    {!! Form::radio('type', 'feedback' , false) !!}
    {!! Form::label('feedback', 'Feedback') !!}


</div>

<!-- Name Field -->
<div class="form-group">
    {!! Form::label('name', 'Title:') !!}
    {!! Form::text('name', null, ['class' => 'form-control']) !!}
</div>

<!-- Description Field -->
{{--<div class="form-group">--}}
{{--    {!! Form::label('description', 'Description:') !!}--}}
{{--    {!! Form::text('description', null, ['class' => 'form-control']) !!}--}}
{{--</div>--}}
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

@section('scripts')
    <script type="text/javascript">
        $('#valid_from, #valid_until').datetimepicker({
            format: 'YYYY-MM-DD',
            useCurrent: false
        })
    </script>
@endsection

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
    {!! Form::label('email_msg', 'Email Msg:') !!}
    {!! Form::textarea('email_msg', null, ['class' => 'form-control email_msg', 'id' => 'email_msg', 'required' => 'required']) !!}
</div>


<!-- Submit Field -->
<div class="form-group">
    {!! Form::submit('Save', ['class' => 'btn btn-primary']) !!}
    <a href="{!! route('templates.index') !!}" class="btn btn-default">Cancel</a>
</div>
