<!-- Scripts -->
<script src="{{ url('js/app.js') }}" ></script>
<!-- jQuery 3 -->
<script src="{{url('admin-lte/bower_components/jquery/dist/jquery.min.js')}}"></script>
<!-- jQuery UI 1.11.4 -->
<script src="{{url('admin-lte/bower_components/jquery-ui/jquery-ui.min.js')}}"></script>
<!-- Resolve conflict in jQuery UI tooltip with Bootstrap tooltip -->
<script>
    $.widget.bridge('uibutton', $.ui.button);
</script>
<!-- Bootstrap 3.3.7 -->
<script src="{{url('admin-lte/bower_components/bootstrap/dist/js/bootstrap.min.js')}}"></script>
<!-- Morris.js charts -->
<script src="{{url('admin-lte/bower_components/raphael/raphael.min.js')}}"></script>
<script src="{{url('admin-lte/bower_components/morris.js/morris.min.js')}}"></script>
<!-- Sparkline -->
<script src="{{url('admin-lte/bower_components/jquery-sparkline/dist/jquery.sparkline.min.js')}}"></script>
<!-- jvectormap -->
<script src="{{url('admin-lte/plugins/jvectormap/jquery-jvectormap-1.2.2.min.js')}}"></script>
<script src="{{url('admin-lte/plugins/jvectormap/jquery-jvectormap-world-mill-en.js')}}"></script>
<!-- jQuery Knob Chart -->
<script src="{{url('admin-lte/bower_components/jquery-knob/dist/jquery.knob.min.js')}}"></script>
<!-- daterangepicker -->
<script src="{{url('admin-lte/bower_components/moment/min/moment.min.js')}}"></script>
<script src="{{url('admin-lte/bower_components/bootstrap-daterangepicker/daterangepicker.js')}}"></script>
<!-- datepicker -->
<script src="{{url('admin-lte/bower_components/bootstrap-datepicker/dist/js/bootstrap-datepicker.min.js')}}"></script>
<!-- CK Editor -->
<script src="{{url('admin-lte/bower_components/ckeditor/ckeditor.js')}}"></script>
<!-- Bootstrap WYSIHTML5 -->
<script src="{{url('admin-lte/plugins/bootstrap-wysihtml5/bootstrap3-wysihtml5.all.min.js')}}"></script>
<!-- Slimscroll -->
<script src="{{url('admin-lte/bower_components/jquery-slimscroll/jquery.slimscroll.min.js')}}"></script>
<!-- FastClick -->
<script src="{{url('admin-lte/bower_components/fastclick/lib/fastclick.js')}}"></script>
<!-- AdminLTE App -->
<script src="{{url('admin-lte/dist/js/adminlte.min.js')}}"></script>
<!-- Bootstrap time Picker -->
<script src="{{url('admin-lte/plugins/timepicker/bootstrap-timepicker.min.js')}}"></script>
<!-- Bootstrap date-time Picker -->
<script src="{{url('admin-lte/plugins/datetimepicker/bootstrap-datetimepicker.min.js')}}"></script>
<!-- Select2 -->
<script src="{{url('admin-lte/bower_components/select2/dist/js/select2.full.min.js')}}"></script>

<!-- PACE -->
<script src="{{url('admin-lte/bower_components/PACE/pace.min.js')}}"></script>
<!--Star Rating-->
<script src="{{ url('js/star-rating.min.js') }}" ></script>
<!--Bootstrap toggle-->
<script src="{{ url('js/bootstrap4-toggle.min.js') }}" ></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/dropzone/5.5.1/min/dropzone.min.js"></script>
<script>
    $(document).ready(function () {
        $(".select2").select2({
            width: '100%',
            placeholder: 'SELECT FILTER PARAMETER',
        });
    });
</script>
<script>
    CKEDITOR.replace('editor')

</script>

@yield('scripts')
@yield('js')


