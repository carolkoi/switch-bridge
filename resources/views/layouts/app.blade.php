<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
@include('layouts.admin-lite.includes.head')
<body class="sidebar-mini skin-blue sidebar-mini">
<div class="wrapper">
@include('layouts.admin-lite.includes.top-nav')
<!-- Left side column. contains the logo and sidebar -->
@include('layouts.admin-lite.includes.sidebar')
<!-- Content Wrapper. Contains page content -->
    <div class="content-wrapper">
        @yield('content')
    </div>
    @include('layouts.admin-lite.includes.footer')
</div>
@include('layouts.admin-lite.scripts.scripts')


</body>
</html>
