@section('css')
    @include('wizpack::.layouts.datatables_css')
@endsection

{!! $dataTable->table(['width' => '100%', 'class' => 'table table-striped table-bordered']) !!}

@section('scripts')
    @include('wizpack::.layouts.datatables_js')
    {!! $dataTable->scripts() !!}
@endsection