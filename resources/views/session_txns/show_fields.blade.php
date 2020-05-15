<!-- Txn Id Field -->
<div class="form-group">
    {!! Form::label('txn_id', 'Txn Id:') !!}
    <p>{{ $sessionTxn->txn_id }}</p>
</div>

<!-- Orig Txn No Field -->
<div class="form-group">
    {!! Form::label('orig_txn_no', 'Orig Txn No:') !!}
    <p>{{ $sessionTxn->orig_txn_no }}</p>
</div>

<!-- Appended Txn No Field -->
<div class="form-group">
    {!! Form::label('appended_txn_no', 'Appended Txn No:') !!}
    <p>{{ $sessionTxn->appended_txn_no }}</p>
</div>

<!-- Txn Status Field -->
<div class="form-group">
    {!! Form::label('txn_status', 'Txn Status:') !!}
    <p>{{ $sessionTxn->txn_status }}</p>
</div>

<!-- Comments Field -->
<div class="form-group">
    {!! Form::label('comments', 'Comments:') !!}
    <p>{{ $sessionTxn->comments }}</p>
</div>

