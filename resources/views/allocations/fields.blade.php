<fieldset class="col-sm-6"><legend>    {!! Form::label('type', 'Survey Type') !!}</legend>
    <!-- SurveyType Id Field -->

    <div class="form-group">
        {!! Form::label('survey_type_id', 'Type:') !!}
        <select class="form-control select2" name="survey_type_id" id="survey_type_id">
            @foreach($survey_types as $survey_type)
                <option value="{{$survey_type->id}}">{{$survey_type->type}}</option>
            @endforeach
        </select>
    </div>
    <br>
    <!-- Template Id Field -->

    <div class="form-group">
        {!!   Form::select('template_id', [], null, ['id'=>"template_id", 'class' => 'form-control select2']); !!}

    </div>

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
        {!! Form::select('user_id[]', $users, $template->allocations->users('id')->toArray(),
        ['class' => 'form-control select2', 'multiple' => 'multiple'])!!}
    </div>

    <!-- Client Id Field -->

    <div class="form-group" id="client_list">
        {!! Form::label('client_id', 'Clients:') !!}
        {!! Form::select('client_id[]', $clients, $template->allocations->clients,
        ['class' => 'form-control select2', 'multiple' => 'multiple']) !!}
    </div>


    <div class="form-group" id="others_email">
        {!! Form::label('others', 'Add Email:') !!}
        <select class="form-control select2" name="others[]" id="mails" type="email" multiple>
            <option disabled="disabled">-- Add email--</option>
        </select>
    </div>


</fieldset>

<!-- Submit Field -->
<div class="form-group col-sm-12">
    {!! Form::submit('Save', ['class' => 'btn btn-primary']) !!}
    <a href="{!! route('allocations.index') !!}" class="btn btn-default">Cancel</a>
</div>
