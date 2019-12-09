<?php

namespace WizPack\Workflow\Http\Requests\API;

use WizPack\Workflow\Models\WorkflowStageApprovers;

class UpdateWorkflowStageApproversAPIRequest extends APIRequest
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
        $rules = WorkflowStageApprovers::$rules;
        
        return $rules;
    }
}
