<div class="card-body">
    <div class="table-responsive">
        <table class="table table-striped table-bordered">
            <thead>
            <th>#</th>
            <th>Questions</th>
            <th>Rating</th>
            <th>Average Per Question</th>
            </thead>
            <tbody>
            @php( $count =1 )
            @php( $ave =0 )

            @foreach($questions as $response)
                <tr>
                    <td>#</td>
                    <td> {{$response->question}}</td>
                    <td>
                        @foreach($response->responses as $answer)
                            <table>
                                <tr>
                                    <td> {{$answer->answer}}</td>
                                </tr>
                            </table>
                        @endforeach

                    </td>
                    <td>
                        @foreach($response->responses as $response)
                            @if ($loop->last)
                                {{ $response->total_responses / $respondents}}
                            @endif

                        @endforeach
                    </td>
                </tr>
            @endforeach
            <tr><td></td><td></td><td></td><td><b>Total Average : {{ $response->total_average / $respondents}}</b></td></tr>
            </tbody>

        </table>
    </div>
{{--    <p><b>Total Average : {{ $response->total_average / $respondents}}</b> </p>--}}
    {{$responses->links()}}
</div>
