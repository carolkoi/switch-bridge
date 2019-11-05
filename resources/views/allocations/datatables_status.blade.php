@if($status)
    <label class="badge label-success"> Approved</label>
@else
    <label class="badge label-success"> Pending</label>
@endif
<br/>
@if($status)
    <a class="btn btn-sm btn-info" href="{{ url('approve-survey',['id'=> $template_id,'action'=>'false']) }}">Reject</a>
@else
    <a class="btn btn-sm btn-info" href="{{ url('approve-survey',['id'=> $template_id,'action'=> 'true']) }}"> Approve </a>
@endif

