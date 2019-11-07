
<!-- Submit Field -->
<div class="form-group col-sm-8">
    {!! Form::label('questions', 'Question') !!}
    {!! Form::text('questions', null, ['class' => 'form-control']) !!}
</div>

<!-- Submit Field -->
<div class="form-group col-sm-12">
    {!! Form::submit('Save', ['class' => 'btn btn-primary']) !!}
    <a href="{!! route('options.index') !!}" class="btn btn-default">Cancel</a>
</div>
