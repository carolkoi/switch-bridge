<!-- Blacklist Source Field -->
<div class="form-group">
    {!! Form::label('blacklist_source', 'CSV /Excel Sheet to Import:') !!}
            {!! Form::file('blacklist_source', ['class' => 'form-control']) !!}
{{--    <div class="needsclick dropzone" id="document-dropzone"></div>--}}
</div>
<div class="form-group">
    {!! Form::checkbox('csv_header', null) !!}
    {!! Form::label('csv_header', 'File contains header row?') !!}

</div>
<!-- Submit Field -->
<div class="form-group col-sm-12">
    {!! Form::submit('Save', ['class' => 'btn btn-primary']) !!}
    <a href="{!! route('aml-listing.index') !!}" class="btn btn-default">Cancel</a>
</div>
