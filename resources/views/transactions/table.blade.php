@section('css')
    @include('layouts.datatables_css')
@endsection

{!! $dataTable->table(['width' => '100%', 'class' => 'table table-striped table-bordered', 'data-page-length'=>'25']) !!}

@section('scripts')
    @include('layouts.datatables_js')
    {!! $dataTable->scripts() !!}
    <script>
        jQuery(document).ready(function() {
            let table = $('#dataTableBuilder').DataTable( {
            retrieve: true,
                "paging":   false,
                "info":     false,
            ajax: "data.json"
        } );

        setInterval( function () {
            table.ajax.reload(); // user paging is not reset on reload
        }, 10000 );
        });
    </script>

@endsection
