<!-- Main Header -->
<header class="main-header">

    <!-- Logo -->
    <a href="#" class="logo">
        @if(\App\Helpers::getEnv() == "local")
            <img class="logo-img" src="{{URL::asset('images/logo-sla.png')}}" alt="logo" width="227" height="50">

        @else
            <link rel="stylesheet" href="{{\App\Helpers::assetToggle()}}images/logo-sla.png">

        @endif


        {{--        <b>{{env('APP_NAME', 'Wizag')}}</b>--}}
    </a>

    <!-- Header Navbar -->
    <nav class="navbar navbar-static-top" role="navigation">
        <!-- Sidebar toggle button-->
        <a href="#" class="sidebar-toggle" data-toggle="push-menu" role="button">
            <span class="sr-only">Toggle navigation</span>
        </a>
        <!-- Navbar Right Menu -->
        <div class="navbar-custom-menu">
            <ul class="nav navbar-nav">
                <!-- User Account Menu -->
                <li class="dropdown user user-menu">
                    <!-- Menu Toggle Button -->
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown">
{{--                        <!-- The user image in the navbar-->--}}
{{--                        @if(\App\Helpers::getEnv() == "local")--}}
{{--                            <img src="{{URL::asset('images/blue_logo_150x150.jpg')}}"--}}
{{--                                 class="img-circle" alt="User Image"/>--}}
{{--                        @else--}}
{{--                            <img src="{{\App\Helpers::assetToggle()}}images/blue_logo_150x150.jpg" width="50px" height="50px">--}}
{{--                        @endif--}}

{{--                        <!-- hidden-xs hides the username on small devices so only the image appears. -->--}}
{{--                                                <span class="hidden-xs">{!! \Illuminate\Support\Facades\Auth::check() && Auth::user()->name !!}</span>--}}
                        <span class="hidden-xs">{!! Auth::user() ? Auth::user()->name : redirect('/') !!}</span>
                    </a>
                    <ul class="dropdown-menu">
                        <!-- The user image in the menu -->
                        <li class="user-header">
                            <img src="{{\App\Helpers::assetToggle()}}images/logo-sla.png"
                                 class="img-circle" alt="User Image"/>
                            <p>
                                {!! Auth::user() ? Auth::user()->name : redirect('/')!!}
                                <small>{!! Auth::user() ? Auth::user()->msisdn : redirect('/') !!}</small>
{{--                                <small>{!! Auth::user() ? Auth::user()->status : redirect('/')!!}</small>--}}

                                <small>Member since {!! Auth::user() ? Auth::user()->created_at->format('M. Y') : redirect('/')!!}</small>

                            </p>
                        </li>
                        <!-- Menu Footer-->
                            <li class="user-footer">
                                <div class="pull-left">
{{--                                    @if(\App\Helpers::getEnv() == "local")--}}
{{--                                        {{URL::asset('profile/'.(Auth::check() && Auth::user()->id)}}--}}
                                    <a href="/profile/{{Auth::id()}}" class="btn btn-default btn-flat">Profile</a>
{{--                                @else--}}
{{--                                        <a class="btn btn-default btn-flat" href="{{\App\Helpers::assetToggle()}}profile/{{(Auth::check() && Auth::user()->id)}}" >Profile</a>--}}
{{--                                @endif--}}
                                </div>
                                <div class="pull-right">
                                    @if(\App\Helpers::getEnv() == "local")
                                    <a href="{!! URL::asset('/logout') !!}" class="btn btn-default btn-flat"
                                       onclick="event.preventDefault(); document.getElementById('logout-form').submit();">
                                        Sign out
                                    </a>
                                        <form id="logout-form" action="{{URL::asset('/logout') }}" method="POST"
                                              style="display: none;">
                                            {{ csrf_field() }}
                                        </form>
                                    @else
                                        <a href="{{\App\Helpers::assetToggle()}}logout" class="btn btn-default btn-flat"
                                           onclick="event.preventDefault(); document.getElementById('logout-form').submit();">
                                            Sign out
                                        </a>
                                        <form id="logout-form" action="{{\App\Helpers::assetToggle()}}logout" method="POST"
                                              style="display: none;">
                                            {{ csrf_field() }}
                                        </form>

                                        @endif

                                </div>
                            </li>

                    </ul>
                </li>
            </ul>
        </div>
    </nav>
</header>
