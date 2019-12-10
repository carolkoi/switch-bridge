{{--<fieldset class="col-md-6" style="border:1px solid; padding: 5px;  border-color: #e5e5e5">--}}
{{--    <legend>Survey Details</legend>--}}
    <!-- Template Id Field -->
    <div class="form-group">
        {!! Form::label('template_id', 'Survey:') !!}
        <p>{!! $template->name !!}</p>
    </div>

    <div class="form-group">
        {!! Form::label('template_id', 'Timeline:') !!}
        <p>{!!date('d-m-Y', strtotime($template->valid_from)). ' to ' .date('d-m-Y', strtotime($template->valid_until))!!}</p>
    </div>
    <div class="form-group">
        {!! Form::label('template_id', 'Created By:') !!}
        <p>{!!$user->name!!}</p>
    </div>

{{--</fieldset>--}}



