<?php

namespace wizpack\workflow\Facades;

use Illuminate\Support\Facades\Facade;

class workflow extends Facade
{
    /**
     * Get the registered name of the component.
     *
     * @return string
     */
    protected static function getFacadeAccessor()
    {
        return 'workflow';
    }
}
