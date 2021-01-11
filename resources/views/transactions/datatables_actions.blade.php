{{--{!! Form::open(['route' => ['transactions.destroy', $transaction->iso_id], 'method' => 'delete']) !!}--}}
@if($transaction->req_field48 === "FAILED"
OR (\App\Models\SessionTxn::where('txn_id', $transaction->iso_id)->exists() == true && (\WizPack\Workflow\Models\Approvals::where('model_id', $transaction->iso_id)->first()['approved']) == false)
OR Auth::check() && auth()->user()->cannot('Can Update Transaction'))
    <div class='btn-group'>
    <a href="{{ route('transactions.show', $transaction->iso_id) }}" class='btn btn-primary btn-sm'>
        <i class="glyphicon glyphicon-eye-open"></i>
    </a>
{{--        <a href="{{url('customer-messages/'. $transaction->req_field124)}}" class="btn btn-warning btn-sm"> <i class="glyphicon glyphicon-envelope"></i></a>--}}

    </div>
@elseif(Auth::check() && auth()->user()->can('Can Update Transaction') OR ($transaction->req_field41 === "CASH" && $transaction->req_field48 === "AML-APPROVED") OR ($transaction->req_field48 === "UPLOAD-FAILED") OR  $transaction->req_field48 === "AML-LISTED")

    <div class='btn-group'>
    <a href="{{ route('transactions.show', $transaction->iso_id) }}" class='btn btn-primary btn-sm'>
        <i class="glyphicon glyphicon-eye-open"></i>
    </a>
    <a href="{{ route('transactions.edit', $transaction->iso_id) }}" class='btn btn-default btn-sm'>
        <i class="glyphicon glyphicon-edit"></i>
    </a>
       @if( Auth::check() && auth()->user()->can('Can Access Messages'))
        <a href="{{url('customer-messages/'. $transaction->req_field124)}}" class="btn btn-warning btn-sm"> <i class="glyphicon glyphicon-envelope"></i></a>
        @endif
    </div>
@endif

{{--{!! Form::open(['route' => ['transactions.destroy', $transaction->iso_id], 'method' => 'delete']) !!}--}}
{{--{{dd($transaction->iso_id)}}--}}
{{--@if( $transaction->res_field48 === 'FAILED'--}}
{{--OR (\App\Models\SessionTxn::where('txn_id', $transaction->iso_id)->exists() == true && (\WizPack\Workflow\Models\Approvals::where('model_id', $transaction->iso_id)->first()['approved']) == false)--}}
{{--OR Auth::check() && auth()->user()->cannot('Can Update Transaction'))--}}
{{--    <div class='btn-group'>--}}
{{--        <a href="{{ route('transactions.show', $transaction->iso_id) }}" class='btn btn-primary btn-sm'>--}}
{{--            <i class="glyphicon glyphicon-eye-open"></i>--}}
{{--        </a>--}}
{{--        --}}{{--        <a href="{{url('customer-messages/'. $transaction->req_field124)}}" class="btn btn-warning btn-sm"> <i class="glyphicon glyphicon-envelope"></i></a>--}}

{{--    </div>--}}
{{--@elseif(Auth::check() && auth()->user()->can('Can Update Transaction') OR ($transaction->req_field41 === "CASH" && $transaction->res_field48 === "AML-APPROVED") OR ($transaction->res_field48 === "UPLOAD-FAILED") OR  $transaction->res_field48 === "AML-LISTED")--}}

{{--    <div class='btn-group'>--}}
{{--        <a href="{{ route('transactions.show', $transaction->iso_id) }}" class='btn btn-primary btn-sm'>--}}
{{--            <i class="glyphicon glyphicon-eye-open"></i>--}}
{{--        </a>--}}
{{--        <a href="{{ route('transactions.edit', $transaction->iso_id) }}" class='btn btn-default btn-sm'>--}}
{{--            <i class="glyphicon glyphicon-edit"></i>--}}
{{--        </a>--}}
{{--        <a href="{{url('customer-messages/'. $transaction->req_field124)}}" class="btn btn-warning btn-sm"> <i class="glyphicon glyphicon-envelope"></i></a>--}}
{{--    </div>--}}
{{--@endif--}}

