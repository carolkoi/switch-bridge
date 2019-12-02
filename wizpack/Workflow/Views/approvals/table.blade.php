@section('css')
    @include('workflow.layouts.datatables_css')
@endsection

{!! $dataTable->table(['width' => '100%', 'class' => 'table table-striped table-bordered']) !!}

@section('scripts')
    @include('workflow.layouts.datatables_js')
    {!! $dataTable->scripts() !!}
@endsection