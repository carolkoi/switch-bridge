{!! Form::hidden('res_field37', $transactions->res_field37, ['class' => 'form-control']) !!}
@if($transactions->res_field48 == "AML-FAILED")
<div class="form-group">
    {!! Form::label('res_field48', 'Transaction Status:') !!}
    {{--    {!!Form::select('res_field48', [],--}}
    {{--    isset($transactions) ? $transactions->res_field48 : null, ['class' => 'form-control select2', 'id' => "res_field48_id"])!!}--}}
    <select name="res_field48" id="res_field48_id" class="form-control select2">
{{--        <option value="AML-APPROVED" {{$transactions->res_field48 ==="AML-APPROVED" ? 'selected="selected"' : ''}}>AML-APPROVED</option>--}}
        <option value="AML-FAILED" {{$transactions->res_field48 ==="AML-FAILED" ? 'selected="selected"' : ''}} disabled>AML-FAILED</option>
        <option value="AML-APPROVED" {{$transactions->res_field48 ==="AML-APPROVED" ? 'selected="selected"' : ''}}>AML-APPROVED</option>
        <option value="FAILED" {{$transactions->res_field48 ==="FAILED" ? 'selected="selected"' : ''}}>FAILED</option>
{{--        <option value="INIT-FAILED" {{$transactions->res_field48 ==="INIT-FAILED" ? 'selected="selected"' : ''}} disabled>INIT-FAILED</option>--}}
    </select>
</div>
@elseif($transactions->res_field48 == "COMPLETED")
    <div class="form-group">
        {!! Form::label('res_field48', 'Transaction Status:') !!}
        {{--    {!!Form::select('res_field48', [],--}}
        {{--    isset($transactions) ? $transactions->res_field48 : null, ['class' => 'form-control select2', 'id' => "res_field48_id"])!!}--}}
        <select name="res_field48" id="res_field48_id" class="form-control select2">
            <option value="COMPLETED" {{$transactions->res_field48 ==="COMPLETED" ? 'selected="selected"' : ''}} disabled>COMPLETED</option>
{{--            <option value="AML-APPROVED" {{$transactions->res_field48 ==="AML-APPROVED" ? 'selected="selected"' : ''}}>AML-APPROVED</option>--}}
            <option value="FAILED" {{$transactions->res_field48 ==="FAILED" ? 'selected="selected"' : ''}}>FAILED</option>
            {{--        <option value="INIT-FAILED" {{$transactions->res_field48 ==="INIT-FAILED" ? 'selected="selected"' : ''}} disabled>INIT-FAILED</option>--}}
        </select>
    </div>
@elseif($transactions->res_field48 == "UPLOADED")
<div class="form-group">
    {!! Form::label('res_field48', 'Transaction Status:') !!}
    {{--    {!!Form::select('res_field48', [],--}}
    {{--    isset($transactions) ? $transactions->res_field48 : null, ['class' => 'form-control select2', 'id' => "res_field48_id"])!!}--}}
    <select name="res_field48" id="res_field48_id" class="form-control select2">
        <option value="UPLOADED" {{$transactions->res_field48 ==="UPLOADED" ? 'selected="selected"' : ''}} disabled>UPLOADED</option>
        <option value="FAILED" {{$transactions->res_field48 ==="FAILED" ? 'selected="selected"' : ''}}>FAILED</option>
        <option value="COMPLETED" {{$transactions->res_field48 ==="COMPLETED" ? 'selected="selected"' : ''}}>COMPLETED</option>
{{--        <option value="INIT-FAILED" {{$transactions->res_field48 ==="INIT-FAILED" ? 'selected="selected"' : ''}} disabled>INIT-FAILED</option>--}}
    </select>
</div>
@elseif($transactions->res_field48 == "UPLOAD-FAILED")
    <div class="form-group">
        {!! Form::label('res_field48', 'Transaction Status:') !!}
        {{--    {!!Form::select('res_field48', [],--}}
        {{--    isset($transactions) ? $transactions->res_field48 : null, ['class' => 'form-control select2', 'id' => "res_field48_id"])!!}--}}
        <select name="res_field48" id="res_field48_id_upload_failed" class="form-control select2">
            <option value="UPLOAD-FAILED" {{$transactions->res_field48 ==="UPLOAD-FAILED" ? 'selected="selected"' : ''}} disabled>UPLOAD-FAILED</option>
            <option value="AML-APPROVED" {{$transactions->res_field48 ==="AML-APPROVED" ? 'selected="selected"' : ''}}
            >AML-APPROVED</option>
            <option value="FAILED" {{$transactions->res_field48 ==="FAILED" ? 'selected="selected"' : ''}}>FAILED</option>
            <option data-relation-id="complete_det_id" value="COMPLETED" {{$transactions->res_field48 ==="COMPLETED" ? 'selected="selected"' : ''}}>COMPLETED</option>
        </select>
    </div>
    <div class="form-group" id="complete_det_id" style="display: none">
        {!! Form::label('sync_message', 'Sync Message:') !!}
        {!! Form::text('sync_message', null, ['class' => 'form-control']) !!}
{{--        <br><br>--}}
{{--        {!! Form::label('paid_out_date', 'Paid Out Date:') !!}--}}
{{--            <div class="input-group date">--}}
{{--                <div class="input-group-addon">--}}
{{--                    <i class="fa fa-calendar"></i>--}}
{{--                </div>--}}
{{--                {!! Form::text('paid_out_date', null, ['class' => 'form-control', 'autocomplete' => 'off', 'id' => 'paid-out-id']) !!}--}}
{{--            </div>--}}
    </div>
