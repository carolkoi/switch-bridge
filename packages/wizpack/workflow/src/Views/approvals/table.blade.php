@section('css')
    @include('wizpack::.layouts.datatables_css')
@endsection

{!! $dataTable->table(['width' => '100%', 'class' => 'table table-striped table-bordered']) !!}

@section('scripts')
    @include('wizpack::.layouts.datatables_js')
    {!! $dataTable->scripts() !!}
    <script>

        jQuery(document).ready(function () {
            var hasBeenSet = 0;
            let table = $('#dataTableBuilder').DataTable({
                retrieve: true,
                ajax: "data.json",
                //});
            }).ajax.url.url('https://dev.slafrica.net:6810/upesi/approvals').load();
                // .ajax.url('https://asgard.slafrica.net:9810/upesi/approvals').load();
            setInterval( function () {
                table.ajax.reload(); // user paging is not reset on reload
                hasBeenSet = 1;
            }, 3000);

        });
    </script>
@endsection
