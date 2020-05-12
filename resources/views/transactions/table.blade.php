@section('css')
    @include('layouts.datatables_css')
@endsection

{!! $dataTable->table(['width' => '100%', 'class' => 'table table-bordered']) !!}

@section('scripts')
    @include('layouts.datatables_js')
    {!! $dataTable->scripts() !!}
    <script>
        let table = $('#dataTableBuilder').DataTable( {
            retrieve: true,
            paging: false,
            ajax: "data.json"
        } );

        setInterval( function () {
            table.ajax.reload( null, false ); // user paging is not reset on reload
        }, 10000 );
        // $('#dataTableBuilder').DataTable().ajax.reload(null, false);
    </script>

@endsection
