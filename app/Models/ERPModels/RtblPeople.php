<?php

namespace App\Models\ERPModels;

use Illuminate\Database\Eloquent\Model;

class RtblPeople extends Model
{
    protected $table = '_rtblPeople';
    protected $connection = 'sqlsrv';
    protected $primaryKey = 'idPeople';
    protected $fillable = [
        'contact_id',
        'first_name',
        'last_name',
        'initials',
        'email',
        'company_account',
        'company_id',
        'company_name'
    ];


    public function rtblpeoplelink(){
        return $this->belongsTo(RtblPeopleLinks::class);
    }

    public function peopleClient(){
        return $this->hasOneThrough('App\Models\ERPModels\Client', 'App\Models\ERPModels\RtblPeopleLinks',
            'iPeopleID', 'DCLink', 'idPeople', 'iDebtorID');
    }

}
