@if($status)
    <label class="badge label-success"> Approved</label>
@else
    <label class="badge label-success"> Pending</label>
@endif
{{--<br/>--}}
{{--@if($status)--}}
{{--    <a class="btn btn-default btn-xs" href="{{ url('approve-survey',['id'=> $id,'action'=>'false']) }}"><i class="glyphicon glyphicon-times"></i></a>--}}
{{--@else--}}
{{--    <a class="btn btn-default btn-xs" href="{{ url('approve-survey',['id'=> $id,'action'=> 'true']) }}"> <i class="glyphicon glyphicon-check"></i> </a>--}}
{{--@endif--}}

