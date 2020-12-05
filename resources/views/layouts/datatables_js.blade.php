<!-- Datatables -->
@if(\App\Helpers::getEnv() == "local")
    <script src="{{ URL::asset('DataTables/js/jquery.dataTables.min.js') }}"></script>
    <script src="{{ URL::asset('DataTables/js/dataTables.bootstrap.min.js') }}"></script>
    <script src="{{ URL::asset('DataTables/js/dataTables.buttons.min.js') }}"></script>
    <script src="{{ URL::asset('DataTables/js/buttons.bootstrap.min.js') }}"></script>
    <script src="{{ URL::asset('DataTables/js/buttons.colVis.min.js') }}"></script>
    <script src="{{ URL::asset('vendor/datatables/buttons.server-side.js') }}"></script>
    @else
    <script src="{{ URL::asset('DataTables/js/jquery.dataTables.min.js') }}"></script>
    <script src="{{\App\Helpers::assetToggle()}}DataTables/js/dataTables.bootstrap.min.js"></script>
    <script src="{{\App\Helpers::assetToggle()}}DataTables/js/dataTables.buttons.min.js"></script>
    <script src="{{\App\Helpers::assetToggle()}}DataTables/js/buttons.bootstrap.min.js"></script>
    <script src="{{\App\Helpers::assetToggle()}}DataTables/js/buttons.colVis.min.js"></script>
    <script src="{{\App\Helpers::assetToggle()}}vendor/datatables/buttons.server-side.js"></script>
    @endif

{{--<script src="{{\App\Helpers::assetToggle()}}DataTables/js/jquery.dataTables.min.js"></script>--}}
{{--<script src="{{\App\Helpers::assetToggle()}}DataTables/js/dataTables.bootstrap.min.js"></script>--}}
{{--<script src="{{\App\Helpers::assetToggle()}}DataTables/js/dataTables.buttons.min.js"></script>--}}
{{--<script src="{{\App\Helpers::assetToggle()}}DataTables/js/buttons.bootstrap.min.js"></script>--}}
{{--<script src="{{\App\Helpers::assetToggle()}}DataTables/js/buttons.colVis.min.js"></script>--}}
{{--<script src="{{\App\Helpers::assetToggle()}}vendor/datatables/buttons.server-side.js"></script>--}}
