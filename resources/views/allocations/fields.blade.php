<fieldset class="col-sm-6"><legend>    {!! Form::label('type', 'Survey Type') !!}</legend>
    <!-- SurveyType Id Field -->

    <div class="form-group">
        {!! Form::label('survey_type_id', 'Type:') !!}
        {!! Form::select('survey_type_id', $survey_type, isset($allocation) ? $allocation['survey_type_id'] : null, ['class' => 'form-control select2']) !!}
    </div>
    <br>
    <!-- Template Id Field -->
@if(isset($allocation))
        <div class="form-group">
            {!!   Form::select('template_id', $templates, $allocation['template_id'], ['id'=>"template_id", 'class' => 'form-control select2']); !!}
        </div>
    @else
        <div class="form-group">
            {!!   Form::select('template_id', [], null, ['id'=>"template_id", 'class' => 'form-control select2']); !!}

        </div>
    @endif


</fieldset>

<fieldset class="col-sm-6"><legend>{!! Form::label('user_type', 'Send To:') !!}</legend>
    <!-- User Type Field -->
    <div class="form-group">

        {!! Form::radio('user_type', 'staff', true, ['id' =>'staff'])!!} &nbsp;
        {!! Form::label('user_type', 'Staffs') !!}
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        {!! Form::radio('user_type', 'client', false, ['id' =>'client'])!!} &nbsp;
        {!! Form::label('user_type', 'Clients') !!}
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

        {!! Form::radio('user_type', 'others', false, ['id' =>'others'])!!} &nbsp;
        {!! Form::label('user_type', 'Others') !!}
    </div>

    <!-- User Id Field -->

    <div class="form-group">
        {!! Form::label('user_id', 'Staffs:') !!}
        {!! Form::select('user_id[]', $users, isset($allocation['selected_users'])?$allocation['selected_users']:null,
        ['class' => 'form-control select2', 'multiple' => 'multiple'])!!}
    </div>

    <!-- Client Id Field -->

    <div class="form-group" id="client_list">
        {!! Form::label('client_id', 'Clients:') !!}
        {!! Form::select('client_id[]', $clients, isset($allocation['selected_clients'])?$allocation['selected_clients']:null,
        ['class' => 'form-control select2', 'multiple' => 'multiple']) !!}
    </div>

    @if(isset($allocation))
        <div class="form-group" id="others_email">
            {!! Form::label('others', 'Add Email:') !!}
            {!! Form::select('others[]', $allocation['selected_mails'], $allocation['selected_mails'],
        ['class' => 'form-control select2', 'multiple' => 'multiple', 'id' => 'mails']) !!}
        </div>
        @else
        <div class="form-group" id="others_email">
            {!! Form::label('others', 'Add Email:') !!}
            {!! Form::select('others[]', [], null,
        ['class' => 'form-control select2', 'multiple' => 'multiple', 'id' => 'mails']) !!}
        </div>
        @endif





</fieldset>

<!-- Submit Field -->
<div class="form-group col-sm-12">
    {!! Form::submit('Save', ['class' => 'btn btn-primary']) !!}
    <a href="{!! route('allocations.index') !!}" class="btn btn-default">Cancel</a>
</div>
