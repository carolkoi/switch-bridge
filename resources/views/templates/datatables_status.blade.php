@if($status)
    <label class="badge label-success"> Approved</label>
@else
    <label class="badge label-success"> Pending</label>
@endif
{{--<br/>--}}
{{--@if($status)--}}
{{--    <a class="btn btn-sm btn-info" href="{{ url('template-status',['id'=> $id,'action'=>'false']) }}">Diactivate</a>--}}
{{--@else--}}
{{--    <a class="btn btn-sm btn-info" href="{{ url('template-status',['id'=> $id,'action'=> 'true']) }}"> Activate </a>--}}
{{--@endif--}}
