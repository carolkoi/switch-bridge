@section('css')
    @include('wizpack::layouts.datatables_css')
@endsection

{!! $dataTable->table(['width' => '100%', 'class' => 'table table-striped table-bordered']) !!}

@section('scripts')
    @include('wizpack::layouts.datatables_js')
    {!! $dataTable->scripts() !!}
    <script>

        jQuery(document).ready(function () {
            var hasBeenSet = 0;
            let table = $('#dataTableBuilder').DataTable({
                retrieve: true,
                ajax: "data.json",
                //});
            }).ajax.url('https://dev.slafrica.net:6810/upesi/approval-partners').load();
                // .ajax.url('https://asgard.slafrica.net:9810/upesi/approval-stages').load();


        });
    </script>
@endsection
