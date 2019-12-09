@extends('layouts.app')

@section('content')
    <section class="content-header">
        <h3>{{$workflow['name']}}
            <small>sent by {{$workflow['sent_by']->name}}</small>
        </h3>
    </section>
    <section class="content">
        <div class="box box-primary">
            <div class="box-body">
                <div class="table-responsive">
                    <table class="table table-bordered">
                        <thead>
                        <tr class="thead-dark">
                            <th>#</th>
                            <th>Workflow stage</th>
                            <th class="text-center">Order</th>
                            <th class="text-center">Approvers</th>
                            <th class="text-center" colspan="2">Approval Status</th>
                        </tr>
                        </thead>
                        <tbody>
                        @foreach($approvals as $key=>$stage)
                            <tr>
                                <td>{{$key+1}}</td>
                                <td>{{$stage['workflow_stage_type_name']}}</td>
                                <td class="text-center">{{$stage['weight']}} </td>
                                <td>
                                    <table class="table">
                                        @foreach($stage['workflow_approvers'] as $key=>$approver)
                                            <tr>
                                                <td>{{$key+1}}</td>
                                                <td>{{$approver['approver_name']}}</td>
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
                                                @endif
                                                @if(!empty($stage['rejected_by']))
                                                    <span class="label label-danger">Rejected By:</span>
                                                    <ul>
                                                        @foreach(($stage['rejected_by']) as $approvedBy)
                                                            <li>{{$approvedBy['user_name']}}</li>
                                                            <li>{{formatToDateTime($approvedBy['rejected_at'])}}</li>
                                                        @endforeach
                                                    </ul>
                                                @endif

                                                @if(empty($stage['rejected_by']) && empty($stage['approved_by']) && !$approvalHasBeenRejected)
                                                    <span class="label label-info">Approval pending</span>
                                                @endif

                                                @if(empty($stage['rejected_by']) && empty($stage['approved_by']) && $approvalHasBeenRejected)
                                                    <span class="label label-default text-center"></span>
                                                @endif
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                                <td class="text-center" style="vertical-align: center">
                                    @if($stage['is_current_stage'] && $stage['canApproveStage'] && !$stage['is_stage_complete'])
                                        <a href="{{url('/wizpack/workflowApproveRequest/'.$workflow['id'].'/'.$stage['id'])}}"
                                           class="btn btn-primary btn-sm"> CheckList</a>
                                        <a href="{{url('/wizpack/workflowApproveRequest/'.$workflow['id'].'/'.$stage['id'])}}"
                                           class="btn btn-success btn-sm">Approve</a>
                                        <a href="{{url('/wizpack/workflowRejecctRequest/'.$workflow['id'].'/'.$stage['id'])}}"
                                           class="btn btn-danger btn-sm">Rejecct</a>
                                    @endif
                                </td>
                            </tr>
                        @endforeach
                        </tbody>
                    </table>
                </div>
                <a href="{!! route('wizpack::approvals.index') !!}" class="btn btn-default">Back</a>
            </div>
        </div>
    </section>
@endsection
