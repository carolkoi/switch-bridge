@if(\App\Helpers::getEnv() == "local")
    <!-- Scripts -->
    <script src="{{ URL::asset('js/app.js') }}" ></script>
{{--    <script src="{{URL::asset('assets/js/app.js')}}" type="text/javascript"></script>--}}
    <!-- jQuery 3 -->
    <script src="{{URL::asset('admin-lte/bower_components/jquery/dist/jquery.min.js')}}"></script>
    <!-- jQuery UI 1.11.4 -->
    <script src="{{URL::asset('admin-lte/bower_components/jquery-ui/jquery-ui.min.js')}}"></script>
    <!-- Resolve conflict in jQuery UI tooltip with Bootstrap tooltip -->
    <script>
        $.widget.bridge('uibutton', $.ui.button);
    </script>
    <!-- Bootstrap 3.3.7 -->
    <script src="{{URL::asset('admin-lte/bower_components/bootstrap/dist/js/bootstrap.min.js')}}"></script>
    <!-- Morris.js charts -->
    <script src="{{URL::asset('admin-lte/bower_components/raphael/raphael.min.js')}}"></script>
    <script src="{{URL::asset('admin-lte/bower_components/morris.js/morris.min.js')}}"></script>
    <!-- Sparkline -->
    <script src="{{URL::asset('admin-lte/bower_components/jquery-sparkline/dist/jquery.sparkline.min.js')}}"></script>
    <!-- jvectormap -->
    <script src="{{URL::asset('admin-lte/plugins/jvectormap/jquery-jvectormap-1.2.2.min.js')}}"></script>
    <script src="{{URL::asset('admin-lte/plugins/jvectormap/jquery-jvectormap-world-mill-en.js')}}"></script>
    <!-- jQuery Knob Chart -->
    <script src="{{URL::asset('admin-lte/bower_components/jquery-knob/dist/jquery.knob.min.js')}}"></script>
    <!-- daterangepicker -->
    <script src="{{URL::asset('admin-lte/bower_components/moment/min/moment.min.js')}}"></script>
    <script src="{{URL::asset('admin-lte/bower_components/bootstrap-daterangepicker/daterangepicker.js')}}"></script>
    <!-- datepicker -->
    <script src="{{URL::asset('admin-lte/bower_components/bootstrap-datepicker/dist/js/bootstrap-datepicker.min.js')}}"></script>
    <!-- CK Editor -->
    <script src="{{URL::asset('admin-lte/bower_components/ckeditor/ckeditor.js')}}"></script>
    <!-- Bootstrap WYSIHTML5 -->
    <script src="{{URL::asset('admin-lte/plugins/bootstrap-wysihtml5/bootstrap3-wysihtml5.all.min.js')}}"></script>
    <!-- Slimscroll -->
    <script src="{{URL::asset('admin-lte/bower_components/jquery-slimscroll/jquery.slimscroll.min.js')}}"></script>
    <!-- FastClick -->
    <script src="{{URL::asset('admin-lte/bower_components/fastclick/lib/fastclick.js')}}"></script>
    <!-- AdminLTE App -->
    <script src="{{URL::asset('admin-lte/dist/js/adminlte.min.js')}}"></script>
    <!-- Bootstrap time Picker -->
    <script src="{{URL::asset('admin-lte/plugins/timepicker/bootstrap-timepicker.min.js')}}"></script>
    <!-- Bootstrap date-time Picker -->
    <script src="{{URL::asset('admin-lte/plugins/datetimepicker/bootstrap-datetimepicker.min.js')}}"></script>
    <!-- Select2 -->
    <script src="{{URL::asset('admin-lte/bower_components/select2/dist/js/select2.full.min.js')}}"></script>

    <!-- PACE -->
    <script src="{{URL::asset('admin-lte/bower_components/PACE/pace.min.js')}}"></script>
    <!--Star Rating-->
    <script src="{{ URL::asset('js/star-rating.min.js') }}" ></script>
    <!--Bootstrap toggle-->
    <script src="{{ URL::asset('js/bootstrap4-toggle.min.js') }}" ></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/dropzone/5.5.1/min/dropzone.min.js"></script>

    @else
    <script src="{{\App\Helpers::assetToggle()}}assets/lib/jquery/jquery.min.js" type="text/javascript"></script>


    <!-- Scripts -->
    <script src="{{\App\Helpers::assetToggle()}}js/app.js" ></script>
    <!-- jQuery 3 -->
{{--    <script src="{{\App\Helpers::assetToggle()}}admin-lte/bower_components/jquery/dist/jquery.min.js"></script>--}}
    <script src="{{secure_asset('admin-lte/bower_components/jquery/dist/jquery.min.js')}}"></script>

    <!-- jQuery UI 1.11.4 -->
    <script src="{{\App\Helpers::assetToggle()}}admin-lte/bower_components/jquery-ui/jquery-ui.min.js"></script>
    <!-- Resolve conflict in jQuery UI tooltip with Bootstrap tooltip -->
    <script>
        $.widget.bridge('uibutton', $.ui.button);
    </script>
    <!-- Bootstrap 3.3.7 -->
    <script src="{{\App\Helpers::assetToggle()}}admin-lte/bower_components/bootstrap/dist/js/bootstrap.min.js"></script>
    <!-- Morris.js charts -->
    <script src="{{\App\Helpers::assetToggle()}}admin-lte/bower_components/raphael/raphael.min.js"></script>
    <script src="{{\App\Helpers::assetToggle()}}admin-lte/bower_components/morris.js/morris.min.js"></script>
    <!-- Sparkline -->
    <script src="{{\App\Helpers::assetToggle()}}admin-lte/bower_components/jquery-sparkline/dist/jquery.sparkline.min.js"></script>
    <!-- jvectormap -->
    <script src="{{\App\Helpers::assetToggle()}}admin-lte/plugins/jvectormap/jquery-jvectormap-1.2.2.min.js"></script>
    <script src="{{\App\Helpers::assetToggle()}}admin-lte/plugins/jvectormap/jquery-jvectormap-world-mill-en.js"></script>
    <!-- jQuery Knob Chart -->
    <script src="{{\App\Helpers::assetToggle()}}admin-lte/bower_components/jquery-knob/dist/jquery.knob.min.js"></script>
    <!-- daterangepicker -->
    <script src="{{\App\Helpers::assetToggle()}}admin-lte/bower_components/moment/min/moment.min.js"></script>
    <script src="{{\App\Helpers::assetToggle()}}admin-lte/bower_components/bootstrap-daterangepicker/daterangepicker.js"></script>
    <!-- datepicker -->
    <script src="{{\App\Helpers::assetToggle()}}admin-lte/bower_components/bootstrap-datepicker/dist/js/bootstrap-datepicker.min.js"></script>
    <!-- CK Editor -->
    <script src="{{\App\Helpers::assetToggle()}}admin-lte/bower_components/ckeditor/ckeditor.js"></script>
    <!-- Bootstrap WYSIHTML5 -->
    <script src="{{\App\Helpers::assetToggle()}}admin-lte/plugins/bootstrap-wysihtml5/bootstrap3-wysihtml5.all.min.js"></script>
    <!-- Slimscroll -->
    <script src="{{\App\Helpers::assetToggle()}}admin-lte/bower_components/jquery-slimscroll/jquery.slimscroll.min.js"></script>
    <!-- FastClick -->
    <script src="{{\App\Helpers::assetToggle()}}admin-lte/bower_components/fastclick/lib/fastclick.js"></script>
    <!-- AdminLTE App -->
    <script src="{{\App\Helpers::assetToggle()}}admin-lte/dist/js/adminlte.min.js"></script>
    <!-- Bootstrap time Picker -->
    <script src="{{\App\Helpers::assetToggle()}}admin-lte/plugins/timepicker/bootstrap-timepicker.min.js"></script>
    <!-- Bootstrap date-time Picker -->
    <script src="{{\App\Helpers::assetToggle()}}admin-lte/plugins/datetimepicker/bootstrap-datetimepicker.min.js"></script>
    <!-- Select2 -->
    <script src="{{\App\Helpers::assetToggle()}}admin-lte/bower_components/select2/dist/js/select2.full.min.js"></script>

    <!-- PACE -->
    <script src="{{\App\Helpers::assetToggle()}}admin-lte/bower_components/PACE/pace.min.js"></script>
    <!--Star Rating-->
    <script src="{{\App\Helpers::assetToggle()}}js/star-rating.min.js"></script>
    <!--Bootstrap toggle-->
    <script src="{{\App\Helpers::assetToggle()}}js/bootstrap4-toggle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/dropzone/5.5.1/min/dropzone.min.js"></script>

@endif
<script>
    $(document).ready(function () {
        $(".select2").select2({
            width: '100%',
            placeholder: 'SELECT FILTER PARAMETER',
        });
    });
</script>
{{--<script>--}}
{{--    CKEDITOR.replace('editor')--}}

{{--</script>--}}

@yield('scripts')
@yield('js')


