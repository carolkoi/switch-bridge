<?php

use Illuminate\Support\Facades\Route;

Route::group([
    'as'=>'upesi::',
    'namespace' => 'WizPack\Workflow\Http\Controllers',
    'prefix'=>'upesi',
    'middleware' => ['web', 'auth']]
    , function () {

    Route::get('demo/test', 'ApprovalsController@index');

    Route::resource('approval-types', 'WorkflowTypesController');

    Route::resource('approval-partners', 'WorkflowStageTypesController');

    Route::resource('approval-stages', 'WorkflowStagesController');

    Route::resource('workflowStageCheckLists', 'WorkflowStageCheckListController');

    Route::resource('stage-approvers', 'WorkflowStageApproversController');

    Route::resource('approvals', 'ApprovalsController');

    //approval/rejection
    Route::get('transaction-approve-request/{Approvals}/{workflowStage}', 'ApproveRequestController@handle');

    Route::get('transaction-Reject-request/{Approvals}/{workflowStage}', 'RejectRequestController@handle');

});
