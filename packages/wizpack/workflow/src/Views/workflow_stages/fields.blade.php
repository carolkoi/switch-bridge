<!-- Workflow Stage Type Id Field -->
<div class="form-group col-sm-6">
    {!! Form::label('workflow_stage_type_id', 'Workflow Stage Type ') !!}
    {!! Form::select('workflow_stage_type_id',$workFlowStageTypes, null, ['class' => 'form-control']) !!}
</div>


<!-- Workflow Type Id Field -->
<div class="form-group col-sm-6">
    {!! Form::label('workflow_type_id', 'Workflow Type ') !!}
    {!! Form::select('workflow_type_id',$workFlowTypes, null, ['class' => 'form-control']) !!}
</div>

<!-- Weight Field -->
<div class="form-group col-sm-6">
    {!! Form::label('weight', 'Weight:') !!}
    {!! Form::number('weight', null, ['class' => 'form-control']) !!}
</div>

<!-- Submit Field -->
<div class="form-group col-sm-12">
    {!! Form::submit('Save', ['class' => 'btn btn-primary']) !!}
    <a href="{!! route('wizpack::workflowStages.index') !!}" class="btn btn-default">Cancel</a>
</div>
