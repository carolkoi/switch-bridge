<?php

namespace WizPack\Workflow\Http\Requests\API;

use WizPack\Workflow\Models\Approvals;

class UpdateApprovalsAPIRequest extends APIRequest
{
    /**
     * Determine if the user is authorized to make this request.
     *
     * @return bool
     */
    public function authorize()
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array
     */
    public function rules()
    {
        $rules = Approvals::$rules;
        
        return $rules;
    }
}
