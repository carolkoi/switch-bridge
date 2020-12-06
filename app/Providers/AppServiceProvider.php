<?php

namespace App\Providers;
use Config;
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

    }

    /**
     * Bootstrap any application services.
     *
     * @param UrlGenerator $url
     * @return void
     */
    public function boot(UrlGenerator $url)
    {
//        if(App::environment('dev')) {
//            $url->forceRootUrl(env('APP_URL', 'https://dev.slafrica.net:6810'));
//        }
        \URL::forceRootUrl(Config::get('app.url'));
// And this if you wanna handle https URL scheme
// It's not usefull for http://www.example.com, it's just to make it more independant from the constant value
        if (\Str::contains(Config::get('app.url'), 'https://')) {
            \URL::forceScheme('https');
            //use \URL:forceSchema('https') if you use laravel < 5.4
        }
    }
}
