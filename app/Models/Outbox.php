<?php

namespace App\Models;

use Eloquent as Model;
use Illuminate\Database\Eloquent\SoftDeletes;

/**
 * @SWG\Definition(
 *      definition="Outbox",
 *      required={"messageid", "messagetypeid", "attempts"},
 *      @SWG\Property(
 *          property="messageoutboxid",
 *          description="messageoutboxid",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="messageid",
 *          description="messageid",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="messagetypeid",
 *          description="messagetypeid",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="messagestatus",
 *          description="messagestatus",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="messagepriority",
 *          description="messagepriority",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="datetimesent",
 *          description="datetimesent",
 *          type="string",
 *          format="date-time"
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
 *          property="attempts",
 *          description="attempts",
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
class Outbox extends Model
{
    use SoftDeletes;

    public $table = 'tbl_sms_outbox';

    const CREATED_AT = 'created_at';
    const UPDATED_AT = 'updated_at';


    protected $dates = ['deleted_at'];



    public $fillable = [
        'messageid',
        'messagetypeid',
        'messagestatus',
        'messagepriority',
        'datetimesent',
        'datetimeadded',
        'addedby',
        'ipaddress',
        'attempts',
        'record_version'
    ];

    /**
     * The attributes that should be casted to native types.
     *
     * @var array
     */
    protected $casts = [
        'messageoutboxid' => 'integer',
        'messageid' => 'integer',
        'messagetypeid' => 'integer',
        'messagestatus' => 'string',
        'messagepriority' => 'integer',
        'datetimesent' => 'datetime',
        'datetimeadded' => 'datetime',
        'addedby' => 'integer',
        'ipaddress' => 'string',
        'attempts' => 'integer',
        'record_version' => 'integer'
    ];

    /**
     * Validation rules
     *
     * @var array
     */
    public static $rules = [
        'messageid' => 'required',
        'messagetypeid' => 'required',
        'attempts' => 'required'
    ];
    public function getDateFormat()
    {
        return 'Y-m-d H:i:s.u';
    }
    public function messageType(){
        return $this->belongsTo(MessageTemplate::class, 'messagetypeid', 'messagetypeid');
    }
    public function message(){
        return $this->hasOne(Message::class, 'messageid', 'messageid');
    }


}
