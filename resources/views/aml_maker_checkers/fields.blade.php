
<!-- Customer Idnumber Field -->
<div class="form-group col-sm-6">
    {!! Form::label('customer_idnumber', 'Customer Id Number:') !!}
    {!! Form::text('customer_idnumber', null, ['class' => 'form-control']) !!}
</div>

<!-- Transaction Number Field -->
<div class="form-group col-sm-6">
    {!! Form::label('transaction_number', 'Transaction Number:') !!}
    {!! Form::text('transaction_number', null, ['class' => 'form-control']) !!}
</div>

<!-- Customer Name Field -->
<div class="form-group col-sm-6">
    {!! Form::label('customer_name', 'Customer Name:') !!}
    {!! Form::text('customer_name', null, ['class' => 'form-control']) !!}
</div>

<!-- Mobile Number Field -->
<div class="form-group col-sm-6">
    {!! Form::label('mobile_number', 'Mobile Number:') !!}
    {!! Form::text('mobile_number', null, ['class' => 'form-control']) !!}
</div>

<!-- Blacklist Status Field -->
<div class="form-group col-sm-6">
    {!! Form::label('blacklist_status', 'Blacklist Status:') !!}
    {!! Form::select('blacklist_status',array('AML-LISTED' => 'AML-LISTED',
    'BLACK-LISTED' => 'BLACK-LISTED', 'PEP-LISTED' => 'PEP-LISTED', 'CLEAN' => 'WHITE-LIST'),
    isset($amlMakerChecker) ? $amlMakerChecker->blacklist_status : null,
    ['class' => 'form-control select2']) !!}
</div>


<!-- Blacklist Source Field -->
<div class="form-group col-sm-6">
    {!! Form::label('blacklist_source', 'Blacklist Source:') !!}
{{--        {!! Form::file('blacklist_source', null, ['class' => 'form-control']) !!}--}}
    <div class="needsclick dropzone" id="document-dropzone"></div>
</div>


<!-- Response Field -->
<div class="form-group col-sm-6 col-lg-6">
    {!! Form::label('response', 'Reason for Blacklisting:') !!}
    {!! Form::textarea('response', null, ['class' => 'form-control', 'id' => 'editor']) !!}
</div>

<!-- Submit Field -->
<div class="form-group col-sm-12">
    {!! Form::submit('Save', ['class' => 'btn btn-primary']) !!}
    <a href="{!! route('aml-listing.index') !!}" class="btn btn-default">Cancel</a>
</div>
