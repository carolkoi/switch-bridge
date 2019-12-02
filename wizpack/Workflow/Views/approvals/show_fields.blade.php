<!-- User Id Field -->
<div class="form-group">
    {!! Form::label('user_id', 'User Id:') !!}
    <p>{!! $approvals->user_id !!}</p>
</div>

<!-- Workflow Type Field -->
<div class="form-group">
    {!! Form::label('workflow_type', 'Workflow Type:') !!}
    <p>{!! $approvals->workflow_type !!}</p>
</div>

<!-- Model Id Field -->
<div class="form-group">
    {!! Form::label('model_id', 'Model Id:') !!}
    <p>{!! $approvals->model_id !!}</p>
</div>

<!-- Model Type Field -->
<div class="form-group">
    {!! Form::label('model_type', 'Model Type:') !!}
    <p>{!! $approvals->model_type !!}</p>
</div>

<!-- Collection Name Field -->
<div class="form-group">
    {!! Form::label('collection_name', 'Collection Name:') !!}
    <p>{!! $approvals->collection_name !!}</p>
</div>

<!-- Payload Field -->
<div class="form-group">
    {!! Form::label('payload', 'Payload:') !!}
    <p>{!! $approvals->payload !!}</p>
</div>

<!-- Sent By Field -->
<div class="form-group">
    {!! Form::label('sent_by', 'Sent By:') !!}
    <p>{!! $approvals->sent_by !!}</p>
</div>

<!-- Approved Field -->
<div class="form-group">
    {!! Form::label('approved', 'Approved:') !!}
    <p>{!! $approvals->approved !!}</p>
</div>

<!-- Approved On Field -->
<div class="form-group">
    {!! Form::label('approved_on', 'Approved On:') !!}
    <p>{!! $approvals->approved_on !!}</p>
</div>

<!-- Awaiting Stage Id Field -->
<div class="form-group">
    {!! Form::label('awaiting_stage_id', 'Awaiting Stage Id:') !!}
    <p>{!! $approvals->awaiting_stage_id !!}</p>
</div>

