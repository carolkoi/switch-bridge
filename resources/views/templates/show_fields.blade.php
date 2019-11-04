<!-- Type Field -->
<div class="form-group">
    {!! Form::label('type', 'Type:') !!}
    <p>{!! $template->type !!}</p>
</div>

<!-- Name Field -->
<div class="form-group">
    {!! Form::label('name', 'Title:') !!}
    <p>{!! $template->name !!}</p>
</div>

<!-- Description Field -->
<div class="form-group">
    {!! Form::label('description', 'Description:') !!}
    <p>{!! $template->description !!}</p>
</div>

<!-- Status Field -->
<div class="form-group">
    {!! Form::label('status', 'Status:') !!}
    <p>{!! $template->status !!}</p>
</div>

<!-- Valid From Field -->
<div class="form-group">
    {!! Form::label('valid_from', 'Valid From:') !!}
    <p>{!! $template->valid_from !!}</p>
</div>

<!-- Valid Until Field -->
<div class="form-group">
    {!! Form::label('valid_until', 'Valid Until:') !!}
    <p>{!! $template->valid_until !!}</p>
</div>

<!-- Email Msg Field -->
<div class="form-group">
    {!! Form::label('email_msg', 'Email Msg:') !!}
    <p>{!! $template->email_msg !!}</p>
</div>



