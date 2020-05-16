@section('css')
    @include('layouts.datatables_css')
@endsection

{!! $dataTable->table(['width' => '100%', 'class' => 'table table-striped table-bordered', 'data-page-size'=>'50']) !!}

@section('scripts')
    @include('layouts.datatables_js')
    {!! $dataTable->scripts() !!}
    <script>
        jQuery(document).ready(function () {
        let table = $('#dataTableBuilder').DataTable( {
            retrieve: true,
            ajax: "data.json",
            paging: true,
            info: false,
            scrollY: 400,
            "pageLength": 100,
            "iDisplayLength": 100,
            "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]]

        } );

        setInterval( function () {
            table.ajax.reload(null, false); // user paging is not reset on reload
        }, 10000 );
        });
    </script>

@endsection
