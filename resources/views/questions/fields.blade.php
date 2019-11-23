    {!! Form::hidden('template_id', $template_id, ['class' => 'form-control']) !!}

<!-- Question Field -->
<div class="form-group ">
    {!! Form::label('question', 'Question:') !!}
    {!! Form::text('question', null, ['class' => 'form-control']) !!}
</div>
<!-- Type Field -->
    @if($template->surveyType->status == 1)
    <div class="form-group ">
            {!! Form::radio('type', '7', true, ['onclick' => 'getTemplate(7);']) !!} &nbsp;&nbsp;
            {!! Form::label('type', 'Rating') !!}
        </div>

    @else
<div class="form-group ">
    {!! Form::label('type', 'Answer Type:') !!}
<br/><br/>
    {!! Form::radio('type', '1', true, ['onclick' => 'getTemplate(1);']) !!}&nbsp;&nbsp;
    {!! Form::label('type', 'Text Input') !!}
    &nbsp;
    {!! Form::radio('type', '4', false, ['onclick' => 'getTemplate(4);']) !!}&nbsp;
    {!! Form::label('type', 'Date') !!}
    &nbsp;
    {!! Form::radio('type', '5', false, ['onclick' => 'getTemplate(5);']) !!}&nbsp;&nbsp;
    {!! Form::label('type', 'Number') !!}
    &nbsp;
    {!! Form::radio('type', '2', false, ['onclick' => 'getTemplate(2);']) !!}&nbsp;&nbsp;
    {!! Form::label('type', 'True/False') !!}
    &nbsp;
    {!! Form::radio('type', '6', false, ['onclick' => 'getTemplate(6);']) !!}&nbsp;&nbsp;
    {!! Form::label('type', 'Dropdown List' )!!}
    &nbsp;
    {!! Form::radio('type', '3', false, ['onclick' => 'getTemplate(3);']) !!}&nbsp;&nbsp;
    {!! Form::label('type', 'List') !!}
    &nbsp;
</div>
    @endif
<div class="row">
    <div class="col-md-6 selectAnswer" style="display:none;">
        <div id="InputContainer">
                    <div class="row form-group div1">
                        <div class="col-md-10">
                            {!! Form::label('options', 'Add Choices:') !!}
                            {!! Form::text('options[]', null, ['class' => 'form-control']) !!}
                        </div>
                        <div class="col-md-2">
                            {!! Form::submit('X', ['class' => 'btn btn-danger btn_remove', 'onClick' => 'remove(1);']) !!}
                        </div>
                    </div>
        </div>
        <div class="pull-left">
            {!! Form::submit('+', ['class' => 'btn btn-info', 'onClick' => 'addAnswer(event);']) !!}
        </div>

    </div>
</div>

<!--required field-->
    @if($template->surveyType->status == 1)
<div class="form-group">
    {!! Form::label('status', 'Mark Question as Required:') !!}
    &nbsp;&nbsp;&nbsp;
    {!! Form::checkbox('status',1, true) !!}
</div>
@else
        <div class="form-group" id="required_id">
            {!! Form::label('status', 'Mark Question as Required:') !!}
            &nbsp;&nbsp;&nbsp;
        {!! Form::checkbox('status') !!}
        </div>
            @endif

<!-- Description Field -->
<div class="form-group">
    {!! Form::label('description', 'Description:') !!}
    {!! Form::textarea('description', null, ['class' => 'form-control', 'rows' =>3]) !!}
</div>


<!-- Submit Field -->
<div class="form-group">
    {!! Form::submit('Create', ['class' => 'btn btn-primary']) !!}
{{--    <a href="{!! route('questions.index') !!}" class="btn btn-default">Cancel</a>--}}
</div>
