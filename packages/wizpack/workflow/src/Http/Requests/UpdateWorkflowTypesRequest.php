<?php

namespace  WizPack\Workflow\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use WizPack\Workflow\Models\WorkflowType;

class UpdateWorkflowTypesRequest extends FormRequest
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
        $rules = WorkflowType::$rules;

        $rules['slug'] = 'required|bail|string|unique:workflow_types,id,'.$this->input('slug');

        return $rules;
    }
}
