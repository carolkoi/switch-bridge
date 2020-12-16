
<!-- Description Field -->
{{--<div class="form-group col-sm-6">--}}
{{--    {!! Form::label('description', 'Description:') !!}--}}
{{--    <br>--}}
{{--    {!! Form::select('description', ['TOP UP' => 'TOP UP', 'REVERSAL' => 'REVERSAL'],--}}
{{--['class' => 'form-control select2 top_up', 'id' => 'top_up']) !!}--}}
{{--</div>--}}
<div class="form-group col-sm-8">
    {!! Form::label('description', 'Description:') !!}
    <select name="description" id="description" class="form-control select2">
        <option value="TOP UP">TOP UP</option>
        <option value="REVERSAL">REVERSAL</option>
    </select>
</div>

<!-- Partnerid Field -->
{{--<div class="form-group col-sm-12">--}}
{{--    {!! Form::label('partnerid', 'Partnerid:') !!}--}}
{{--    {!! Form::select('partnerid', $partners, ['class' => 'form-control select2']) !!}--}}
{{--</div>--}}
<div class="form-group col-sm-8">
    {!! Form::label('partnerid', 'Partner:') !!}
    <select name="partnerid" id="partnerid" class="form-control select2">
        @foreach($partners as $partner)
            <option value="{{$partner->partner_id}}">{{$partner->partner_name}}</option>
        @endforeach

    </select>
</div>

<!-- Transactionnumber Field -->
{{--<div class="form-group col-sm-6">--}}
{{--    {!! Form::label('transactionnumber', 'Transactionnumber:') !!}--}}
{{--    {!! Form::text('transactionnumber', null, ['class' => 'form-control']) !!}--}}
{{--</div>--}}

<!-- Debit Field -->
{{--<div class="form-group col-sm-6">--}}
{{--    {!! Form::label('debit', 'Debit:') !!}--}}
{{--    {!! Form::number('debit', null, ['class' => 'form-control']) !!}--}}
{{--</div>--}}

<!-- Credit Field -->
<div class="form-group col-sm-8">
    {!! Form::label('credit', 'Credit:') !!}
    {!! Form::number('credit', null, ['class' => 'form-control']) !!}
</div>

<!-- Amount Field -->
{{--<div class="form-group col-sm-6">--}}
    {{--    {!! Form::label('amount', 'Amount:') !!}--}}
    {!! Form::hidden('amount', null, ['class' => 'form-control']) !!}
{{--</div>--}}

<!-- Runningbal Field -->
{{--<div class="form-group col-sm-6">--}}
{{--    {!! Form::label('runningbal', 'Runningbal:') !!}--}}
{{--    {!! Form::number('runningbal', null, ['class' => 'form-control']) !!}--}}
{{--</div>--}}

<!-- Datetimeadded Field -->
{{--<div class="form-group col-sm-6">--}}
{{--    {!! Form::label('datetimeadded', 'Datetimeadded:') !!}--}}
{{--    {!! Form::date('datetimeadded', null, ['class' => 'form-control','id'=>'datetimeadded']) !!}--}}
{{--</div>--}}

{{--@push('scripts')--}}
{{--    <script type="text/javascript">--}}
{{--        $('#datetimeadded').datetimepicker({--}}
{{--            format: 'YYYY-MM-DD HH:mm:ss',--}}
{{--            useCurrent: false--}}
{{--        })--}}
{{--    </script>--}}
{{--@endpush--}}

<!-- Addedby Field -->
{{--<div class="form-group col-sm-6">--}}
    {{--    {!! Form::label('addedby', 'Addedby:') !!}--}}
    {!! Form::hidden('addedby', Auth::check() && Auth::user()->id, ['class' => 'form-control']) !!}
{{--</div>--}}

<!-- Ipaddress Field -->
{{--<div class="form-group col-sm-6">--}}
{{--    {!! Form::label('ipaddress', 'Ipaddress:') !!}--}}
{{--    {!! Form::text('ipaddress', null, ['class' => 'form-control']) !!}--}}
{{--</div>--}}



<!-- Submit Field -->
<div class="form-group col-sm-12">
    {!! Form::submit('Save', ['class' => 'btn btn-primary']) !!}
    {{--    <a href="{{ route('floatBalances.index') }}" class="btn btn-default">Cancel</a>--}}
</div>

