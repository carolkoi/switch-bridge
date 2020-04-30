<!-- Res Field48 Field -->
<div class="form-group">
    {!! Form::label('res_field48', 'Transaction Status:') !!}
{{--    {!!Form::select('res_field48', [],--}}
{{--    isset($transactions) ? $transactions->res_field48 : null, ['class' => 'form-control select2', 'id' => "res_field48_id"])!!}--}}
    <select name="res_field48" id="res_field48_id" class="form-control select2">
            <option value="AML-APPROVED" {{$transactions->res_field48 ==="AML-APPROVED" ? 'selected="selected"' : ''}}>AML-APPROVED</option>
            <option value="FAILED" {{$transactions->res_field48 ==="FAILED" ? 'selected="selected"' : ''}}>FAILED</option>
            <option value="AML-FAILED" {{$transactions->res_field48 ==="AML-FAILED" ? 'selected="selected"' : ''}} disabled>AML-FAILED</option>
            <option value="INIT-FAILED" {{$transactions->res_field48 ==="INIT-FAILED" ? 'selected="selected"' : ''}} disabled>INIT-FAILED</option>
    </select>
</div>
<!-- Aml Listed Field -->
<div class="form-group">
    {!! Form::label('aml_listed', 'AML Listing Status:') !!}
    {!!Form::select('aml_listed', array('1' => 'LISTED', '0' => 'NOT LISTED'),
    isset($transactions) ? $transactions->aml_listed : null, ['class' => 'form-control select2'])!!}
</div>
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