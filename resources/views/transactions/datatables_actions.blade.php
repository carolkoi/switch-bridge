{{--{!! Form::open(['route' => ['transactions.destroy', $iso_id], 'method' => 'delete']) !!}--}}
@if($res_field48 === "FAILED"
OR (\App\Models\SessionTxn::where('txn_id', $iso_id)->exists() == true && (\WizPack\Workflow\Models\Approvals::where('model_id', $iso_id)->first()['approved']) == false)
OR Auth::check() && auth()->user()->cannot('Can Update Transaction'))
    <div class='btn-group'>
    <a href="{{ route('transactions.show', $iso_id) }}" class='btn btn-primary btn-sm'>
        <i class="glyphicon glyphicon-eye-open"></i>
    </a>
{{--        <a href="{{url('customer-messages/'. $req_field124)}}" class="btn btn-warning btn-sm"> <i class="glyphicon glyphicon-envelope"></i></a>--}}

    </div>
@elseif(Auth::check() && auth()->user()->can('Can Update Transaction'))

    <div class='btn-group'>
    <a href="{{ route('transactions.show', $iso_id) }}" class='btn btn-primary btn-sm'>
        <i class="glyphicon glyphicon-eye-open"></i>
    </a>
    <a href="{{ route('transactions.edit', $iso_id) }}" class='btn btn-default btn-sm'>
        <i class="glyphicon glyphicon-edit"></i>
    </a>
        <a href="{{url('customer-messages/'. $req_field124)}}" class="btn btn-warning btn-sm"> <i class="glyphicon glyphicon-envelope"></i></a>
    </div>
@endif
