<?php

namespace App\Models\ERPModels;

use Illuminate\Database\Eloquent\Model;

class Vendor extends Model
{
    protected $table = 'Vendor';
    protected $connection = 'sqlsrv';
    protected $primaryKey = 'DCLink';
    protected $fillable = [
        'DCLink',
        'Account',
        ''
    ];
}
