<?php

namespace App\Models\ERPModels;

use Illuminate\Database\Eloquent\Model;

class Client extends Model
{
    protected $table = 'Client';
    protected $connection = 'sqlsrv';
    protected $primaryKey = 'DCLink';
    protected $fillable = [
    'DCLink',
        'Account',
        ''
];
    public function rtblpeople(){
        return $this->hasMany(RtblPeople::class);
    }

}
