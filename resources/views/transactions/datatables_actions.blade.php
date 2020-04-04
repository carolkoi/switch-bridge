{{--{!! Form::open(['route' => ['transactions.destroy', $iso_id], 'method' => 'delete']) !!}--}}
<div class='btn-group'>
    <a href="{{ route('transactions.show', $iso_id) }}" class='btn btn-primary btn-sm'>
        <i class="glyphicon glyphicon-eye-open"></i>
    </a>
    <a href="{{ route('transactions.edit', $iso_id) }}" class='btn btn-default btn-sm'>
        <i class="glyphicon glyphicon-edit"></i>
    </a>
{{--    {!! Form::button('<i class="glyphicon glyphicon-trash"></i>', [--}}
{{--        'type' => 'submit',--}}
{{--        'class' => 'btn btn-danger btn-xs',--}}
{{--        'onclick' => "return confirm('Are you sure?')"--}}
{{--    ]) !!}--}}
{{--</div>--}}
{{--{!! Form::close() !!}--}}
