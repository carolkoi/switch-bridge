<!-- Template Id Field -->
<div class="form-group">
    {!! Form::label('template_id', 'Template Id:') !!}
    <p>{!! $template->name !!}</p>
</div>

<!-- Question Field -->
<div class="form-group">
    {!! Form::label('question', 'Question:') !!}
    <p>{!! $question->question !!}</p>
</div>

<!-- Type Field -->
<div class="form-group">
    {!! Form::label('type', 'Type:') !!}
    <p>{!! $question->type !!}</p>
</div>

{{--<!-- Answer Id Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('answer_id', 'Answer Id:') !!}--}}
{{--    <p>{!! $question->answer_id !!}</p>--}}
{{--</div>--}}

{{--<!-- Status Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('status', 'Status:') !!}--}}
{{--    <p>{!! $question->status !!}</p>--}}
{{--</div>--}}

<!-- Description Field -->
<div class="form-group">
    {!! Form::label('description', 'Description:') !!}
    <p>{!! $question->description !!}</p>
</div>

