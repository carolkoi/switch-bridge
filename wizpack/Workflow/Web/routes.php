<?php

use Illuminate\Support\Facades\Route;

Route::group(['namespace' => 'Controllers'], function () {

    Route::resource('workflowTypes', 'WorkflowTypesController');

    Route::resource('workflowStageTypes', 'WorkflowStageTypesController');

    Route::resource('workflowStages', 'WorkflowStagesController');

    Route::resource('workflowStageCheckLists', 'WorkflowStageCheckListController');

    Route::resource('workflowStageApprovers', 'WorkflowStageApproversController');

    Route::resource('approvals', 'ApprovalsController');

    //approval/rejection
    Route::get('workflowApproveRequest/{Approvals}/{workflowStage}', 'ApproveRequestController@handle');

});