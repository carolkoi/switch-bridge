<!-- DataTable Bootstrap -->
@if(\App\Helpers::getEnv() == "local")
    <link href="{{URL::asset('DataTables/css/buttons.bootstrap.min.css')}}" rel="stylesheet">
    <link rel="stylesheet" href="{{URL::asset('DataTables/css/dataTables.bootstrap.min.css')}}">
    @else
    <link href="{{\App\Helpers::assetToggle()}}DataTables/css/buttons.bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="{{\App\Helpers::assetToggle()}}DataTables/css/dataTables.bootstrap.min.css">
    @endif

