<?php

namespace App\Models\ERPModels;

use Illuminate\Database\Eloquent\Model;

class RtblPeople extends Model
{
    protected $table = '_rtblPeople';
    protected $connection = 'sqlsrv';
    protected $primaryKey = 'contact_id';
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

    public function client(){
        return $this->belongsTo(Client::class);
    }

    public function rtblpeoplelinks(){
        return $this->hasOne(RtblPeopleLinks::class);
    }

}
