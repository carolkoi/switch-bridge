<?php

namespace App\Models\ERPModels;

use Illuminate\Database\Eloquent\Model;

class RtblPeopleLinks extends Model
{
    protected $table = '_rtblPeopleLinks';
    protected $connection = 'sqlsrv';
    protected $primaryKey = 'iPeopleID';
    protected $fillable = [
       'iPeopleID'
    ];

    public function rtblpeople(){
        return $this->hasOne(RtblPeople::class);
    }

}
