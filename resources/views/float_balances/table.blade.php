@section('css')
    @include('layouts.datatables_css')
@endsection

{!! $dataTable->table(['width' => '100%', 'class' => 'table table-striped table-bordered']) !!}

@section('scripts')
    @include('layouts.datatables_js')
    {!! $dataTable->scripts() !!}
    <script>
        jQuery(document).ready(function () {
                let table = $('#dataTableBuilder').DataTable({
                    retrieve: true,
                    responsive: true,
                    ajax: "data.json",
                    //});
                }).ajax.url('https://asgard.slafrica.net:9810/floatBalances').load();
            // 'https://asgard.slafrica.net:9810/floatBalances'
        });
    </script>

@endsection
