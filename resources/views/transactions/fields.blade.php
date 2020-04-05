
<!-- Res Field48 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field48', 'Transaction Status:') !!}
    {!!Form::select('res_field48',
        array('COMPLETED' => 'COMPLETED',
                'AML-APPROVED' => 'AML-APPROVED',
                'UPLOADED' => 'PENDING',
                'FAILED' => 'FAILED'
                ), isset($transactions) ? $transactions->res_field48 : null, ['class' => 'form-control select2'])!!}
</div>

<!-- Aml Listed Field -->

<div class="form-group col-sm-6">
    {!! Form::label('aml_listed', 'AML Listing Status:') !!}
    {!!Form::select('aml_listed', array('1' => 'LISTED', '0' => 'NOT LISTED'),
    isset($transactions) ? $transactions->aml_listed : null, ['class' => 'form-control select2'])!!}
</div>
<!-- Remarks Field -->
<div class="form-group col-sm-6 col-lg-6">
    {!! Form::label('res_field44', 'Transaction Remarks:') !!}
    {!! Form::textarea('res_field44', null, ['id' => 'editor']) !!}
</div>
<!-- Remarks Code Field -->
{{--<div class="form-group col-sm-6 col-lg-6">--}}
{{--    {!! Form::label('res_field39', 'Transaction Remarks Code:') !!}--}}
{{--    {!! Form::text('res_field39', null, ['class' => 'form-control']) !!}--}}
{{--</div>--}}

{{--<!-- Aml Listed Field -->--}}

{{--<div class="form-group col-sm-6">--}}
{{--    {!! Form::label('posted', 'Back Office Posting:') !!}--}}
{{--    {!!Form::select('posted', array('1' => 'TRUE', '0' => 'FALSE'),--}}
{{--    isset($transactions) ? $transactions->posted : null, ['class' => 'form-control select2'])!!}--}}
{{--</div>--}}


<!-- Submit Field -->
<div class="form-group col-sm-12">
    {!! Form::submit('Save', ['class' => 'btn btn-primary']) !!}
    <a href="{{ route('transactions.index') }}" class="btn btn-default">Cancel</a>
</div>
