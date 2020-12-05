<?php

namespace App\Providers;
use Illuminate\Support\Facades\URL;
use Illuminate\Support\ServiceProvider;
use Illuminate\Support\Facades\App;
use Illuminate\Routing\UrlGenerator;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     *
     * @return void
     */
    public function register()
    {
        //        if(App::environment('production')) {
//            $url->forceScheme('https');
//        }
        $app = require __DIR__.'/../bootstrap/app.php';

        $app->make('url')->forceRootUrl(env('APP_URL', 'http://localhost/'));

    }

    /**
     * Bootstrap any application services.
     *
     * @param UrlGenerator $url
     * @return void
     */
    public function boot(UrlGenerator $url)
    {
        if(App::environment('dev')) {
            $url->forceRootUrl(env('APP_URL', 'https://dev.slafrica.net:6810'));
        }
    }
}
