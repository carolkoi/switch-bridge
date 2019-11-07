<!-- Type Field -->
<div class="form-group">
    {!! Form::label('type', 'Type:') !!}
    <p>{!! $surveyReport->type !!}</p>
</div>

<!-- Name Field -->
<div class="form-group">
    {!! Form::label('name', 'Title:') !!}
    <p>{!! $surveyReport->name !!}</p>
</div>

<!-- Description Field -->
<div class="form-group">
    {!! Form::label('created_by', 'Created By:') !!}
    <p>{!! $user->first_name. ' '.$user->last_name !!}</p>
</div>

<!-- Description Field -->
<div class="form-group">
    {!! Form::label('description', 'Description:') !!}
    <p>{!! $surveyReport->description !!}</p>
</div>

{{--<!-- Status Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('status', 'Status:') !!}--}}
{{--    <p>{!! $template->status !!}</p>--}}
{{--</div>--}}

<!-- Valid From Field -->
<div class="form-group">
    {!! Form::label('valid_from', 'start Date:') !!}
    <p>{!! $surveyReport->valid_from !!}</p>
</div>

<!-- Valid Until Field -->
<div class="form-group">
    {!! Form::label('valid_until', 'End Date:') !!}
    <p>{!! $surveyReport->valid_until !!}</p>
</div>

{{--<!-- Email Msg Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('email_msg', 'Email Msg:') !!}--}}
{{--    <p>{!! $template->email_msg !!}</p>--}}
{{--</div>--}}



