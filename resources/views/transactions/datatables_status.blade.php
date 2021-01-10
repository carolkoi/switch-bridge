
@if((\App\Models\SessionTxn::where('txn_id', $transaction->iso_id)->exists() === true) &&
(\WizPack\Workflow\Models\Approvals::where('model_id', $transaction->iso_id)->first()['approved'] === false))
    <span class="label label-info">Approval Pending</span>
    @else
    {{$transaction->res_field48}}
    @endif
{{--    @endforeach--}}
