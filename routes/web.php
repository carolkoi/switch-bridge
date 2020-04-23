<?php
use App\Http\Resources\Permission;

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


Route::get('/','Auth\LoginController@showLoginForm');

Auth::routes(['register' => false]);

Route::get('/home', 'HomeController@index');
//Auth::routes(['register' => false, 'login' => false, 'logout' => false]);

Route::get('/home', 'HomeController@index')->name('home');

//Route::resource('trans', 'TransController');
Route::prefix('all')->group(function () {
    Route::resource('transactions', 'TransactionsController');
    Route::get('successful-transactions', 'SuccessTransactionsController@index')->name('success-transactions.index');
    Route::get('failed-transactions', 'FailedTransactionsController@index')->name('failed-transactions.index');
    Route::get('pending-transactions', 'PendingTransactionsController@index')->name('pending-transactions.index');
});
Route::prefix('charts')->group(function () {
    Route::get('failed-vs-successful', 'ChartsController@index')->name('charts.index');
});
//Route::resource('transactions', 'TransactionsController');


Route::resource('settings', 'SettingController');

Route::resource('switchSettings', 'SwitchSettingController');

//Route::resource('companies', 'CompanyController');

//Route::resource('providers', 'ProviderController');
Route::prefix('configurations')->group(function () {
//    Route::get('failed-vs-successful', 'ChartsController@index')->name('charts.index');
//    Route::resource('globalSettings', 'GlobalSettingsController');
//    Route::resource('settings', 'SettingController');
    Route::resource('switchSettings', 'SwitchSettingController');

});
Route::prefix('list')->group(function () {
    Route::resource('companies', 'CompanyController');
});
Route::prefix('services')->group(function () {
//    Route::resource('serviceProviders', 'ServiceProvidersController');
    Route::resource('providers', 'ProviderController');

});

//Route::get('aMLCheckers', 'AML-CheckerController@index')->name('aMLCheckers.index');
//Route::resource('aMLCheckers', 'AML-CheckerController');
Route::prefix('checker')->group(function () {
//    Route::resource('serviceProviders', 'ServiceProvidersController');
    Route::resource('amlMakerCheckers', 'AmlMakerCheckerController');
});

Route::prefix('members')->group(function () {
    Route::resource('users', 'UserController');
    Route::resource('roles', 'RoleController');
    Route::resource('permissions', 'PermissionController');

});


Route::resource('roles', 'RoleController');


Route::resource('products', 'ProductController');

Route::resource('paybills', 'PaybillController');


Route::resource('comps', 'CompController');
Route::get('/assign-permission', function () {
    return Permission::collection(\App\Models\Permission::paginate(10));
});
Route::get('role-permissions/{id}', 'RoleController@permission')->name('role.permission');
Route::post('/assign-permissions/{id}', 'RoleController@assign');
Route::post('aml/media', 'AmlMakerCheckerController@storeMedia')
    ->name('aml.storeMedia');


