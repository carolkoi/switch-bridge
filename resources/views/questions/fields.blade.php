<!-- Template Id Field -->
{{--<div class="form-group col-sm-6">--}}
{{--    {!! Form::label('template_id', 'Template Id:') !!}--}}
    {!! Form::hidden('template_id', $template_id, ['class' => 'form-control']) !!}
{{--</div>--}}

<!-- Question Field -->
<div class="form-group ">
    {!! Form::label('question', 'Question:') !!}
    {!! Form::text('question', null, ['class' => 'form-control']) !!}
</div>
<!-- Type Field -->
<div class="form-group ">
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
    {!! Form::radio('type', '6', false, ['onclick' => 'getTemplate(6);']) !!} &nbsp;
    {!! Form::label('type', 'Dropdown List' )!!}
    &nbsp;
    {!! Form::radio('type', '3', false, ['onclick' => 'getTemplate(3);']) !!} &nbsp;&nbsp;
    {!! Form::label('type', 'List') !!}
</div>
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

<!-- Description Field -->
<div class="form-group">
    {!! Form::label('description', 'Description:') !!}
    {!! Form::textarea('description', null, ['class' => 'form-control']) !!}
</div>


<!-- Submit Field -->
<div class="form-group">
    {!! Form::submit('Create', ['class' => 'btn btn-primary']) !!}
{{--    <a href="{!! route('questions.index') !!}" class="btn btn-default">Cancel</a>--}}
</div>
