<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="description" content="">
    <meta name="author" content="">
{{--    <link rel="shortcut icon" href="{{asset('images/logo-sla.png')}}">--}}
    <title>{{ config('app.name', 'Laravel') }}</title>
    @if(\App\Helpers::getEnv() == "local")
        <link rel="stylesheet" type="text/css" href="{{URL::asset('assets/lib/perfect-scrollbar/css/perfect-scrollbar.css')}}"/>
        <link rel="stylesheet" type="text/css" href="{{URL::asset('assets/lib/material-design-icons/css/material-design-iconic-font.min.css')}}"/>
        <link rel="stylesheet" href="{{URL::asset('assets/css/app.css')}}" type="text/css"/>
        @else
        <link rel="stylesheet" type="text/css" href="{{\App\Helpers::assetToggle()}}assets/lib/perfect-scrollbar/css/perfect-scrollbar.css"/>
        <link rel="stylesheet" type="text/css" href="{{\App\Helpers::assetToggle()}}assets/lib/material-design-icons/css/material-design-iconic-font.min.css"/>
        <link rel="stylesheet" href="{{\App\Helpers::assetToggle()}}assets/css/app.css" type="text/css"/>
        @endif

</head>
<body class="be-splash-screen">
<div class="be-wrapper be-login">
    <div class="be-content">
        <div class="main-content container-fluid">
            <div class="splash-container">
                <div class="card card-border-color card-border-color-primary">
                    <div class="card-header">
                        @if(\App\Helpers::getEnv() == "local")
                            <img class="logo-img" src="{{URL::asset('assets/img/logo-xx.png')}}" alt="logo" width="102" height="27">
                        @else
                            <img class="logo-img" src="{{\App\Helpers::assetToggle()}}assets/img/logo-xx.png" alt="logo" width="102" height="27">

                        @endif
                        <span class="splash-description">Please enter your user information.</span>
                    </div>
                    <div class="card-body">
                        @if(\App\Helpers::getEnv() == "local")
                            <form method="POST" action="{{ URL::asset('/login') }}">

                            @else
                                    <form method="POST" action="{{\App\Helpers::assetToggle()}}login">

                                    @endif
                            {{ csrf_field() }}
{{--                            <div class="form-group">--}}
{{--                                <input class="form-control" name="email" id="email" type="text" placeholder="Username" autocomplete="off">--}}
{{--                            </div>--}}
                            <div class="form-group">
{{--                                <label for="email" class="col-md-4 col-form-label text-md-right">{{ __('Username') }}</label>--}}

{{--                                <div class="col-md-6">--}}
                                    <input id="email" type="email" class="form-control @error('email') is-invalid @enderror" name="email" value="{{ old('email') }}" required autocomplete="email" placeholder="Username" autofocus>

                                    @error('email')
                                    <span class="invalid-feedback" role="alert">
                                        <strong>{{ $message }}</strong>
                                    </span>
                                    @enderror
{{--                                </div>--}}
                            </div>

{{--                            <div class="form-group">--}}
{{--                                <input class="form-control" name="password" id="password" type="password" placeholder="Password">--}}
{{--                            </div>--}}
                            <div class="form-group">
{{--                                <label for="password" class="col-md-4 col-form-label text-md-right">{{ __('Password') }}</label>--}}

{{--                                <div class="col-md-6">--}}
                                    <input id="password" type="password" placeholder="Password" class="form-control @error('password') is-invalid @enderror" name="password" required autocomplete="current-password">

                                    @error('password')
                                    <span class="invalid-feedback" role="alert">
                                        <strong>{{ $message }}</strong>
                                    </span>
                                    @enderror
{{--                                </div>--}}
                            </div>
                            {{ csrf_field() }}
                            <div class="form-group row login-tools">
                                <div class="col-6 login-remember">
                                    <div class="custom-control custom-checkbox">
                                        <input class="custom-control-input" type="checkbox" id="checkbox1" {{ old('remember') ? 'checked' : '' }}>
                                        <label class="custom-control-label" for="checkbox1">Remember Me</label>
                                    </div>
                                </div>
                                @if(\App\Helpers::getEnv() == "local")
                                    <div class="col-6 login-forgot-password"><a href="{{url('/password/request') }}">Forgot Password?</a></div>

                                @else
                                    <div class="col-6 login-forgot-password"><a href="{{\App\Helpers::assetToggle()}}password/request">Forgot Password?</a></div>

                                @endif
                                <br /><br />
{{--                                {!! $viewResponse !!}--}}

                            </div>
                            <div class="form-group login-submit">

                                <button type="submit" class="btn btn-primary btn-xl">Sign me in <i class="fa fa-angle-right ml5"></i></button>
                            </div>
                        </form>
                            </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
@if(\App\Helpers::getEnv() == "local")
    <link rel="stylesheet" href="{{URL::asset('assets/css/app.css')}}" type="text/css"/>
    <script src="{{URL::asset('assets/lib/jquery/jquery.min.js')}}" type="text/javascript"></script>
    <script src="{{URL::asset('assets/lib/perfect-scrollbar/js/perfect-scrollbar.min.js')}}" type="text/javascript"></script>
    <script src="{{URL::asset('assets/lib/bootstrap/dist/js/bootstrap.bundle.min.js')}}" type="text/javascript"></script>
    <script src="{{URL::asset('assets/js/app.js')}}" type="text/javascript"></script>
    @else
    <script src="{{\App\Helpers::assetToggle()}}assets/lib/jquery/jquery.min.js" type="text/javascript"></script>
    <script src="{{\App\Helpers::assetToggle()}}assets/lib/perfect-scrollbar/js/perfect-scrollbar.min.js" type="text/javascript"></script>
    <script src="{{\App\Helpers::assetToggle()}}assets/lib/bootstrap/dist/js/bootstrap.bundle.min.js" type="text/javascript"></script>
    <script src="{{\App\Helpers::assetToggle()}}assets/js/app.js" type="text/javascript"></script>
    @endif

<script type="text/javascript">
    $(document).ready(function(){
        //-initialize the javascript
        App.init();
    });

</script>
</body>
</html>
