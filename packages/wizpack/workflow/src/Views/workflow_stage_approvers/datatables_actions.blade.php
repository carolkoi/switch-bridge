{!! Form::open(['route' => ['upesi::stage-approvers.destroy', $id], 'method' => 'delete']) !!}
<div class='btn-group'>
{{--    <a href="{{ route('upesi::stage-approvers.show', $id) }}" class='btn btn-default btn-xs'>--}}
{{--        <i class="glyphicon glyphicon-eye-open"></i>--}}
{{--    </a>--}}
    <a href="{{ route('upesi::stage-approvers.edit', $id) }}" class='btn btn-default btn-sm'>
        <i class="glyphicon glyphicon-edit"></i>
    </a>
    {!! Form::button('<i class="glyphicon glyphicon-trash"></i>', [
        'type' => 'submit',
        'class' => 'btn btn-danger btn-sm',
        'onclick' => "return confirm('Are you sure?')"
    ]) !!}
</div>
{!! Form::close() !!}
