<?php

namespace App\Models;

use Carbon\Carbon;
use Eloquent as Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Support\Facades\Auth;
use WizPack\Workflow\Interfaces\ApprovableInterface;
use WizPack\Workflow\Traits\ApprovableTrait;

/**
 * @SWG\Definition(
 *      definition="FloatBalance",
 *      required={""},
 *      @SWG\Property(
 *          property="floattransactionid",
 *          description="floattransactionid",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="description",
 *          description="description",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="transactionnumber",
 *          description="transactionnumber",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="debit",
 *          description="debit",
 *          type="number",
 *          format="number"
 *      ),
 *      @SWG\Property(
 *          property="credit",
 *          description="credit",
 *          type="number",
 *          format="number"
 *      ),
 *      @SWG\Property(
 *          property="amount",
 *          description="amount",
 *          type="number",
 *          format="number"
 *      ),
 *      @SWG\Property(
 *          property="runningbal",
 *          description="runningbal",
 *          type="number",
 *          format="number"
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
 *          type="string"
 *      )
 * )
 */
class FloatBalance extends Model implements ApprovableInterface
{
    use SoftDeletes, ApprovableTrait;

    public $table = 'tbl_floattransactions';
    public $primaryKey = 'floattransactionid';

    const CREATED_AT = 'created_at';
    const UPDATED_AT = 'updated_at';


    protected $dates = ['deleted_at'];
    public $timestamps = false;



    public $fillable = [
        'description',
        'transactionnumber',
        'debit',
        'credit',
        'amount',
        'runningbal',
        'datetimeadded',
        'addedby',
        'ipaddress',
        'partnerid',
        'transactionref',
        'approved'
    ];

    /**
     * The attributes that should be casted to native types.
     *
     * @var array
     */
    protected $casts = [
        'floattransactionid' => 'integer',
        'description' => 'string',
        'transactionnumber' => 'string',
        'debit' => 'decimal:0',
        'credit' => 'decimal:0',
        'amount' => 'decimal:0',
        'runningbal' => 'decimal:0',
        'datetimeadded' => 'datetime',
        'addedby' => 'integer',
        'ipaddress' => 'string',
        'partnerid' => 'string',
        'transactionref' => 'string',
        'approved' => 'boolean',
        'approved_by' => 'integer'
    ];

    public function getDateFormat()
    {
        return 'Y-m-d H:i:s.u';
    }

    /**
     * Validation rules
     *
     * @var array
     */
    public static $rules = [

    ];

    public function previewLink()
    {
        // TODO: Implement previewLink() method.
        return env('APP_URL')."/floatBalances";
    }

    /**
     * @inheritDoc
     * @noinspection PhpHierarchyChecksInspection
     */
    public function markApprovalComplete($id)
    {
        // TODO: Implement markApprovalComplete() method.
        $model = self::find($id);
        $model->approved = 1;
//        $model->updated_at = Carbon::now();
        $model->approved_by = Auth::user()->id;
        $model->save();
    }

    /**
     * @inheritDoc
     */
    public function markApprovalAsRejected($id)
    {
        // TODO: Implement markApprovalAsRejected() method.
        $model = self::find($id);
        $model->rejected = 1;
//        $model->updated_at = Carbon::now();
        $model->approved_by = Auth::user()->id;
        $model->save();
    }


    public function ScopeFloatByPartner($query, $userCompabyId = null)
    {
        $userCompabyId = $userCompabyId ?: auth()->user()->company_id;

//        $company_id = Auth::check() && Auth::user()->company_id;
//        dd(Auth::user()->company_id);
        if ($userCompabyId == 10){
            return $query
                ->where('partnerid', 'like', "%CHIPPERCASH%");

        }else
            return $query;
        }




}
