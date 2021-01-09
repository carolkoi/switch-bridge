@section('css')
    @include('layouts.datatables_css')

@endsection

<div class="loader"></div>

{{--    <div class="box-body">--}}

<div class="table-responsive">
    <table class="table table-striped table-hover table-bordered table-fw-widget table no-margin" id="user-table">
        <thead>
        <tr>
            <th>Company</th>
            <th>role</th>
            <th>name</th>
            <th>email</th>
            <th>Action</th>

        </tr>
        </thead>

    </table>

</div>

@section('scripts')
    @include('layouts.datatables_js')
    <script>
        $(document).ready(function() {

            let table = $('#user-table').DataTable({
                processing: true,
                serverSide: true,
                pageLength: 30,
                retrieve: true,
                paginate: true,
                bPaginate: true,
                bStateSave: true,
                ajax: "{{  route('users.index')  }}",
                {{--ajax:{--}}
                {{--    url: "{{ route('users.index') }}",--}}
                {{--},--}}

                // buttons:['excel'],
                buttons: ['csv', 'excel', 'pdf', 'print', 'reset', 'reload'],
                columns: [
                    // {data: 'DT_RowIndex', name: 'DT_RowIndex'},
                    {data: 'company', name: 'company.companyname'},
                    // {data: 'req_field7', name: 'req_field7'},
                    {data: 'role', name: 'role'},
                    {data: 'name', name: 'name'},
                    {data: 'email', name: 'email'},

                    {data: 'action', name: 'action', orderable: false, searchable: false},
                ],
                dom: 'Bfrtip',
                buttons: [
                    'copy', 'csv', 'excel', 'pdf', 'print'
                ],
                'lengthMenu': [
                    [10, 25, 50, -1],
                    ['10 rows', '25 rows', '50 rows', 'Show all']
                ],
                "dom": "<'row'<'col-md-4 col-sm-12'<'pull-left'f>><'col-md-8 col-sm-12'<'table-group-actions pull-right'B>>r><'table-container't><'row'<'col-md-12 col-sm-12'pli>>", // datatable layout
                // "pagingType": "bootstrap_extended",
                "renderer": "bootstrap",
                "searchDelay": 800,
                "bDeferRender": true,
                "autoWidth": false, // disable fixed width and enable fluid table
                "language": { // language settings
                    "lengthMenu": "<span class='dt-length-style'><i class='fa fa-bars'></i> &nbsp;View &nbsp;&nbsp;_MENU_ &nbsp;records&nbsp;&nbsp; </span>",
                    "info": "<span class='dt-length-records'><i class='fa fa-globe'></i> &nbsp;Found&nbsp;<span class='badge bold badge-dt'>_TOTAL_</span>&nbsp;total records </span>",
                    "infoEmpty": "<span class='dt-length-records'>No records found to show</span>",
                    "emptyTable": "No data available in table",
                    "infoFiltered": "<span class=' '>(filtered from <span class='badge bold badge-dt'>_MAX_</span> total records)</span>",
                    "zeroRecords": "No matching records found",
                    "search": "<i class='fa fa-search'></i>",
                    "paginate": {
                        "previous": "Prev",
                        "next": "Next",
                        "last": "Last",
                        "first": "First",
                        "page": "<span class=' '><i class='fa fa-eye'></i> &nbsp;Page&nbsp;&nbsp;</span>",
                        "pageOf": "<span class=' '>&nbsp;of&nbsp;</span>"
                    },
                    "sProcessing": "Please wait..."
                },

            });



        } );
    </script>
@endsection
