<!DOCTYPE html>
<html>
<head>
</head>
<body>

<center>
    <h2 style="padding: 23px;background: #b3deb8a1;border-bottom: 6px green solid;">
        <a href="http://esl-survey.test">ESL-SURVEY</a>
    </h2>
</center>

<p>Dear Sir / Madam</p>
<p>{{ $templateEmailMsg }}</p>
{{$token}}

<p><a  href="{{ url('survey-response',['id'=> $templateID, 'token' => $token])}}" class="btn btn-sm btn-info"> Take Survey </a></p>

<strong>Thank you. :)</strong>

</body>
</html>
