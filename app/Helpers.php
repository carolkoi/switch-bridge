<?php


namespace App;


class Helpers
{
    public static function assetToggle() {
        $url = env('APP_HTTPS_URL');
        return $url;
    }

    public static function getEnv() {
        $env = env('APP_ENV');
        return $env;
    }
}
