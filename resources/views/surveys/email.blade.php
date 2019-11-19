@component('mail::message')
    # Dear Sir / Madam,
<p>{!! $templateEmailMsg !!} </p>

@component('mail::button', ['url' => url('survey-response/'.$templateID.'/'.$token)])
Take Survey
@endcomponent

Thanks,<br>
{{ config('app.name') }}
@endcomponent
