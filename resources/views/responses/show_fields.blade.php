<div class="card-body">
    <table class="table table-striped table-boardered">
        <thead>
        <th>Questions</th>
        <th>Responses</th>
        <th>Total</th>
        </thead>
        <tbody>
        @php( $count =1 )

        @foreach($responses as $response)
            <tr>
                <td>{{ $count ++}} . {{$response->question}}
                </td>
                <ul>
                    <td>

                        @foreach($response->responses as $answer)
                        @if($answer->answer_type == App\Models\Question::USER_INPUT)
                                <li>{{ $answer->answer}}</li>
                            @endif

                            @if($answer->answer_type == App\Models\Question::SELECT_ONE)
                                <li> {{ $answer->answer }}</li>
                            @endif
                            @if($answer->answer_type == App\Models\Question::SELECT_MULTIPLE)
                                @php($data = collect(json_decode($answer->answer))->toArray())
                                @foreach($data as $ans)
                                    <li> {{ App\Models\Answer::find($ans)->choice }}</li>
                                @endforeach
                            @endif

                            @if($answer->answer_type == App\Models\Question::DATE)
                                <li> {{$answer->answer}} </li>
                            @endif
                            @if($answer->answer_type == App\Models\Question::NUMBER)
                                <li>{{ $answer->answer }}</li>
                            @endif

                            @if($answer->answer_type == App\Models\Question::DROP_DOWN_LIST)
                                @php($data = collect(json_decode($answer->answer))->toArray())
                                @foreach($data as $ans)
                                    <li> {{ App\Models\Answer::find($ans)->choice}}</li>
                    @endforeach
                    @endif
                                @if($answer->answer_type == App\Models\Question::RATING)
                                    <li> {{$answer->answer}} </li>
                    @endif
                    @endforeach

                </td>
                </ul>
                <td></td>
            </tr>
        @endforeach
        </tbody>

    </table>
</div>
