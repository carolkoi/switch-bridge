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
<div class="row">
    <div class="col-md-12 selectAnswer" style="display:none;">
        {!! Form::label('options', 'Add Choices:', ['style'=>"margin-left: 20px"]) !!}
        <div class="row form-group div1">
            <div class="table-responsive">

                <table class="table-bordered" id="InputContainer" style="margin-left: 30px">
                    @foreach($question->answer as $choice)
                    <td>
                        {{--                        <div class="form-group col-sm-6">--}}
{{--                        <input type="hidden" name="optionsId[]" class="form-control" value="{{$choice->id}}">--}}
                        {!! Form::text('optionsId[]', $choice->id, ['class' => 'form-control']) !!}

                        {!! Form::text('options[]', $choice->choice, ['class' => 'form-control']) !!}
                        {{--                        </div>--}}
                    </td>
                    <td>
                        {!! Form::submit('+', ['class' => 'btn btn-info', 'onClick' => 'addAnswer(event);']) !!}

                        {!! Form::submit('X', ['class' => 'btn btn-danger btn_remove', 'onClick' => 'remove(1);']) !!}

                        {{--                    <button class="btn btn-danger btn_remove" type="button" onClick="remove(1)"> X </button>--}}
                    </td>
                        @endforeach
                </table>
            </div>
        </div>

    </div>
</div>


<!-- Description Field -->
<div class="form-group col-md-8">
    {!! Form::label('description', 'Description:') !!}
    {!! Form::textarea('description', null, ['class' => 'form-control']) !!}
</div>


<!-- Submit Field -->
<div class="form-group col-md-8">
    {!! Form::submit('Create', ['class' => 'btn btn-primary']) !!}
    {{--    <a href="{!! route('questions.index') !!}" class="btn btn-default">Cancel</a>--}}
</div>
