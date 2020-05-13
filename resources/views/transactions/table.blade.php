@section('css')
    @include('layouts.datatables_css')
@endsection

{!! $dataTable->table(['width' => '100%', 'class' => 'table table-striped table-bordered']) !!}

@section('scripts')
    @include('layouts.datatables_js')
    {!! $dataTable->scripts() !!}
    <script>
        let table = $('#dataTableBuilder').DataTable( {
            retrieve: true,
            scrollY: 300,
            paging: false,
            select: true,
            ajax: "data.json"
        } );

        setInterval( function () {
            table.ajax.reload( null, false ); // user paging is not reset on reload
        }, 10000 );
    </script>

@endsection
