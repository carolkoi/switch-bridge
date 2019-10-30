<!DOCTYPE html>
<html>
<head>
    <title>How to send mail using queue in Laravel 5.7? - ItSolutionStuff.com</title>
</head>
<body>

<center>
    <h2 style="padding: 23px;background: #b3deb8a1;border-bottom: 6px green solid;">
        <a href="http://esl-survey.test">ESL-SURVEY</a>
    </h2>
</center>

<p>Dear Sir / Madam</p>
<p>{{ $templateEmailMsg }}</p>

<p><a  href="{{ url('template',['id'=> $templateID])}}" class="btn btn-sm btn-info"> Take Survey </a></p>

<strong>Thank you. :)</strong>

</body>
</html>
