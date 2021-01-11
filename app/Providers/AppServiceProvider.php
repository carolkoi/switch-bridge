<?php

namespace App\Providers;
use Config;
use Illuminate\Support\Facades\URL;
use Illuminate\Support\ServiceProvider;
use Illuminate\Support\Facades\App;
use Illuminate\Routing\UrlGenerator;
use Illuminate\Pagination\LengthAwarePaginator;
use Illuminate\Support\Collection;

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
        if(App::environment('prod')) {
            $url->forceRootUrl(env('APP_URL', 'https://asgard.slafrica.net:9810/'));
        }

        Collection::macro('paginate', function ($perPage, $total = null, $page = null, $pageName = 'page') {
            $page = $page ?: LengthAwarePaginator::resolveCurrentPage($pageName);

            return new LengthAwarePaginator($this->forPage($page, $perPage), $total ?: $this->count(), $perPage, $page, [
                'path' => LengthAwarePaginator::resolveCurrentPath(),
                'pageName' => $pageName,
            ]);
        });

    }


}
