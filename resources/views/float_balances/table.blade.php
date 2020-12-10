@section('css')
    @include('layouts.datatables_css')
@endsection

{!! $dataTable->table(['width' => '100%', 'class' => 'table table-striped table-bordered']) !!}

@section('scripts')
    @include('layouts.datatables_js')
    {!! $dataTable->scripts() !!}
    <script>
        jQuery(document).ready(function () {
            // var hasBeenSet = 0;
            let table = $('#dataTableBuilder').DataTable({
                retrieve: true,
                ajax: "data.json",
                //});
            }).ajax.url('{{ url("floatBalances") }}');

            // setTimeout(function(){
            //     $('#data-table').DataTable( {
            //         responsive: true
            //     } );
            // }, 5000);
            //alert( 'Data source: '+table.ajax.url() );
            setInterval( function () {
                table.ajax.reload(); // user paging is not reset on reload
                hasBeenSet = 1;
            }, 15000);
            //}, 60000);
        });
    </script>

@endsection
