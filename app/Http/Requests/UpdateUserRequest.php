<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use App\Models\User;
use Illuminate\Support\Facades\Hash;

class UpdateUserRequest extends FormRequest
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
//    public function rules()
//    {
//        $rules = User::$rules;
//
//        return $rules;
//    }
    public function rules()
    {
        return [
//            'name' => 'required|string|max:255',
            'password' => 'nullable|required_with:password_confirmation|string|confirmed',
//            'current_password' => 'required',
        ];
    }

    /**
     * Configure the validator instance.
     *
     * @param  \Illuminate\Validation\Validator  $validator
     * @return void
     */
    public function withValidator($validator)
    {
//        dd($this->current_password, $this->user()->password);
        // checks user current password
        // before making changes
        $validator->after(function ($validator) {
            if ( !Hash::check($this->current_password, $this->user()->password) ) {
                $validator->errors()->add('current_password', 'Your current password is incorrect.');
            }
            elseif ($this->password != $this->password_confirmation){
                $validator->errors()->add('password_confirmation', '');
            }
            else
                $validator->errors()->add('success', 'Password updated successfully');
        });
        return;
    }
}
