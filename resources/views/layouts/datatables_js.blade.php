<!-- Datatables -->
@if(\App\Helpers::getEnv() == "local")
    <script src="{{ URL::asset('DataTables/js/jquery.dataTables.min.js') }}"></script>
    <script src="{{ URL::asset('DataTables/js/dataTables.bootstrap.min.js') }}"></script>
    <script src="{{ URL::asset('DataTables/js/dataTables.buttons.min.js') }}"></script>
    <script src="{{ URL::asset('DataTables/js/buttons.bootstrap.min.js') }}"></script>
    <script src="{{ URL::asset('DataTables/js/buttons.colVis.min.js') }}"></script>
    <script src="{{ URL::asset('vendor/datatables/buttons.server-side.js') }}"></script>
    @else
    <script src="{{secure_asset('DataTables/js/jquery.dataTables.min.js') }}"></script>
    <script src="{{ secure_asset('DataTables/js/dataTables.bootstrap.min.js') }}"></script>
    <script src="{{ secure_asset('DataTables/js/dataTables.buttons.min.js') }}"></script>
    <script src="{{ secure_asset('DataTables/js/buttons.bootstrap.min.js') }}"></script>
    <script src="{{ secure_asset('DataTables/js/buttons.colVis.min.js') }}"></script>
    <script src="{{ secure_asset('vendor/datatables/buttons.server-side.js') }}"></script>
    @endif

