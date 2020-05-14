{{--{!! Form::open(['route' => ['upesi::approvals.destroy', $id], 'method' => 'delete']) !!}--}}
{{--<div class='btn-group'>--}}
@if($approved)
    <a href="{{ route('upesi::approvals.show', $id) }}" class='btn btn-default'>
        View
    </a>
    @else
    <a href="{{ route('upesi::approvals.show', $id) }}" class='btn btn-primary'>
        Approve
    </a>
    @endif

{{--    <a href="{{ route('upesi::approvals.edit', $id) }}" class='btn btn-default btn-sm'>--}}
{{--        <i class="glyphicon glyphicon-edit"></i>--}}
{{--    </a>--}}
{{--    {!! Form::button('<i class="glyphicon glyphicon-trash"></i>', [--}}
{{--        'type' => 'submit',--}}
{{--        'class' => 'btn btn-danger btn-sm',--}}
{{--        'onclick' => "return confirm('Are you sure?')"--}}
{{--    ]) !!}--}}
{{--</div>--}}
{{--{!! Form::close() !!}--}}
