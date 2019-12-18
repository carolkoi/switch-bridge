<div class="card-body">
    <div class="table-responsive">
        <table class="table table-striped table-bordered">
            <thead>
            <th>#</th>
            <th>Questions</th>
            <th>Rating</th>
            <th>Average</th>
            </thead>
            <tbody>
            @php( $count =1 )
            @php( $ave =0 )

            @foreach($responses as $response)

                <tr>
                    <td>#</td>
                    <td> {{$response->question}}</td>
                        <td>
                            @foreach($response->responses as $answer)
                                <table>
                                    <tr>
                                            <td> {{$answer->answer}} </td>
                                        @endforeach
                                    </tr>
                                </table>

                        </td>
                        <td> {{$average / $respondents}} </td>
                </tr>
            @endforeach
            </tbody>

        </table>
    </div>
    {{$responses->links()}}
</div>
