<!-- Workflow Stage Type Id Field -->
<div class="form-group col-sm-6">
    {!! Form::label('workflow_stage_type_id', 'Approval Stage Partners ') !!}
    {!! Form::select('workflow_stage_type_id',$workFlowStageTypes, null, ['class' => 'form-control select2']) !!}
</div>


<!-- Workflow Type Id Field -->
<div class="form-group col-sm-6">
    {!! Form::label('workflow_type_id', 'Approval Type ') !!}
    {!! Form::select('workflow_type_id',$workFlowTypes, null, ['class' => 'form-control select2']) !!}
</div>

<!-- Weight Field -->
<div class="form-group col-sm-6">
    {!! Form::label('weight', 'Weight:') !!}
    {!! Form::number('weight', null, ['class' => 'form-control']) !!}
</div>

<!-- Submit Field -->
<div class="form-group col-sm-12">
    {!! Form::submit('Save', ['class' => 'btn btn-primary']) !!}
    <a href="{!! route('upesi::approval-stages.index') !!}" class="btn btn-default">Cancel</a>
</div>
