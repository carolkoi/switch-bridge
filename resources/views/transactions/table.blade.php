@section('css')
    @include('layouts.datatables_css')
@endsection

{!! $dataTable->table(['width' => '100%', 'class' => 'table table-striped table-bordered', 'data-page-length' => '50', 'data-page-size' => '50']) !!}

@section('js')
    @include('layouts.datatables_js')
    {!! $dataTable->scripts() !!}
    <script>
        jQuery(document).ready(function () {
        let table = $('#dataTableBuilder').DataTable({
            "processing": true, //process it
            "serverSide": true, //make it server side
            "pageLength": 50,
            "iDisplayLength": 50,
            retrieve: true,
            ajax: "data.json"
        });

        //     setInterval( function () {
        //     table.ajax.reload(); // user paging is not reset on reload
        // }, 10000 );
        });
    </script>

@endsection

