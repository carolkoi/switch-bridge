{!! Form::open(['route' => ['upesi::approval-partners.destroy', $id], 'method' => 'delete']) !!}
<div class='btn-group'>
{{--    <a href="{{ route('upesi::approval-partners.show', $id) }}" class='btn btn-default btn-xs'>--}}
{{--        <i class="glyphicon glyphicon-eye-open"></i>--}}
{{--    </a>--}}
    <a href="{{ route('upesi::approval-partners.edit', $id) }}" class='btn btn-default btn-sm'>
        <i class="glyphicon glyphicon-edit"></i>
    </a>
    {!! Form::button('<i class="glyphicon glyphicon-trash"></i>', [
        'type' => 'submit',
        'class' => 'btn btn-danger btn-sm',
        'onclick' => "return confirm('Are you sure?')"
    ]) !!}
</div>
{!! Form::close() !!}
