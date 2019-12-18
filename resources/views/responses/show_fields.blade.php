<div class="card-body">
    <div class="table-responsive">
    <table class="table table-striped table-bordered">
        <thead>
        <th>#</th>
        <th>Questions</th>
        <th>Responses</th>
{{--        <th>Total</th>--}}
        </thead>
        <tbody>
        @php( $count =1 )

        @foreach($responses as $response)

            <tr>
                <td>#</td>
                <td> {{$response->question}}
                </td>
                    <td>

                        @foreach($response->responses as $answer)
                            <table>
                                <tr>


                            @if($answer->answer_type == App\Models\Question::USER_INPUT)
                                <td>{{ $answer->answer}}</td>
                            @endif

                            @if($answer->answer_type == App\Models\Question::SELECT_ONE)
                                <td> {{ $answer->answer }}</td>
                            @endif
                            @if($answer->answer_type == App\Models\Question::SELECT_MULTIPLE)
                                @php($data = collect(json_decode($answer->answer))->toArray())
                                @foreach($data as $ans)

                                            <td>{{ App\Models\Answer::find($ans)->choice }}{{' '.','.' '}}</td>

                                    @endforeach
                                    <br>

                                @endif

                            @if($answer->answer_type == App\Models\Question::DATE)
                                <td> {{$answer->answer}} </td>
                            @endif
                            @if($answer->answer_type == App\Models\Question::NUMBER)
                                <li>{{ $answer->answer }}</li>
                            @endif

                            @if($answer->answer_type == App\Models\Question::DROP_DOWN_LIST)
                                @php($data = collect(json_decode($answer->answer))->toArray())
                                @foreach($data as $ans)

                                        <td>{{ App\Models\Answer::find($ans)->choice }}</td>

                                @endforeach
                                <br>
                            @endif

                        @endforeach
                                </tr>
                            </table>

                    </td>

                <td></td>
            </tr>
        @endforeach
        </tbody>

    </table>
    </div>
    {{$responses->links()}}
</div>

