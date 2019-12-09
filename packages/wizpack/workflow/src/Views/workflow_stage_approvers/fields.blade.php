<!-- User Id Field -->
<div class="form-group col-sm-6">
    {!! Form::label('user_id', 'Approver:') !!}
    {!! Form::select('user_id', $users, null, ['class' => 'form-control']) !!}
</div>

<!-- Workflow Stage Id Field -->
<div class="form-group col-sm-6">
    {!! Form::label('workflow_stage_id', 'Workflow Stage :') !!}
    {!! Form::select('workflow_stage_id', $workflowStage, null, ['class' => 'form-control']) !!}
</div>

<!-- Submit Field -->
<div class="form-group col-sm-12">
    {!! Form::submit('Save', ['class' => 'btn btn-primary']) !!}
    <a href="{!! route('wizpack::workflowStageApprovers.index') !!}" class="btn btn-default">Cancel</a>
</div>
