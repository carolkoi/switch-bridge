<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Auth;
use App\Http\Requests\PasswordRequest;
use App\Utility;
use App\User;
use Illuminate\Support\Facades\Hash;
//use App\Http\Controllers\Controller;
use App\Accounts;


class AdminController extends Controller {

    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    private $viewResponse = '';

    public function __construct() {
        $this->middleware('auth', [
            'only' => [
                'password', 'profile', 'savePassword'
            ]
        ]);
    }

    public function index() {
        //return Hash::make('vitamins');
        return view('auth.login', ['viewResponse' => $this->viewResponse]);
    }

    public function auth(Request $request) {
        if ($request->isMethod('post')) {


            if (Auth::attempt(['email' => $request->get('email'),
                        'password' => $request->get('password')])) {

                if (Auth::user()->role_id == 1) {
                    $this->viewResponse = Utility::renderError('Denied Authorization');
                } else {
                    return redirect()->intended('home');

                }
            } else {
                $this->viewResponse = Utility::renderError('Login Failed! Wrong Username or Password');
            }
        }

        return view('login', ['viewResponse' => $this->viewResponse]);
    }

    public function createtestusers() {

       $date =  date('Ymdmmss');


        $accountno = strtoupper (base_convert($date, 10, 36));


                $randomPassword = 'vitamins';
                $user = new User;
                $user->role_id = 3;
                $user->name = 'Administrator';
                $user->company_id = 1;
                $user->email = 'admin@switchlink.co.ke';
                $user->password = Hash::make($randomPassword);
                $user->msisdn = '254720711386';
                $user->contact_person = 'SWITCH LINK';
                //$user->address = 'RUAKA';
                //$user->idnumber = '24102158';
                //$user->county = 'KIAMBU';
                //$user->town = 'RUAKA';
                $user->status = 'ACTIVE';

                $user->save();

                die();

    }

}
