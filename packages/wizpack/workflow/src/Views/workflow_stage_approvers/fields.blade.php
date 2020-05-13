<!-- User Id Field -->
<div class="form-group col-sm-6">
    {!! Form::label('user_id', 'Approver:') !!}
    {!! Form::select('user_id', $users, null, ['class' => 'form-control select2']) !!}
</div>

<!-- Workflow Stage Id Field -->
<div class="form-group col-sm-6">
    {!! Form::label('workflow_stage_id', 'Approval Stage Partner:') !!}
    {!! Form::select('workflow_stage_id', $workflowStage, null, ['class' => 'form-control select2']) !!}
</div>

<!-- Submit Field -->
<div class="form-group col-sm-12">
    {!! Form::submit('Save', ['class' => 'btn btn-primary']) !!}
    <a href="{!! route('upesi::stage-approvers.index') !!}" class="btn btn-default">Cancel</a>
</div>
