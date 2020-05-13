<!-- Name Field -->
<div class="form-group">
    {!! Form::label('name', 'Name:') !!}
    <p>{{ $permission->name }}</p>
</div>

<!-- Guard Name Field -->
<div class="form-group">
    {!! Form::label('description', 'Description:') !!}
    <p>{!! $permission->description !!} </p>
</div>

