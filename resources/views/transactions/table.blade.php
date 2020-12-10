@php
    header("Access-Control-Allow-Origin: *");
    header("Access-Control-Allow-Credentials: true ");
    header("Access-Control-Allow-Methods: OPTIONS, GET, POST");
    header("Access-Control-Allow-Headers: Content-Type, Depth, User-Agent, X-File-Size, X-Requested-With, If-Modified-Since, X-File-Name, Cache-Control");
@endphp
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
        {{--    let table = $('#dataTableBuilder').DataTable({--}}
        {{--        retrieve: true,--}}
        {{--        ajax: "data.json",--}}
        {{--        processing: true,--}}
        {{--        serverSide: true,--}}
        {{--        deferLoading: 57--}}
        {{--        //});--}}
        {{--    }).ajax.url('{{ url("all/transactions") }}').load();--}}

            setTimeout(function(){
                let table = $('#dataTableBuilder').DataTable({
                    retrieve: true,
                    responsive: true,
                    ajax: "data.json",
                    //});
                });
            }, 5000).ajax.url('{{ url("all/transactions") }}');

            setInterval( function () {
                table.ajax.reload(); // user paging is not reset on reload
                hasBeenSet = 1;
            }, 30000);
            //}, 60000);
        });
    </script>

@endsection

