
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
        <select name="res_field48" id="res_field48_id" class="form-control select2">
            <option value="UPLOAD-FAILED" {{$transactions->res_field48 ==="UPLOAD-FAILED" ? 'selected="selected"' : ''}} disabled>UPLOAD-FAILED</option>
            <option value="AML-APPROVED" {{$transactions->res_field48 ==="AML-APPROVED" ? 'selected="selected"' : ''}}
            >AML-APPROVED</option>
            <option value="FAILED" {{$transactions->res_field48 ==="FAILED" ? 'selected="selected"' : ''}}>FAILED</option>
            <option value="COMPLETED" {{$transactions->res_field48 ==="COMPLETED" ? 'selected="selected"' : ''}}>COMPLETED</option>
        </select>
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
@endif
<!-- Aml Listed Field -->
{{--<div class="form-group">--}}
{{--    {!! Form::label('aml_listed', 'AML Listing Status:') !!}--}}
{{--    {!!Form::select('aml_listed', array('1' => 'LISTED', '0' => 'NOT LISTED'),--}}
{{--    isset($transactions) ? $transactions->aml_listed : null, ['class' => 'form-control select2'])!!}--}}
{{--</div>--}}
<!-- Remarks Field -->
<div class="form-group">
    {!! Form::label('res_field44', 'Transaction Remarks:') !!}
    {!! Form::textarea('res_field44', null, ['id' => 'editor']) !!}
</div>
{{--<div class="form-group col-sm-6">--}}
{{--    <select id="txn-status-id" class="form-control select2">--}}
{{--        <option></option>--}}
{{--    </select>--}}
{{--    {!! Form::label('res_field48', 'Transaction Status:') !!}--}}
{{--    {!!Form::select('res_field48',--}}
{{--        array('AML-APPROVED' => 'AML-APPROVED',--}}
{{--                'FAILED' => 'FAILED',--}}
{{--                'INIT-FAILED' => 'INIT-FAILED',--}}
{{--                'AML-FAILED' => 'AML-FAILED',--}}
{{--                ), isset($transactions) ? $transactions->res_field48 : null, ['class' => 'form-control select2',--}}
{{--                 'id' => 'txn-status-id'])!!}--}}
{{--</div>--}}


<!-- Submit Field -->
<div class="form-group col-sm-12">
    {!! Form::submit('Update', ['class' => 'btn btn-primary']) !!}
    <a href="{{ route('transactions.index') }}" class="btn btn-default">Cancel</a>
</div>

{{--@section('js')--}}
{{--    <script>--}}
{{--        jQuery(document).ready(function () {--}}
{{--            //changing Transaction Status--}}
{{--            let selectedStatus = $('#res_field48_id option:selected').val();--}}
{{--            alert(selectedStatus);--}}
{{--            setDropDownOptions(selectedStatus);--}}
{{--            $('#res_field48_id').on('change', function () {--}}
{{--                let status = $('#res_field48_id option:selected').val();--}}
{{--                setDropDownOptions(status);--}}
{{--            });--}}
{{--        let setDropDownOptions = function (status) {--}}
{{--            $.ajax({--}}
{{--                url: '/transaction-status/' + status,--}}
{{--                type: 'get',--}}
{{--                dataType: "json",--}}
{{--                success: function (response) {--}}
{{--                    let status_id = $('#res_field48_id');--}}
{{--                    if (status === "AML-FAILED") {--}}
{{--                        let txn_status = response['aml_failed_data'];--}}
{{--                    // template_id.empty();--}}
{{--                        status_id.append(new Option('', '', false, false)).trigger('change');--}}
{{--                    Object.keys(txn_status).forEach(function (key) {--}}
{{--                        let newOption = new Option(txn_status[key], key, false, false);--}}
{{--                        status_id.append(newOption).trigger('change');--}}
{{--                    });--}}
{{--                }--}}
{{--                },--}}
{{--            });--}}
{{--            return false;--}}
{{--        }--}}

{{--        })--}}
{{--        // alert('here')--}}
{{--    </script>--}}
{{--    @endsection--}}
