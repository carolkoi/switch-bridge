<!-- Datatables -->
@if(\App\Helpers::getEnv() == "local")
    <script src="https://code.jquery.com/jquery-3.5.1.js"></script>
    <script src="{{ URL::asset('DataTables/js/jquery.dataTables.min.js') }}"></script>
    <script src="{{ URL::asset('DataTables/js/dataTables.bootstrap.min.js') }}"></script>
    <script src="{{ URL::asset('DataTables/js/dataTables.buttons.min.js') }}"></script>
    <script src="{{ URL::asset('DataTables/js/buttons.bootstrap.min.js') }}"></script>
    <script src="{{ URL::asset('DataTables/js/buttons.colVis.min.js') }}"></script>
    <script src="{{ URL::asset('vendor/datatables/buttons.server-side.js') }}"></script>


    {{--    <script src="https://cdn.datatables.net/1.10.23/js/jquery.dataTables.min.js"></script>--}}
{{--    <script src="https://cdn.datatables.net/buttons/1.6.5/js/dataTables.buttons.min.js"></script>--}}
{{--    <script src="https://cdn.datatables.net/buttons/1.6.5/js/buttons.flash.min.js"></script>--}}
{{--    <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>--}}
{{--    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/pdfmake.min.js"></script>--}}
{{--    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/vfs_fonts.js"></script>--}}
{{--    <script src="https://cdn.datatables.net/buttons/1.6.5/js/buttons.html5.min.js"></script>--}}
{{--    <script src="https://cdn.datatables.net/buttons/1.6.5/js/buttons.print.min.js"></script>--}}
    @else
    <script src="https://code.jquery.com/jquery-3.5.1.js"></script>
    <script src="{{\App\Helpers::assetToggle()}}DataTables/js/jquery.dataTables.min.js"></script>
    <script src="{{\App\Helpers::assetToggle()}}DataTables/js/dataTables.bootstrap.min.js"></script>
    <script src="{{\App\Helpers::assetToggle()}}DataTables/js/dataTables.buttons.min.js"></script>
    <script src="{{\App\Helpers::assetToggle()}}DataTables/js/buttons.bootstrap.min.js"></script>
    <script src="{{\App\Helpers::assetToggle()}}DataTables/js/buttons.colVis.min.js"></script>
    <script src="{{\App\Helpers::assetToggle()}}vendor/datatables/buttons.server-side.js"></script>
{{--    <script src="https://cdn.datatables.net/1.10.23/js/jquery.dataTables.min.js"></script>--}}
{{--    <script src="https://cdn.datatables.net/buttons/1.6.5/js/dataTables.buttons.min.js"></script>--}}
{{--    <script src="https://cdn.datatables.net/buttons/1.6.5/js/buttons.flash.min.js"></script>--}}
{{--    <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>--}}
{{--    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/pdfmake.min.js"></script>--}}
{{--    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/vfs_fonts.js"></script>--}}
{{--    <script src="https://cdn.datatables.net/buttons/1.6.5/js/buttons.html5.min.js"></script>--}}
{{--    <script src="https://cdn.datatables.net/buttons/1.6.5/js/buttons.print.min.js"></script>--}}
    @endif

