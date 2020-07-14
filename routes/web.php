<?php
use App\Http\Resources\Permission;

//if (env('APP_ENV') === 'production') {
//    URL::forceSchema('https');
//}

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

//Route::group(['scheme' => 'https'], function () {
//    // Route::get(...)->name(...);
//});

Route::get('/','Auth\LoginController@showLoginForm');
//Auth::routes(['register' => false]);
Auth::routes();


//Route::get('/home', 'HomeController@index');
//Auth::routes(['register' => false, 'login' => false, 'logout' => false]);

Route::get('/home', 'HomeController@index')->name('home');

//Route::resource('trans', 'TransController');
Route::prefix('all')->group(function () {
    Route::resource('transactions', 'TransactionsController');
    Route::get('successful-transactions', 'SuccessTransactionsController@index')->name('success-transactions.index');
    Route::get('failed-transactions', 'FailedTransactionsController@index')->name('failed-transactions.index');
    Route::get('pending-transactions', 'PendingTransactionsController@index')->name('pending-transactions.index');
});
Route::get('filter-date', 'TransactionsController@filterDate')->name('transactions.filterdate');
Route::prefix('charts')->group(function () {
    Route::get('failed-vs-successful', 'ChartsController@index')->name('charts.index');
});
//Route::resource('transactions', 'TransactionsController');

Route::get('profile/{id}', 'UserController@userProfile')->name('user.profile');
Route::patch('update-password/{id}', 'UserController@updatePassword')->name('password.change');
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
    Route::resource('aml-listing', 'AmlMakerCheckerController');
    Route::get('import-source', 'AmlMakerCheckerController@getImport')->name('source.import');
//Route::post('/import-parse', 'AmlMakerCheckerController@parseImport')->name('import_parse');
    Route::post('/import-process', 'AmlMakerCheckerController@processImport')->name('import_process');
});

Route::prefix('members')->group(function () {
    Route::resource('users', 'UserController');
    Route::resource('roles', 'RoleController');
    Route::resource('permissions', 'PermissionController');

});
Route::resource('comps', 'CompController');
Route::get('/assign-permission', function () {
    return Permission::collection(\Spatie\Permission\Models\Permission::get());
});

Route::get('role-permissions/{id}', 'RoleController@permission')->name('role.permission');
Route::post('/assign-permissions/{id}', 'RoleController@assign');
Route::post('aml/media', 'AmlMakerCheckerController@storeMedia')
    ->name('aml.storeMedia');
Route::get('transaction-status/{status}', 'TransactionsController@getTransactionStatus');


Route::resource('sessionTxns', 'SessionTxnController');

Route::resource('sessionTxns', 'SessionTxnController');

Route::resource('sessionTxns', 'SessionTxnController');

Route::resource('apiTransactions', 'ApiTransactionController');

Route::resource('apiTransactions', 'ApiTransactionController');

Route::resource('apiTransactions', 'ApiTransactionController');

Route::resource('apiTransactions', 'ApiTransactionController');

Route::resource('apiTransactions', 'ApiTransactionController');

Route::resource('apiTransactions', 'ApiTransactionController');

Route::resource('sessionTxns', 'SessionTxnController');


Route::resource('partners', 'PartnerController');


//Route::resource('messageTemplates', 'messageTemplateController');
Route::prefix('notifications')->group(function () {
    Route::resource('messageTemplates', 'MessageTemplateController');
//    Route::patch('messageTemplates/{id}', 'MessageTemplateController@update')->name('messageTemplates.update');

    Route::resource('messages', 'MessageController');

    Route::resource('outboxes', 'OutboxController');

});

Route::get('/customer-messages/{phone_no}', 'MessageController@customerMessages')->name('messages.customer');
//URL::forceScheme('https');
