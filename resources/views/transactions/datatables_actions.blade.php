{{--{!! Form::open(['route' => ['transactions.destroy', $iso_id], 'method' => 'delete']) !!}--}}
@if($res_field48 === "COMPLETED")
<div class='btn-group'>
    <a href="{{ route('transactions.show', $iso_id) }}" class='btn btn-primary'>
        Show
    </a>
{{--    <a href="{{ route('transactions.edit', $iso_id) }}" class='btn btn-default btn-sm'>--}}
{{--        <i class="glyphicon glyphicon-edit"></i>--}}
{{--    </a>--}}
{{--    {!! Form::button('<i class="glyphicon glyphicon-trash"></i>', [--}}
{{--        'type' => 'submit',--}}
{{--        'class' => 'btn btn-danger btn-xs',--}}
{{--        'onclick' => "return confirm('Are you sure?')"--}}
{{--    ]) !!}--}}
</div>

{{--{!! Form::close() !!}--}}
@else
<div class="btn-group btn-hspace">
    <button class="btn btn-secondary dropdown-toggle" type="button" data-toggle="dropdown">Action <span class="icon-dropdown mdi mdi-chevron-down"></span></button>
    <div class="dropdown-menu" role="menu">
        <a class="dropdown-item" href="{{ route('transactions.show', $iso_id) }}">View</a>
        <div class="dropdown-divider"></div>
        <div class="dropdown-divider"></div>
        <a class="dropdown-item" href="{{route('transactions.edit', $iso_id) }}">Edit</a>
        <div class="dropdown-divider"></div>
        <div class="dropdown-divider"></div>
        <a class="dropdown-item" href="#">Separated link</a>
    </div>
</div>
    @endif
