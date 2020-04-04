{{--{!! Form::open(['route' => ['companies.destroy', $companyid], 'method' => 'delete']) !!}--}}
<div class='btn-group'>
    <a href="{{ route('companies.show', $companyid) }}" class='btn btn-primary btn-sm'>
        <i class="glyphicon glyphicon-eye-open"></i>
    </a>
    <a href="{{ route('companies.edit', $companyid) }}" class='btn btn-default btn-sm'>
        <i class="glyphicon glyphicon-edit"></i>
    </a>
{{--    {!! Form::button('<i class="glyphicon glyphicon-trash"></i>', [--}}
{{--        'type' => 'submit',--}}
{{--        'class' => 'btn btn-danger btn-xs',--}}
{{--        'onclick' => "return confirm('Are you sure?')"--}}
{{--    ]) !!}--}}
{{--</div>--}}
{{--{!! Form::close() !!}--}}
