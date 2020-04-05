<!-- Main Header -->
<header class="main-header">

    <!-- Logo -->
    <a href="#" class="logo">
        <img class="logo-img" src="{{asset('images/logo-sla.png')}}" alt="logo" width="227" height="50">

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
                        <!-- The user image in the navbar-->
                        <img src="{{asset('images/blue_logo_150x150.jpg')}}"
                             class="user-image" alt="User Image"/>
                        <!-- hidden-xs hides the username on small devices so only the image appears. -->
                        {{--                        <span class="hidden-xs">{!! Auth::user()->name !!}</span>--}}
                        <span class="hidden-xs">{!! Auth::user() ? Auth::user()->name : redirect('/') !!}</span>
                    </a>
                    <ul class="dropdown-menu">
                        <!-- The user image in the menu -->
                        <li class="user-header">
                            <img src="{{asset('images/blue_logo_150x150.jpg')}}"
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
                                <a href="#" class="btn btn-default btn-flat">Profile</a>
                            </div>
                            <div class="pull-right">
                                <a href="{!! url('/logout') !!}" class="btn btn-default btn-flat"
                                   onclick="event.preventDefault(); document.getElementById('logout-form').submit();">
                                    Sign out
                                </a>
                                <form id="logout-form" action="{{ url('/logout') }}" method="POST"
                                      style="display: none;">
                                    {{ csrf_field() }}
                                </form>
                            </div>
                        </li>
                    </ul>
                </li>
            </ul>
        </div>
    </nav>
</header>
