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
                ajax: "data.json",
                //});
            }).ajax.url('https://dev.slafrica.net:6810/members/users').load();


        });
    </script>

@endsection

