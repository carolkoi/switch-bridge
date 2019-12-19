<!-- Account Field -->
<div class="form-group col-sm-6">
    {!! Form::label('account', 'Account:') !!}
    {!! Form::text('account', null, ['class' => 'form-control']) !!}
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

<!-- Physical1 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('physical1', 'Physical1:') !!}
    {!! Form::text('physical1', null, ['class' => 'form-control']) !!}
</div>

<!-- Physical2 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('physical2', 'Physical2:') !!}
    {!! Form::text('physical2', null, ['class' => 'form-control']) !!}
</div>

<!-- Physical3 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('physical3', 'Physical3:') !!}
    {!! Form::text('physical3', null, ['class' => 'form-control']) !!}
</div>

<!-- Physical4 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('physical4', 'Physical4:') !!}
    {!! Form::text('physical4', null, ['class' => 'form-control']) !!}
</div>

<!-- Physical5 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('physical5', 'Physical5:') !!}
    {!! Form::text('physical5', null, ['class' => 'form-control']) !!}
</div>

<!-- Post1 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('post1', 'Post1:') !!}
    {!! Form::text('post1', null, ['class' => 'form-control']) !!}
</div>

<!-- Post2 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('post2', 'Post2:') !!}
    {!! Form::text('post2', null, ['class' => 'form-control']) !!}
</div>

<!-- Post3 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('post3', 'Post3:') !!}
    {!! Form::text('post3', null, ['class' => 'form-control']) !!}
</div>

<!-- Post4 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('post4', 'Post4:') !!}
    {!! Form::text('post4', null, ['class' => 'form-control']) !!}
</div>

<!-- Post5 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('post5', 'Post5:') !!}
    {!! Form::text('post5', null, ['class' => 'form-control']) !!}
</div>

<!-- Tax Number Field -->
<div class="form-group col-sm-6">
    {!! Form::label('tax_number', 'Tax Number:') !!}
    {!! Form::text('tax_number', null, ['class' => 'form-control']) !!}
</div>

<!-- Email Field -->
<div class="form-group col-sm-6">
    {!! Form::label('email', 'Email:') !!}
    {!! Form::email('email', null, ['class' => 'form-control']) !!}
</div>

<!-- Submit Field -->
<div class="form-group col-sm-12">
    {!! Form::submit('Save', ['class' => 'btn btn-primary']) !!}
    <a href="{!! route('vendors.index') !!}" class="btn btn-default">Cancel</a>
</div>
