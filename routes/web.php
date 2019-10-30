<?php

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/', function () {
    return view('welcome');
});


Auth::routes();

Route::get('/home', 'HomeController@index');
Auth::routes();

Route::get('/home', 'HomeController@index')->name('home');


Route::resource('users', 'UserController');

Route::resource('templates', 'TemplateController');

Route::get('questions/{id}', 'QuestionController@create');
Route::post('question', 'QuestionController@store')->name('question.save');
Route::get('question/{id}/edit', 'QuestionController@edit')->name('question.edit');
Route::get('question/{id}', 'QuestionController@show')->name('question.show');
Route::patch('question/{id}', 'QuestionController@update')->name('question.update');
Route::delete('question/{id}', 'QuestionController@destroy')->name('question.destroy');




//Route::get('add-question', 'QuestionController@create');
//Route::get('question-create/{id}','QuestionController@create')->name('questions.create');
//Route::get('question-create/{id}','QuestionController@templateQuestion')->name('question-create');
//Route::get('questions/{id}','QuestionController@index')->name('questions.index');


Route::resource('answers', 'AnswerController');


Route::resource('allocations', 'AllocationController');

Route::resource('allocations', 'AllocationController');

Route::resource('allocations', 'AllocationController');

Route::resource('clients', 'ClientController');