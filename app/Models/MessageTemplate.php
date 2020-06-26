<?php

namespace App\Models;

use Eloquent as Model;
use Illuminate\Database\Eloquent\SoftDeletes;

/**
 * @SWG\Definition(
 *      definition="MessageTemplate",
 *      required={""},
 *      @SWG\Property(
 *          property="messagetypeid",
 *          description="messagetypeid",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="messagetype",
 *          description="messagetype",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="eng_message",
 *          description="eng_message",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="kis_message",
 *          description="kis_message",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="messagepriority",
 *          description="messagepriority",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="datetimeadded",
 *          description="datetimeadded",
 *          type="string",
 *          format="date-time"
 *      ),
 *      @SWG\Property(
 *          property="addedby",
 *          description="addedby",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="ipaddress",
 *          description="ipaddress",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="partnerid",
 *          description="partnerid",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="record_version",
 *          description="record_version",
 *          type="integer",
 *          format="int32"
 *      )
 * )
 */
class MessageTemplate extends Model
{
    use SoftDeletes;

    public $table = 'tbl_sms_messagetypes';
    public $primaryKey = 'messagetypeid';

    const CREATED_AT = 'created_at';
    const UPDATED_AT = 'updated_at';


    protected $dates = ['deleted_at'];
    public $timestamps = false;




    public $fillable = [
        'messagetype',
        'eng_message',
        'kis_message',
        'messagepriority',
        'datetimeadded',
        'addedby',
        'ipaddress',
        'partnerid',
        'record_version'
    ];

    /**
     * The attributes that should be casted to native types.
     *
     * @var array
     */
    protected $casts = [
        'messagetypeid' => 'integer',
        'messagetype' => 'string',
        'eng_message' => 'string',
        'kis_message' => 'string',
        'messagepriority' => 'integer',
        'datetimeadded' => 'datetime',
        'addedby' => 'integer',
        'ipaddress' => 'string',
        'partnerid' => 'integer',
        'record_version' => 'integer'
    ];

    /**
     * Validation rules
     *
     * @var array
     */
    public static $rules = [

    ];
    public function getDateFormat()
    {
        return 'Y-m-d H:i:s.u';
    }
    public function user(){
        return $this->belongsTo(User::class, 'addedby','id');
    }



}
