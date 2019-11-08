
@isset($token)
    <input type="hidden" class="form-control" value="{{$token}}" name="survey_uuid">
@endisset
{{--@isset($templateID)--}}
{{--    <input type="hidden" class="form-control" value="{{$templateID}}" name="template_id">--}}
{{--@endisset--}}

@foreach($questions->questions as $question)
    <div class="form-group">

        <label>{{ $count ++}} . {{$question->question}} </label>
        @if($question->type == App\Models\Question::USER_INPUT)
            <input type="text" {{($question->status == 1) ? 'required="required"' : ''}}
                   name="su_{{$questions->id}}_{{$question->id}}_{{$question->type}}"
                   class="form-control">
        @endif
        @if($question->type == App\Models\Question::SELECT_ONE)
            <br/>
            <input type="radio" name="su_{{$questions->id}}_{{$question->id}}_{{$question->type}}" value="true">
            <label> True</label>
            <br/>
            <input type="radio" name="su_{{$questions->id}}_{{$question->id}}_{{$question->type}}" value="false">
            <label> False</label>
        @endif
        @if($question->type == App\Models\Question::SELECT_MULTIPLE)
            @foreach($question->answer as $ans)
                <br/>
                <input type="checkbox" name="su_{{$questions->id}}_{{$question->id}}_{{$question->type}}[]" value="{{ $ans->id }}"
                    {{($question->status == 1) ? 'required="required"' : ''}}>
                <label> {{$ans->choice}}</label>
            @endforeach
        @endif
        @if($question->type == App\Models\Question::DATE)
            <input type="text"
                   name="su_{{$questions->id}}_{{$question->id}}_{{$question->type}}"
                   class="form-control" id="date_id" {{($question->status == 1) ? 'required="required"' : ''}}>
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
                   class="form-control" {{($question->status == 1) ? 'required="required"' : ''}}>
        @endif

        @if($question->type == App\Models\Question::DROP_DOWN_LIST)
            <br/>
            <select class="form-control" name="su_{{$questions->id}}_{{$question->id}}_{{$question->type}}" id="dropdown" {{($question->status == 1) ? 'required="required"' : ''}}>
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

