<div class="card-body">
    <table class="table table-striped table-boardered">
        <thead>
        <th>#</th>
        <th>Questions</th>
        <th>Responses</th>
        <th>Total</th>
        </thead>
        <tbody>
        @php( $count =1)
        @php($que_count =1)
        {{--        <tr><td>Respondent : {{ $count ++}}</td></tr>--}}
        @foreach($responses as $response)
        <tr>
            <td>{{ $count++}}</td>
            <td>
                <div class="row">
                    <div class="col-md-6">
                        {{$response->question->question}}</div>
                </div>

            </td>
            <td>
                <div class="row">
                    <div class="col-md-6">
                        {{$response->answer}}</div>
                </div>
            </td>

            {{--<td>--}}
                {{--                        @foreach($response->question->responses as $answer)--}}
                {{--                        @if($answer->answer_type == App\Models\Question::USER_INPUT)--}}
                {{--                                {{ $answer->answer}}--}}
                {{--                            @endif--}}

                {{--                            @if($answer->answer_type == App\Models\Question::SELECT_ONE)--}}
                {{--                                 {{ $answer->answer }}--}}
                {{--                            @endif--}}
                {{--                            @if($answer->answer_type == App\Models\Question::SELECT_MULTIPLE)--}}
                {{--                                @php($data = collect(json_decode($answer->answer))->toArray())--}}
                {{--                                @foreach($data as $ans)--}}
                {{--                                     {{ App\Models\Answer::find($ans)->choice }}--}}
                {{--                                @endforeach--}}
                {{--                            @endif--}}

                {{--                            @if($answer->answer_type == App\Models\Question::DATE)--}}
                {{--                                 {{$answer->answer}}--}}
                {{--                            @endif--}}
                {{--                            @if($answer->answer_type == App\Models\Question::NUMBER)--}}
                {{--                                {{ $answer->answer }}--}}
                {{--                            @endif--}}

                {{--                            @if($answer->answer_type == App\Models\Question::DROP_DOWN_LIST)--}}
                {{--                                @php($data = collect(json_decode($answer->answer))->toArray())--}}
                {{--                                @foreach($data as $ans)--}}
                {{--                                     {{ App\Models\Answer::find($ans)->choice}}--}}
                {{--                    @endforeach--}}
                {{--                    @endif--}}
                {{--                                @if($answer->answer_type == App\Models\Question::RATING)--}}
                {{--                                     {{$answer->answer}}--}}
                {{--                    @endif--}}
                {{--                    @endforeach--}}

                {{--                </td>--}}
            <td>{{$response->total}}</td>
        </tr>
        @endforeach
        </tbody>

    </table>
</div>
