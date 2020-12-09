<!-- Company Id Field -->
@if(Auth::user()->company_id == 9)
    <div class="form-group col-sm-6">

    {!! Form::label('company_id', 'Company:') !!}
    {!! Form::select('company_id', ['9' => 'UPESI'], null, ['class' => 'form-control select2']) !!}
    </div>

@elseif(Auth::user()->company_id == 10)
    <div class="form-group col-sm-6">

    {!! Form::label('company_id', 'Company:') !!}
    {!! Form::select('company_id', ['10' => 'CHIPPERCASH'], null, ['class' => 'form-control select2']) !!}
    </div>
    @elseif(Auth::user()->company_id == 11)
    <div class="form-group col-sm-6">

    {!! Form::label('company_id', 'Company:') !!}
    {!! Form::select('company_id', ['11' => 'NGAO'], null, ['class' => 'form-control select2']) !!}
    </div>
    @else
    <div class="form-group col-sm-6">
        {!! Form::label('company_id', 'Company:') !!}
        {!! Form::select('company_id', $companies, null, ['class' => 'form-control select2']) !!}
    </div>
    @endif

<!-- Role Id Field -->
<div class="form-group col-sm-6">
    {!! Form::label('role_id', 'Role:') !!}
    {!! Form::select('role_id', $roles, null, ['class' => 'form-control select2']) !!}
</div>

<!-- Name Field -->
<div class="form-group col-sm-6">
    {!! Form::label('name', 'Name:') !!}
    {!! Form::text('name', null, ['class' => 'form-control']) !!}
</div>

<!-- Contact Person Field -->
<div class="form-group col-sm-6">
    {!! Form::label('contact_person', 'Contact Person:') !!}
    {!! Form::text('contact_person', null, ['class' => 'form-control']) !!}
</div>

<!-- Email Field -->
<div class="form-group col-sm-6">
    {!! Form::label('email', 'Email:') !!}
    {!! Form::email('email', null, ['class' => 'form-control']) !!}
</div>



<!-- Msisdn Field -->
<div class="form-group col-sm-6">
    {!! Form::label('msisdn', 'Msisdn:') !!}
    {!! Form::number('msisdn', null, ['class' => 'form-control']) !!}
</div>

<!-- Status Field -->
{{--<div class="form-group col-sm-6">--}}
{{--    {!! Form::label('status', 'Status:') !!}--}}
{{--    {!! Form::text('status', null, ['class' => 'form-control']) !!}--}}
{{--</div>--}}

<!-- Remember Token Field -->
{{--<div class="form-group col-sm-6">--}}
{{--    {!! Form::label('remember_token', 'Remember Token:') !!}--}}
{{--    {!! Form::text('remember_token', null, ['class' => 'form-control']) !!}--}}
{{--</div>--}}

<!-- Submit Field -->
<div class="form-group col-sm-12">
    {!! Form::submit('Save', ['class' => 'btn btn-primary']) !!}
    <a href="{!! route('users.index') !!}" class="btn btn-default">Cancel</a>
</div>
