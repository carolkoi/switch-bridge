<!-- Txn Id Field -->
<div class="form-group col-sm-6">
    {!! Form::label('txn_id', 'Txn Id:') !!}
    {!! Form::number('txn_id', null, ['class' => 'form-control']) !!}
</div>

<!-- Orig Txn No Field -->
<div class="form-group col-sm-6">
    {!! Form::label('orig_txn_no', 'Orig Txn No:') !!}
    {!! Form::text('orig_txn_no', null, ['class' => 'form-control']) !!}
</div>

<!-- Appended Txn No Field -->
<div class="form-group col-sm-6">
    {!! Form::label('appended_txn_no', 'Appended Txn No:') !!}
    {!! Form::text('appended_txn_no', null, ['class' => 'form-control']) !!}
</div>

<!-- Txn Status Field -->
<div class="form-group col-sm-6">
    {!! Form::label('txn_status', 'Txn Status:') !!}
    {!! Form::text('txn_status', null, ['class' => 'form-control']) !!}
</div>

<!-- Comments Field -->
<div class="form-group col-sm-6">
    {!! Form::label('comments', 'Comments:') !!}
    {!! Form::text('comments', null, ['class' => 'form-control']) !!}
</div>

<!-- Submit Field -->
<div class="form-group col-sm-12">
    {!! Form::submit('Save', ['class' => 'btn btn-primary']) !!}
    <a href="{{ route('sessionTxns.index') }}" class="btn btn-default">Cancel</a>
</div>
