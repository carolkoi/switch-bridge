
<div class='btn-group'>
    <a href="{{ route('aml-listing.show', $blacklist_id) }}" class='btn btn-primary btn-sm'>
        <i class="glyphicon glyphicon-eye-open"></i>
    </a>
{{--<br/>--}}
    @if(Auth::check() && auth()->user()->can('Can Add / Import Blacklist Records'))
    <a href="{{ route('aml-listing.edit', $blacklist_id) }}" class='btn btn-default btn-sm'>
        <i class="glyphicon glyphicon-edit"></i>
    </a>
    @endif

</div>
