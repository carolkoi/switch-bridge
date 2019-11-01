<!-- Type Field -->
<div class="form-group col-sm-6">
    {!! Form::label('type', 'Type') !!}

    <br>

    {!! Form::radio('type', 'survey' , true) !!}
    {!! Form::label('survey', 'Survey') !!}

    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    {!! Form::radio('type', 'poll' , false) !!}
    {!! Form::label('poll', 'Poll') !!}

{{--    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;--}}
{{--    {!! Form::radio('type', 'feedback' , false) !!}--}}
{{--    {!! Form::label('feedback', 'Feedback') !!}--}}


</div>

<!-- Name Field -->
<div class="form-group col-sm-6">
    {!! Form::label('name', 'Name:') !!}
    {!! Form::text('name', null, ['class' => 'form-control']) !!}
</div>

<!-- Description Field -->
<div class="form-group col-sm-6">
    {!! Form::label('description', 'Description:') !!}
    {!! Form::text('description', null, ['class' => 'form-control']) !!}
</div>



<!-- Valid From Field -->
@if(isset($template))
<div class="form-group col-sm-6">
    {!! Form::label('valid_from', 'Valid From:') !!}
    {!! Form::date('valid_from', $template->valid_from, ['class' => 'form-control','id'=>'valid_from']) !!}
</div>
@else
    <div class="form-group col-sm-6">
        {!! Form::label('valid_from', 'Valid From:') !!}
        {!! Form::date('valid_from',null , ['class' => 'form-control','id'=>'valid_from']) !!}
    </div>
    @endif

{{--@section('scripts')--}}
{{--    <script type="text/javascript">--}}
{{--        $('#valid_from').datetimepicker({--}}
{{--            format: 'YYYY-MM-DD HH:mm:ss',--}}
{{--            useCurrent: false--}}
{{--        })--}}
{{--    </script>--}}
{{--@endsection--}}

<!-- Valid Until Field -->
@if(isset($template))
<div class="form-group col-sm-6">
    {!! Form::label('valid_until', 'Valid Until:') !!}
    {!! Form::date('valid_until', $template->valid_until, ['class' => 'form-control','id'=>'valid_until']) !!}
</div>
@else
    <div class="form-group col-sm-6">
        {!! Form::label('valid_until', 'Valid Until:') !!}
        {!! Form::date('valid_until', null, ['class' => 'form-control','id'=>'valid_until']) !!}
    </div>
    @endif

{{--@section('scripts')--}}
{{--    <script type="text/javascript">--}}
{{--        $('#valid_until').datetimepicker({--}}
{{--            format: 'YYYY-MM-DD HH:mm:ss',--}}
{{--            useCurrent: false--}}
{{--        })--}}
{{--    </script>--}}
{{--@endsection--}}

<!-- Email Msg Field -->
<div class="form-group col-sm-12 col-lg-12">
    {!! Form::label('email_msg', 'Email Msg:') !!}
    {!! Form::textarea('email_msg', null, ['class' => 'form-control', 'required' => 'required']) !!}
</div>

<!-- Submit Field -->
<div class="form-group col-sm-12">
    {!! Form::submit('Save', ['class' => 'btn btn-primary']) !!}
    <a href="{!! route('templates.index') !!}" class="btn btn-default">Cancel</a>
</div>
