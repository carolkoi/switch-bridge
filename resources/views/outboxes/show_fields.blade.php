<!-- Messageid Field -->
<div class="form-group">
    {!! Form::label('messageid', 'Messageid:') !!}
    <p>{{ $outbox->messageid }}</p>
</div>

<!-- Messagetypeid Field -->
<div class="form-group">
    {!! Form::label('messagetypeid', 'Messagetypeid:') !!}
    <p>{{ $outbox->messagetypeid }}</p>
</div>

<!-- Messagestatus Field -->
<div class="form-group">
    {!! Form::label('messagestatus', 'Messagestatus:') !!}
    <p>{{ $outbox->messagestatus }}</p>
</div>

<!-- Messagepriority Field -->
<div class="form-group">
    {!! Form::label('messagepriority', 'Messagepriority:') !!}
    <p>{{ $outbox->messagepriority }}</p>
</div>

<!-- Datetimesent Field -->
<div class="form-group">
    {!! Form::label('datetimesent', 'Datetimesent:') !!}
    <p>{{ $outbox->datetimesent }}</p>
</div>

<!-- Datetimeadded Field -->
<div class="form-group">
    {!! Form::label('datetimeadded', 'Datetimeadded:') !!}
    <p>{{ $outbox->datetimeadded }}</p>
</div>

<!-- Addedby Field -->
<div class="form-group">
    {!! Form::label('addedby', 'Addedby:') !!}
    <p>{{ $outbox->addedby }}</p>
</div>

<!-- Ipaddress Field -->
<div class="form-group">
    {!! Form::label('ipaddress', 'Ipaddress:') !!}
    <p>{{ $outbox->ipaddress }}</p>
</div>

<!-- Attempts Field -->
<div class="form-group">
    {!! Form::label('attempts', 'Attempts:') !!}
    <p>{{ $outbox->attempts }}</p>
</div>

<!-- Record Version Field -->
<div class="form-group">
    {!! Form::label('record_version', 'Record Version:') !!}
    <p>{{ $outbox->record_version }}</p>
</div>