@elseif($transactions->res_field48 == "EXPIRED")
    <div class="form-group">
        {!! Form::label('res_field48', 'Transaction Status:') !!}
        {{--    {!!Form::select('res_field48', [],--}}
        {{--    isset($transactions) ? $transactions->res_field48 : null, ['class' => 'form-control select2', 'id' => "res_field48_id"])!!}--}}
        <select name="res_field48" id="res_field48_id" class="form-control select2">
            <option value="EXPIRED" {{$transactions->res_field48 ==="EXPIRED" ? 'selected="selected"' : ''}} disabled>EXPIRED</option>
            <option value="AML-APPROVED" {{$transactions->res_field48 ==="AML-APPROVED" ? 'selected="selected"' : ''}}
            >AML-APPROVED</option>
            <option value="FAILED" {{$transactions->res_field48 ==="FAILED" ? 'selected="selected"' : ''}}>FAILED</option>
            <option value="COMPLETED" {{$transactions->res_field48 ==="COMPLETED" ? 'selected="selected"' : ''}}>COMPLETED</option>
        </select>
    </div>
    @elseif($transactions->res_field48 == "AML-APPROVED")
    <div class="form-group">
        {!! Form::label('res_field48', 'Transaction Status:') !!}
        {{--    {!!Form::select('res_field48', [],--}}
        {{--    isset($transactions) ? $transactions->res_field48 : null, ['class' => 'form-control select2', 'id' => "res_field48_id"])!!}--}}
        <select name="res_field48" id="res_field48_id" class="form-control select2">
            <option value="AML-APPROVED" {{$transactions->res_field48 ==="AML-APPROVED" ? 'selected="selected"' : ''}} disabled>
                AML-APPROVED</option>
            <option value="FAILED" {{$transactions->res_field48 ==="FAILED" ? 'selected="selected"' : ''}}>FAILED</option>
            <option value="COMPLETED" {{$transactions->res_field48 ==="COMPLETED" ? 'selected="selected"' : ''}}>COMPLETED</option>
        </select>
    </div>
@elseif( $transactions->res_field48 == "AML-LISTED")
    <div class="form-group">
        {!! Form::label('res_field48', 'Transaction Status:') !!}
        {{--    {!!Form::select('res_field48', [],--}}
        {{--    isset($transactions) ? $transactions->res_field48 : null, ['class' => 'form-control select2', 'id' => "res_field48_id"])!!}--}}
        <select name="res_field48" id="res_field48_id" class="form-control select2">
            <option value="AML-LISTED" {{$transactions->res_field48 ==="AML-LISTED" ? 'selected="selected"' : ''}} disabled>
                AML-LISTED</option>
            <option value="AML-APPROVED" {{$transactions->res_field48 ==="AML-APPROVED" ? 'selected="selected"' : ''}}>
                AML-APPROVED</option>
            <option value="FAILED" {{$transactions->res_field48 ==="FAILED" ? 'selected="selected"' : ''}}>FAILED</option>
        </select>
    </div>
@elseif( $transactions->res_field48 == "BLACK-LISTED")
    <div class="form-group">
        {!! Form::label('res_field48', 'Transaction Status:') !!}
        {{--    {!!Form::select('res_field48', [],--}}
        {{--    isset($transactions) ? $transactions->res_field48 : null, ['class' => 'form-control select2', 'id' => "res_field48_id"])!!}--}}
        <select name="res_field48" id="res_field48_id" class="form-control select2">
            <option value="BLACK-LISTED" {{$transactions->res_field48 ==="BLACK-LISTED" ? 'selected="selected"' : ''}} disabled>
                BLACK-LISTED</option>
            <option value="AML-APPROVED" {{$transactions->res_field48 ==="AML-APPROVED" ? 'selected="selected"' : ''}}>
                AML-APPROVED</option>
            <option value="FAILED" {{$transactions->res_field48 ==="FAILED" ? 'selected="selected"' : ''}}>FAILED</option>
        </select>
    </div>
@elseif( $transactions->res_field48 == "MANUAL-RECON")
    <div class="form-group">
        {!! Form::label('res_field48', 'Transaction Status:') !!}
        {{--    {!!Form::select('res_field48', [],--}}
        {{--    isset($transactions) ? $transactions->res_field48 : null, ['class' => 'form-control select2', 'id' => "res_field48_id"])!!}--}}
        <select name="res_field48" id="res_field48_id" class="form-control select2">
            <option value="MANUAL-RECON" {{$transactions->res_field48 ==="MANUAL-RECON" ? 'selected="selected"' : ''}} disabled>
                MANUAL-RECKON</option>
            <option value="COMPLETED" {{$transactions->res_field48 ==="COMPLETED" ? 'selected="selected"' : ''}}>
                COMPLETED</option>
            <option value="FAILED" {{$transactions->res_field48 ==="FAILED" ? 'selected="selected"' : ''}}>FAILED</option>
        </select>
    </div>

@endif

{{--<!-- Remarks Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field5', 'Received Amount:') !!}--}}
{{--    {!! Form::text('req_field5', intval($transactions->req_field5)/100, ['class' => 'form-control', 'disabled' => 'disabled']) !!}--}}
{{--</div>--}}

<!-- Remarks Field -->
<div class="form-group">
    {!! Form::label('res_field44', 'Transaction Remarks:') !!}
    {!! Form::textarea('res_field44', null, ['id' => 'editor']) !!}
</div>


<!-- Submit Field -->
<div class="form-group col-sm-12">
    {!! Form::submit('Update', ['class' => 'btn btn-primary']) !!}
    <a href="{{ route('transactions.index') }}" class="btn btn-default">Cancel</a>
</div>
