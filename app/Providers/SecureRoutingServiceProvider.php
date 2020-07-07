<?php

namespace App\Providers;
use Illuminate\Support\Facades\URL;
use Illuminate\Support\ServiceProvider;
use Illuminate\Routing\UrlGenerator;
use Illuminate\Routing\RoutingServiceProvider;
use App;

class SecureRoutingServiceProvider extends RoutingServiceProvider
{
    public function boot()
    {
        App::bind('url', function () {
            $generator = new UrlGenerator(
                App::make('router')->getRoutes(),
                App::make('request')
        );

            $generator->forceScheme('https');

            return $generator;
        });

//        parent::boot();
    }
}
