<?php

namespace App\Models;

use Eloquent as Model;
use Illuminate\Database\Eloquent\SoftDeletes;

/**
 * @SWG\Definition(
 *      definition="SessionTxn",
 *      required={"txn_id", "orig_txn_no", "appended_txn_no", "txn_status", "comments"},
 *      @SWG\Property(
 *          property="id",
 *          description="id",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="txn_id",
 *          description="txn_id",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="orig_txn_no",
 *          description="orig_txn_no",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="appended_txn_no",
 *          description="appended_txn_no",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="txn_status",
 *          description="txn_status",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="comments",
 *          description="comments",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="created_at",
 *          description="created_at",
 *          type="string",
 *          format="date-time"
 *      ),
 *      @SWG\Property(
 *          property="updated_at",
 *          description="updated_at",
 *          type="string",
 *          format="date-time"
 *      ),
 *      @SWG\Property(
 *          property="deleted_at",
 *          description="deleted_at",
 *          type="string",
 *          format="date-time"
 *      )
 * )
 */
class SessionTxn extends Model
{
    use SoftDeletes;

    public $table = 'txn_session';

    const CREATED_AT = 'created_at';
    const UPDATED_AT = 'updated_at';


    protected $dates = ['deleted_at'];



    public $fillable = [
        'txn_id',
        'orig_txn_no',
        'appended_txn_no',
        'txn_status',
        'comments',
        'sync_message'
    ];

    /**
     * The attributes that should be casted to native types.
     *
     * @var array
     */
    protected $casts = [
        'id' => 'integer',
        'txn_id' => 'integer',
        'orig_txn_no' => 'string',
        'appended_txn_no' => 'string',
        'txn_status' => 'string',
        'comments' => 'string',
        'sync_message' => 'string',
    ];

    /**
     * Validation rules
     *
     * @var array
     */
    public static $rules = [
        'txn_id' => 'required',
        'orig_txn_no' => 'required',
        'appended_txn_no' => 'required',
        'txn_status' => 'required',
        'comments' => 'required'
    ];


}
