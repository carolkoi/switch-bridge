{!! Form::open(['route' => ['templates.destroy', $id], 'method' => 'delete']) !!}
<div class='btn-group'>
    <a href="{{ route('templates.show', $id) }}" class='btn btn-default btn-sm'>
        <i class="glyphicon glyphicon-eye-open"></i>
    </a>
    <a href="{{ route('templates.edit', $id) }}" class='btn btn-default btn-sm'>
        <i class="glyphicon glyphicon-edit"></i>
    </a>
    {!! Form::button('<i class="glyphicon glyphicon-trash"></i>', [
        'type' => 'submit',
        'class' => 'btn btn-danger btn-sm',
        'onclick' => "return confirm('Are you sure?')"
    ]) !!}
</div>
{!! Form::close() !!}
{{--<br>--}}
{{--<a href="{{route('survey.preview',$id)}}" class='btn btn-primary pull-left'>Preview</a>--}}
