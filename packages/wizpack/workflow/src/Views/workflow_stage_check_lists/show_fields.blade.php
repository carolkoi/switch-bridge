<!-- Name Field -->
<div class="form-group">
    {!! Form::label('name', 'Name:') !!}
    <p>{!! $workflowStageCheckList->name !!}</p>
</div>

<!-- Text Field -->
<div class="form-group">
    {!! Form::label('text', 'Text:') !!}
    <p>{!! $workflowStageCheckList->text !!}</p>
</div>

<!-- Status Field -->
<div class="form-group">
    {!! Form::label('status', 'Status:') !!}
    <p>{!! $workflowStageCheckList->status !!}</p>
</div>

<!-- Workflow Stages Id Field -->
<div class="form-group">
    {!! Form::label('workflow_stages_id', 'Workflow Stages Id:') !!}
    <p>{!! $workflowStageCheckList->workflow_stages_id !!}</p>
</div>

