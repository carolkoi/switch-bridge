@isset($token)
    <input type="hidden" class="form-control" value="{{$token}}" name="survey_uuid">
{{--    {!! Form::hidden('survey_uuid', $token, ['class' => 'form-control']) !!}--}}
    @endisset
@foreach($questions->questions as $question)
    <div class="form-group">

        <label>{{ $count ++}} . {{$question->question}} </label>
        @if($question->type == App\Models\Question::USER_INPUT)
            <input type="text"
                   name="su_{{$questions->id}}_{{$question->id}}_{{$question->type}}"
                   class="form-control" required>
        @endif
        @if($question->type == App\Models\Question::SELECT_ONE)
            <br/>
            <input type="radio" name="su_{{$questions->id}}_{{$question->id}}_{{$question->type}}" value="true" required>
            <label> True</label>
            <br/>
            <input type="radio" name="su_{{$questions->id}}_{{$question->id}}_{{$question->type}}" value="false" required>
            <label> False</label>
        @endif
        @if($question->type == App\Models\Question::SELECT_MULTIPLE)
            @foreach($question->answer as $ans)
                <br/>
                <input type="checkbox" name="su_{{$questions->id}}_{{$question->id}}_{{$question->type}}[]" value="{{ $ans->id }}">
                <label> {{$ans->choice}}</label>
            @endforeach
        @endif
        @if($question->type == App\Models\Question::DATE)
            <input type="text"
                   name="su_{{$questions->id}}_{{$question->id}}_{{$question->type}}"
                   class="form-control" id="date_id" required>
        @endif
        @section('scripts')
            <script type="text/javascript">
                $('#date_id').datetimepicker({
                    format: 'YYYY-MM-DD HH:mm:ss',
                    useCurrent: false
                })
            </script>
        @endsection
        @if($question->type == App\Models\Question::NUMBER)
            <input type="number" min="1"
                   name="su_{{$questions->id}}_{{$question->id}}_{{$question->type}}"
                   class="form-control" required>
        @endif

        @if($question->type == App\Models\Question::DROP_DOWN_LIST)
            <br/>
            <select class="form-control" name="su_{{$questions->id}}_{{$question->id}}_{{$question->type}}" id="dropdown" required>
                @foreach($question->answer as $ans)
                    <br/>
                    <option value="{{ $ans->id }}">{{$ans->choice}}</option>
                @endforeach
            </select>

        @endif
    </div>
@endforeach

@if(count($questions->questions) !== 0 )
    <button type="submit" class="btn btn-sm btn-primary"> submit</button>
@endif

