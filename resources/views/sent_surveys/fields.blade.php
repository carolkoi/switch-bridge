<!-- Token Field -->
<div class="form-group col-sm-12 col-lg-12">
    {!! Form::label('token', 'Token:') !!}
    {!! Form::textarea('token', null, ['class' => 'form-control']) !!}
</div>

<!-- Submit Field -->
<div class="form-group col-sm-12">
    {!! Form::submit('Save', ['class' => 'btn btn-primary']) !!}
    <a href="{!! route('sentSurveys.index') !!}" class="btn btn-default">Cancel</a>
</div>
