<!-- Name Field -->
{{--<div class="form-group">--}}
{{--    {!! Form::label('name', 'Name:') !!}--}}
{{--    {!! Form::text('name', null, ['class' => 'form-control']) !!}--}}
{{--</div>--}}
<div class="form-group">
    {!! Form::label('company_id', 'Select Company:') !!}
    {!! Form::select('company_id', $company, null, ['class' => 'form-control select2']) !!}
</div>

<!-- Slug Field -->
{{--<div class="form-group">--}}
{{--    {!! Form::label('slug', 'Slug:') !!}--}}
{{--    {!! Form::text('slug', null, ['class' => 'form-control']) !!}--}}
{{--</div>--}}

<!-- Weight Field -->
{{--<div class="form-group">--}}
{{--    {!! Form::label('weight', 'Weightss:') !!}--}}
{{--    {!! Form::number('weight', null, ['class' => 'form-control']) !!}--}}
{{--</div>--}}

<!-- Submit Field -->
<div class="form-group col-sm-12">
    {!! Form::submit('Save', ['class' => 'btn btn-primary']) !!}
    <a href="{!! route('upesi::approval-partners.index') !!}" class="btn btn-default">Cancel</a>
</div>
