<!-- Template Id Field -->
<div class="form-group col-sm-6">
    {!! Form::label('template_id', 'Template Id:') !!}
    {!! Form::number('template_id', null, ['class' => 'form-control']) !!}
</div>

<!-- Submit Field -->
<div class="form-group col-sm-12">
    {!! Form::submit('Save', ['class' => 'btn btn-primary']) !!}
    <a href="{!! route('settings.index') !!}" class="btn btn-default">Cancel</a>
</div>
