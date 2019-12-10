<?php


namespace WizPack\Workflow\Providers;

use Illuminate\Support\ServiceProvider;
use WizPack\Workflow\Http\Controllers\Approval;

class WizPackApprovalServiceProvider extends ServiceProvider
{
    public function register()
    {
        $this->app->bind('wiz-pack-approval', function () {
            return new Approval();
        });
    }

    public function boot()
    {
        $this->loadMigrationsFrom(__DIR__ . '/../Database/Migrations');
        $this->loadRoutesFrom(__DIR__ . '/../Routes/routes.php');
        $this->loadRoutesFrom(__DIR__ . '/../Routes/api.php');
        $this->loadViewsFrom(dirname(__DIR__) . '/Views', 'wizpack');
    }

}
