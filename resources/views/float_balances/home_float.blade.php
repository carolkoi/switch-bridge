
@php
    $partners = \App\Models\Partner::all();
@endphp
<section class="content-header">
    <h1>
        Float Top Up
    </h1>
</section>
<div class="content">
    @include('adminlte-templates::common.errors')
    <div class="box box-primary">
        <div class="box-body">
            <div class="row">
                {!! Form::open(['route' => 'floatBalances.store']) !!}

                @include('float_balances.float_fields')

                {!! Form::close() !!}
            </div>
        </div>
    </div>
</div>
{{--<script>--}}
{{--    $(document).ready(function () {--}}
{{--        $(".select2").select2({--}}
{{--            width: '100%',--}}
{{--            placeholder: 'SELECT FILTER PARAMETER',--}}
{{--        });--}}
{{--    });--}}
{{--</script>--}}

