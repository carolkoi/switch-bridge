
<!-- Type Field -->
<div class="form-group col-sm-8">
    {!! Form::label('type', 'Survey Type') !!}
    <br/>
    {!! Form::radio('type', 'survey', true)!!} &nbsp;&nbsp;&nbsp;
    {!! Form::label('type', 'Survey') !!}
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    {!! Form::radio('type', 'poll', false)!!} &nbsp;&nbsp;&nbsp;
    {!! Form::label('type', 'Poll') !!}
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    {!! Form::radio('type', 'feedback', false) !!} &nbsp;&nbsp;&nbsp;
    {!! Form::label('type', 'Feedback') !!}
</div>

<!-- Template Id Field -->
@if(isset($template))
    <div class="form-group col-sm-8">
        {!! Form::label('template_id', 'Survey Type:') !!}
        <select class="form-control" name="template_id" id="template_id" required>
            <option value="{{$template->id}}">{{$template->name}}</option>
        </select>
    </div>
@else
    <div class="form-group col-sm-8">
        {!! Form::label('template_id', 'Survey Type:') !!}
        <select class="form-control" name="template_id" id="template_id" required>
            <option value=''>-- Select --</option>
            @foreach($templates as $template)
                <option value="{{$template->id}}">{{$template->name}}</option>
            @endforeach
        </select>
    </div>
@endif
<!-- User Type Field -->
<div class="form-group col-sm-8">
    {!! Form::label('user_type', 'Send To:') !!}
<br/>
    {!! Form::radio('user_type', 'staff', true)!!} &nbsp;
    {!! Form::label('user_type', 'Staffs') !!}
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    {!! Form::radio('user_type', 'client', false)!!} &nbsp;
    {!! Form::label('user_type', 'Clients') !!}
</div>

<!-- User Id Field -->
<div class="form-group col-sm-6">
    {!! Form::label('user_id', 'Staffs:') !!}
    <select class="form-control" name="user_id[]" id="user_id" multiple>
        <option value='0'>-- Select Staffs --</option>
        @foreach($users as $user)
            <option value="{{$user->id}}">{{$user->first_name.' '.$user->last_name}}</option>
        @endforeach
    </select>
</div>

<!-- Client Id Field -->
<div class="form-group col-sm-6">
    {!! Form::label('client_id', 'Clients:') !!}
    <select class="form-control" name="client_id[]" id="client_id" multiple>
        <option value='0'>-- Select Clients--</option>
        @foreach($clients as $client)
            <option value="{{$client->id}}">{{$client->first_name.' '.$client->last_name}}</option>
        @endforeach
    </select>
</div>



<!-- Submit Field -->
<div class="form-group col-sm-12">
    {!! Form::submit('Save', ['class' => 'btn btn-primary']) !!}
    <a href="{!! route('allocations.index') !!}" class="btn btn-default">Cancel</a>
</div>
