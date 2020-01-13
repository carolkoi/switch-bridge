<!-- Template Id Field -->
{{--<div class="form-group col-sm-6">--}}
{{--    {!! Form::label('template_id', 'Template Id:') !!}--}}

{!! Form::hidden('template_id', $template_id, ['class' => 'form-control']) !!}
{{--</div>--}}

<!-- Question Field -->
<div class="form-group col-md-8">
    {!! Form::label('question', 'Question:') !!}
    {!! Form::text('question', null, ['class' => 'form-control']) !!}
</div>

<!-- Type Field -->
@if($template->surveyType->status == 1)
    <div class="form-group col-md-8">
        {!! Form::radio('type', '7', true, ['id'=>'evaluation_id']) !!} &nbsp;&nbsp;
        {!! Form::label('type', 'Rating') !!}
    </div>

@else
<div class="form-group col-md-8">
    {!! Form::label('type', 'Question Type:') !!}
    <br/><br/>
    {!! Form::radio('type', '1', true, ['onclick' => 'getTemplate(1);']) !!} &nbsp;
    {!! Form::label('type', 'Text Input') !!}
    &nbsp;
    {!! Form::radio('type', '4', false, ['onclick' => 'getTemplate(4);']) !!} &nbsp;
    {!! Form::label('type', 'Date') !!}
    &nbsp;
    {!! Form::radio('type', '5', false, ['onclick' => 'getTemplate(5);']) !!} &nbsp;
    {!! Form::label('type', 'Number') !!}
    &nbsp;
    {!! Form::radio('type', '2', false, ['onclick' => 'getTemplate(2);']) !!} &nbsp;
    {!! Form::label('type', 'True/False') !!}
    &nbsp;
    {!! Form::radio('type', '6', false, ['id' => 'drop_down', 'onclick' => 'getTemplate(6);']) !!} &nbsp;
    {!! Form::label('type', 'Dropdown List' )!!}
    &nbsp;
    {!! Form::radio('type', '3', false, ['id' => 'multiple', 'onclick' => 'getTemplate(3);']) !!} &nbsp;&nbsp;
    {!! Form::label('type', 'List') !!}
</div>
@endif
<div class="row">
    <div class="col-md-12 selectAnswer" style="display:none;">
        <div id="InputContainer">
            @foreach($question->answer as $choice)
            <div class="row form-group div1">
                <div class="col-md-8">
{{--                    {!! Form::label('options', 'Add Choices:', ['style'=>"margin-left: 20px"]) !!}--}}

                    {!! Form::hidden('optionsId[]', $choice->id, ['class' => 'form-control']) !!}
                    {!! Form::text('options[]', $choice->choice, ['class' => 'form-control', 'style'=>"margin-left: 20px"]) !!}
                </div>
                <div class="col-md-2">
                    {!! Form::submit('X', ['class' => 'btn btn-danger btn_remove', 'onClick' => 'remove(1);']) !!}
                </div>
            </div>
                @endforeach
        </div>
        <div class="pull-left">
            {!! Form::submit('+', ['class' => 'btn btn-info', 'style'=>"margin-left: 20px", 'onClick' => 'addAnswer(event);']) !!}
        </div>

    </div>
</div>
<br>
<!--required field-->
@if($template->surveyType->status == 1)
    <div class="form-group" id="evaluation_required_id">
        {!! Form::label('status', 'Mark Question as Required:') !!}
        &nbsp;&nbsp;&nbsp;
        {!! Form::checkbox('status',1, true) !!}
    </div>
@else
    <div class="form-group" id="evaluation_required_id">
        {!! Form::label('status', 'Mark Question as Required:') !!}
        &nbsp;&nbsp;&nbsp;
        {!! Form::checkbox('status', $question->status ) !!}
    </div>
@endif

<!-- Description Field -->
<div class="form-group col-md-8">
    {!! Form::label('description', 'Description:') !!}
    {!! Form::textarea('description', $question->description, ['class' => 'form-control']) !!}
</div>


<!-- Submit Field -->
<div class="form-group col-md-8">
    {!! Form::submit('Update', ['class' => 'btn btn-primary']) !!}
    {{--    <a href="{!! route('questions.index') !!}" class="btn btn-default">Cancel</a>--}}
</div>

