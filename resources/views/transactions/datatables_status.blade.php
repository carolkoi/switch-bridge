{{--{{dd(\WizPack\Workflow\Models\Approvals::where('model_id', $iso_id)->first()->approved, (\App\Models\SessionTxn::where('txn_id', $iso_id)->exists()))}}--}}
{{--{{dd(\App\Models\Transactions::get())}}--}}
{{--@foreach(\App\Models\Transactions::get() as $trans)--}}
{{--@if((\App\Models\SessionTxn::where('txn_id', $trans->iso_id)->exists() === true) AND--}}
{{--(\WizPack\Workflow\Models\Approvals::where('model_id', $trans->iso_id)->first()->approved === false))--}}
{{--    <span class="label label-info">Pending Approval</span>--}}
{{--    @else--}}
    {{$res_field48}}
{{--    @endif--}}
{{--    @endforeach--}}
