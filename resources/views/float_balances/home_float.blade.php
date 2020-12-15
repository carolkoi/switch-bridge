<section class="content-header">
    <h1>
        Float Balance
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
