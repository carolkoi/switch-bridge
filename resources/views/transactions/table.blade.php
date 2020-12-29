
@section('css')
    @include('layouts.datatables_css')

@endsection

<div class="loader"></div>


{!! $dataTable->table(['width' => '100%', 'class' => 'table table-striped table-bordered', 'data-page-length' => '50', 'data-page-size' => '50']) !!}

@section('scripts')
    @include('layouts.datatables_js')
    {!! $dataTable->scripts() !!}
    <script>
        jQuery(document).ready(function () {
        // var hasBeenSet = 0;
            let table = $('#dataTableBuilder').DataTable({
                retrieve: true,
                ajax: "data.json",
                processing: true,
                serverSide: true,
                //});
            }).ajax.url('https://asgard.slafrica.net:9810/all/transactions').load();
                // .ajax.url('https://asgard.slafrica.net:9810/all/transactions').load();
                // .ajax.url('https://asgard.slafrica.net:9810/all/transactions').load();
            setInterval( function () {
                table.ajax.reload(); // user paging is not reset on reload
                hasBeenSet = 1;
            }, 60000);
            //}, 60000);
        });
    </script>

@endsection

