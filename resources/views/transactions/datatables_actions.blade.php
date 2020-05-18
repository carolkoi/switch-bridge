{{--{!! Form::open(['route' => ['transactions.destroy', $iso_id], 'method' => 'delete']) !!}--}}
@if($res_field48 === "COMPLETED" OR $res_field48 === "FAILED"
OR (\App\Models\SessionTxn::where('txn_id', $iso_id)->exists() == true && (\WizPack\Workflow\Models\Approvals::where('model_id', $iso_id)->first()['approved']) == false)
OR Auth::check() && auth()->user()->cannot('Can Update Transaction'))
    <a href="{{ route('transactions.show', $iso_id) }}" class='btn btn-primary btn-sm'>
        <i class="glyphicon glyphicon-eye-open"></i>
    </a>
@elseif(Auth::check() && auth()->user()->can('Can Update Transaction') OR ($req_field41 === "CASH" && $res_field48 === "AML-APPROVED") OR  $res_field48 === "AML-LISTED")

    <div class='btn-group'>
    <a href="{{ route('transactions.show', $iso_id) }}" class='btn btn-primary btn-sm'>
        <i class="glyphicon glyphicon-eye-open"></i>
    </a>
{{--    <br/>--}}
    <a href="{{ route('transactions.edit', $iso_id) }}" class='btn btn-default btn-sm'>
        <i class="glyphicon glyphicon-edit"></i>
    </a>
</div>
@endif

{{--{!! Form::close() !!}--}}
{{--@else--}}
{{--<div class="btn-group btn-hspace">--}}
{{--    <button class="btn btn-secondary dropdown-toggle" type="button" data-toggle="dropdown">Action <span class="icon-dropdown mdi mdi-chevron-down"></span></button>--}}
{{--    <div class="dropdown-menu" role="menu">--}}
{{--        <a class="dropdown-item" href="{{ route('transactions.show', $iso_id) }}">View</a>--}}
{{--        <div class="dropdown-divider"></div>--}}
{{--        <div class="dropdown-divider"></div>--}}
{{--        <a class="dropdown-item" href="{{route('transactions.edit', $iso_id) }}">Edit</a>--}}
{{--        <div class="dropdown-divider"></div>--}}
{{--        <div class="dropdown-divider"></div>--}}
{{--        <a class="dropdown-item" href="#">Separated link</a>--}}
{{--    </div>--}}
{{--</div>--}}
{{--    @endif--}}
