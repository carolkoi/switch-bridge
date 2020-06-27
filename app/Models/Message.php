<?php

namespace App\Models;

use Eloquent as Model;
use Illuminate\Database\Eloquent\SoftDeletes;

/**
 * @SWG\Definition(
 *      definition="Message",
 *      required={"messagetypeid"},
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
 *          property="messageoutboxid",
 *          description="messageoutboxid",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="mobilenumber",
 *          description="mobilenumber",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="messagelanguage",
 *          description="messagelanguage",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="message",
 *          description="message",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="contents",
 *          description="contents",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="messagestatus",
 *          description="messagestatus",
 *          type="string"
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
 *          property="source",
 *          description="source",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="record_version",
 *          description="record_version",
 *          type="integer",
 *          format="int32"
 *      )
 * )
 */
class Message extends Model
{
    use SoftDeletes;
    public $primaryKey = 'messageid';
    public $table = 'tbl_sms_messages';


    const CREATED_AT = 'created_at';
    const UPDATED_AT = 'updated_at';


    protected $dates = ['deleted_at'];



    public $fillable = [
        'messagetypeid',
        'messageoutboxid',
        'mobilenumber',
        'messagelanguage',
        'message',
        'contents',
        'messagestatus',
        'datetimeadded',
        'addedby',
        'ipaddress',
        'source',
        'record_version'
    ];

    /**
     * The attributes that should be casted to native types.
     *
     * @var array
     */
    protected $casts = [
        'messageid' => 'integer',
        'messagetypeid' => 'integer',
        'messageoutboxid' => 'integer',
        'mobilenumber' => 'integer',
        'messagelanguage' => 'string',
        'message' => 'string',
        'contents' => 'string',
        'messagestatus' => 'string',
        'datetimeadded' => 'datetime',
        'addedby' => 'integer',
        'ipaddress' => 'string',
        'source' => 'string',
        'record_version' => 'integer'
    ];

    /**
     * Validation rules
     *
     * @var array
     */
    public static $rules = [
        'messagetypeid' => 'required'
    ];

    public function getDateFormat()
    {
        return 'Y-m-d H:i:s.u';
    }
    public function messageType(){
        return $this->belongsTo(MessageTemplate::class, 'messagetypeid', 'messagetypeid');
    }
    public function outbox(){
        return $this->hasOne(Outbox::class, 'messageoutboxid', 'messageoutboxid');
    }


}
