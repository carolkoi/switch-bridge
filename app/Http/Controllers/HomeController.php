<?php

namespace App\Http\Controllers;

use App\Models\Response;
use App\Models\Template;
use Illuminate\Http\Request;

class HomeController extends Controller
{
    /**
     * Create a new controller instance.
     *
     * @return void
     */
    public function __construct()
    {
        $this->middleware('auth');
    }

    /**
     * Show the application dashboard.
     *
     * @return \Illuminate\Contracts\Support\Renderable
     */
    public function index()
    {
        $templates = Template::with(['questions', 'surveyType'])->get();
//        dd($templates);
        return view('home', compact('templates'));
    }
}
