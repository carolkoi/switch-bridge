<!-- Name Field -->
<div class="form-group col-sm-6">
    {!! Form::label('avatar', 'Profile Picture:') !!}
    {!! Form::file('avatar', null) !!}
</div>

<div class="form-group col-sm-12">
    {!! Form::submit('Set Profile Picture', ['class' => 'btn btn-primary', 'id' =>'submit']) !!}
    {{--                <a href="{!! route('users.index') !!}" class="btn btn-default">Cancel</a>--}}
</div>
