<!-- User Id Field -->
<div class="form-group col-sm-6">
    {!! Form::label('user_id', 'User Id:') !!}
    {!! Form::number('user_id', null, ['class' => 'form-control']) !!}
</div>

<!-- Workflow Type Field -->
<div class="form-group col-sm-6">
    {!! Form::label('workflow_type', 'Workflow Type:') !!}
    {!! Form::text('workflow_type', null, ['class' => 'form-control']) !!}
</div>

<!-- Model Id Field -->
<div class="form-group col-sm-6">
    {!! Form::label('model_id', 'Model Id:') !!}
    {!! Form::number('model_id', null, ['class' => 'form-control']) !!}
</div>

<!-- Model Type Field -->
<div class="form-group col-sm-6">
    {!! Form::label('model_type', 'Model Type:') !!}
    {!! Form::text('model_type', null, ['class' => 'form-control']) !!}
</div>

<!-- Collection Name Field -->
<div class="form-group col-sm-6">
    {!! Form::label('collection_name', 'Collection Name:') !!}
    {!! Form::text('collection_name', null, ['class' => 'form-control']) !!}
</div>

<!-- Payload Field -->
<div class="form-group col-sm-12 col-lg-12">
    {!! Form::label('payload', 'Payload:') !!}
    {!! Form::textarea('payload', null, ['class' => 'form-control']) !!}
</div>

<!-- Sent By Field -->
<div class="form-group col-sm-6">
    {!! Form::label('sent_by', 'Sent By:') !!}
    {!! Form::number('sent_by', null, ['class' => 'form-control']) !!}
</div>

<!-- Approved Field -->
<div class="form-group col-sm-6">
    {!! Form::label('approved', 'Approved:') !!}
    <label class="checkbox-inline">
        {!! Form::hidden('approved', 0) !!}
        {!! Form::checkbox('approved', '1', null) !!}
    </label>
</div>


<!-- Approved On Field -->
<div class="form-group col-sm-6">
    {!! Form::label('approved_on', 'Approved On:') !!}
    {!! Form::date('approved_on', null, ['class' => 'form-control','id'=>'approved_on']) !!}
</div>

@section('scripts')
    <script type="text/javascript">
        $('#approved_on').datetimepicker({
            format: 'YYYY-MM-DD HH:mm:ss',
            useCurrent: false
        })
    </script>
@endsection

<!-- Awaiting Stage Id Field -->
<div class="form-group col-sm-6">
    {!! Form::label('awaiting_stage_id', 'Awaiting Stage Id:') !!}
    {!! Form::number('awaiting_stage_id', null, ['class' => 'form-control']) !!}
</div>

<!-- Submit Field -->
<div class="form-group col-sm-12">
    {!! Form::submit('Save', ['class' => 'btn btn-primary']) !!}
    <a href="{!! route('wizpack::approvals.index') !!}" class="btn btn-default">Cancel</a>
</div>
