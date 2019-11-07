{{--{!! Form::open(['route' => ['surveyReports.destroy', $id], 'method' => 'delete']) !!}--}}
{{--<div class='btn-group'>--}}
    <a href="{{ route('surveyReports.show', $template_id) }}" class='btn btn-default btn-info'>
        <i class="glyphicon glyphicon-eye-open"></i>
    </a>
{{--    <a href="{{ route('surveyReports.edit', $id) }}" class='btn btn-default btn-xs'>--}}
{{--        <i class="glyphicon glyphicon-edit"></i>--}}
{{--    </a>--}}
{{--    {!! Form::button('<i class="glyphicon glyphicon-trash"></i>', [--}}
{{--        'type' => 'submit',--}}
{{--        'class' => 'btn btn-danger btn-xs',--}}
{{--        'onclick' => "return confirm('Are you sure?')"--}}
{{--    ]) !!}--}}
</div>
{!! Form::close() !!}
