<!-- Question Id Field -->
<div class="form-group col-sm-6">
    {!! Form::label('question_id', 'Question Id:') !!}
    {!! Form::number('question_id', null, ['class' => 'form-control']) !!}
</div>

<!-- Choice Field -->
<div class="form-group col-sm-6">
    {!! Form::label('choice', 'Choice:') !!}
    {!! Form::text('choice', null, ['class' => 'form-control']) !!}
</div>

<!-- Submit Field -->
<div class="form-group col-sm-12">
    {!! Form::submit('Save', ['class' => 'btn btn-primary']) !!}
    <a href="{!! route('answers.index') !!}" class="btn btn-default">Cancel</a>
</div>
