@extends('layouts.app')

@section('content')
    <section class="content-header">
        <h3>{{$workflow['worklflow_type']}}
            <small>sent by {{\App\Models\User::find($workflow['sent_by'])->name}}</small>
        </h3>
    </section>
{{--    {{dd($transaction)}}--}}
    <section class="content">
        <div class="box box-primary">
            <div class="box-body">
                <div class="table-responsive">
                    <table class="table table-bordered">
                        <thead>
                        <tr class="thead-dark">
                            <th>#</th>
                            <th>Approval Type</th>
{{--                            <th class="text-center">Order</th>--}}
                            <th class="text-center">Approvers</th>
                            <th class="text-center" colspan="2">Approval Status</th>
                        </tr>
                        </thead>
                        <tbody>
{{--                        @foreach($approvers as $key=>$stage)--}}
                            <tr>
                                <td>#</td>
                                <td>Transaction Approval</td>
{{--                                <td class="text-center">{{$stage['weight']}} </td>--}}
                                <td>
                                    <table class="table">
                                        @foreach($approvers as $key=>$approver)
                                            <tr>
                                                <td>{{$key+1}}</td>
                                                <td>{{\App\Models\User::find($approver['user_id'])->name}}</td>
                                            </tr>

                                        @endforeach
                                    </table>
                                </td>
                                <td class="text-center">
                                    <table>
                                        <tr>
                                            <td>
                                                @if(!empty($stage['approved_by']))
                                                    <span class="label label-success">Approved By:</span>
                                                    <ul>
                                                        @foreach(($stage['approved_by']) as $approvedBy)
                                                            <li>{{$approvedBy['user_name']}}</li>
                                                            <li>{{formatToDateTime($approvedBy['approved_at'])}}</li>
                                                        @endforeach

                                                    </ul>
                                                @if($workflow['workflow_type'] != 'float_top_up_approval')
                                                    <a href="{{route('transactions.show', $transaction['iso_id'])}}"
                                                       class="btn btn-primary btn-sm"> View Transaction</a>
                                                    @endif
                                                @endif

                                                @if(!empty($stage['rejected_by']))
                                                    <span class="label label-danger">Rejected By:</span>
                                                    <ul>
                                                        @foreach(($stage['rejected_by']) as $approvedBy)
                                                            <li>{{$approvedBy['user_name']}}</li>
                                                            <li>{{formatToDateTime($approvedBy['rejected_at'])}}</li>
                                                        @endforeach
                                                    </ul>
                                                        @if($workflow['workflow_type'] != 'float_top_up_approval')

                                                        <a href="{{route('transactions.show', $transaction['iso_id'])}}"
                                                           class="btn btn-primary btn-sm">Transaction</a>
                                                            @endif
                                                @endif


                                                @if(empty($stage['rejected_by']) && empty($stage['approved_by']) )
{{--                                                    <span class="label label-info">Approval pending</span>--}}
                                                        @if($workflow['workflow_type'] != 'float_top_up_approval')

                                                        <p>
                                                        <span>
                                                            Approval pending for <a href="{{route('transactions.show', $transaction['iso_id'])}}"
                                                                                    >Transaction</a> <br/>
                                                            from<br/>
                                                            <span class="label label-warning">{{$transaction->res_field48}}</span> to
                                                            <span class="label label-info">{{$sessionTxn['txn_status']}}</span>
                                                        </span></p>
                                                        @endif
                                                    <br>

                                                @endif

                                                @if(empty($workflow['rejected_by']) && empty($workflow['approved_by']))
{{--                                                    {{dd($workflow)}}--}}
{{--                                                    <span class="label label-default text-center">Approved By:--}}
{{--                                                    {{\App\Models\User::find(Auth::id())->name}}</span>--}}
                                                @endif
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                                <td class="text-center" id="approve-col" style="vertical-align: center">
                                    @if(Auth::check() && auth()->user()->can('Can Update Transaction')
&& \WizPack\Workflow\Models\Approvals::find($workflow['id'])->approved_at == null && \WizPack\Workflow\Models\Approvals::find($workflow['id'])->rejected_at == null)
{{--                                        <a href="{{url('/wizpack/workflowApproveRequest/'.$workflow['id'].'/'.$stage['id'])}}"--}}
{{--                                           class="btn btn-primary btn-sm"> CheckList</a>--}}
                                        <a href="{{url('/upesi/transaction-approve-request/'.$workflow['id'])}}"
                                           class="btn btn-success btn-sm" id="approve">Approve</a>
                                        <a href="" id="reject-id"
                                           class="btn btn-danger btn-sm">Reject</a>
                                    @else
                                        <span class="label label-primary text-center" id="label">Approved By:
                                                    {{\App\Models\User::find(Auth::id())->name}}
                                        at {{\Carbon\Carbon::now()->format('Y-m-d H:i:s')}}</span>
                                    @endif
                                </td>
                            </tr>
{{--                        @endforeach--}}
                        </tbody>
                    </table>
                </div>
                <a href="{!! route('upesi::approvals.index') !!}" class="btn btn-default">Back</a>
            </div>
        </div>
    </section>
@endsection
{{--{{url('/upesi/transaction-Reject-request/'.$workflow['id'].'/'.$stage['id'])}}--}}
@section('scripts')
{{--    <script>--}}
{{--        $('#label').hide();--}}
{{--        $('#approve').on('click', function () {--}}
{{--            $('#approve, #reject-id').hide()--}}
{{--            $('#label').show();--}}

{{--        })--}}

{{--    </script>--}}
@endsection
