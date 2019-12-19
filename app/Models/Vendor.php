<?php

namespace App\Models;

use Eloquent as Model;
use Illuminate\Database\Eloquent\SoftDeletes;

/**
 * @SWG\Definition(
 *      definition="Vendor",
 *      required={""},
 *      @SWG\Property(
 *          property="id",
 *          description="id",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="account",
 *          description="account",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="name",
 *          description="name",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="contact_person",
 *          description="contact_person",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="physical1",
 *          description="physical1",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="physical2",
 *          description="physical2",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="physical3",
 *          description="physical3",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="physical4",
 *          description="physical4",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="physical5",
 *          description="physical5",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="post1",
 *          description="post1",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="post2",
 *          description="post2",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="post3",
 *          description="post3",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="post4",
 *          description="post4",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="post5",
 *          description="post5",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="tax_number",
 *          description="tax_number",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="email",
 *          description="email",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="deleted_at",
 *          description="deleted_at",
 *          type="string",
 *          format="date-time"
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
 *      )
 * )
 */
class Vendor extends Model
{
    use SoftDeletes;

    public $table = 'vendors';

    const CREATED_AT = 'created_at';
    const UPDATED_AT = 'updated_at';


    protected $dates = ['deleted_at'];



    public $fillable = [
        'dc_link',
        'account',
        'name',
        'contact_person',
        'physical1',
        'physical2',
        'physical3',
        'physical4',
        'physical5',
        'post1',
        'post2',
        'post3',
        'post4',
        'post5',
        'tax_number',
        'email'
    ];

    /**
     * The attributes that should be casted to native types.
     *
     * @var array
     */
    protected $casts = [
        'id' => 'integer',
        'account' => 'string',
        'name' => 'string',
        'contact_person' => 'string',
        'physical1' => 'string',
        'physical2' => 'string',
        'physical3' => 'string',
        'physical4' => 'string',
        'physical5' => 'string',
        'post1' => 'string',
        'post2' => 'string',
        'post3' => 'string',
        'post4' => 'string',
        'post5' => 'string',
        'tax_number' => 'string',
        'email' => 'string'
    ];

    /**
     * Validation rules
     *
     * @var array
     */
    public static $rules = [

    ];


}
