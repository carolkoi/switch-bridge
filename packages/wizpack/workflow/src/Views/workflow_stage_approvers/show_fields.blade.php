<!-- User Id Field -->
<div class="form-group">
    {!! Form::label('user_id', 'User Id:') !!}
    <p>{!! $workflowStageApprovers->user_id !!}</p>
</div>

<!-- Granted By Field -->
<div class="form-group">
    {!! Form::label('granted_by', 'Granted By:') !!}
    <p>{!! $workflowStageApprovers->granted_by !!}</p>
</div>

<!-- Workflow Stage Id Field -->
<div class="form-group">
    {!! Form::label('workflow_stage_id', 'Workflow Stage Id:') !!}
    <p>{!! $workflowStageApprovers->workflow_stage_id !!}</p>
</div>

<!-- Workflow Stage Type Id Field -->
<div class="form-group">
    {!! Form::label('workflow_stage_type_id', 'Workflow Stage Type Id:') !!}
    <p>{!! $workflowStageApprovers->workflow_stage_type_id !!}</p>
</div>

