<?php
use Illuminate\Support\Facades\Route;


Route::group([
        'as'=>'wizpack-api::',
        'namespace' => 'WizPack\Workflow\Http\Controllers\API',
        'prefix'=>'api/wizpack',
        'middleware' => ['web', 'auth']]
    , function () {

        Route::resource('approvals', 'ApprovalsAPIController');
        Route::resource('workflowStages', 'WorkflowStageAPIController');
        Route::resource('workflowStageCheckLists', 'WorkflowStageCheckListAPIController');
        Route::resource('workflowStageTypes', 'WorkflowStageTypeAPIController');
        Route::resource('workflowSteps', 'WorkflowStepAPIController');
        Route::resource('workflowType', 'WorkflowStepAPIController');
        Route::resource('WorkflowStageApprovers', 'WorkflowStageApproversAPIController');
        Route::resource('WorkflowStepChecklist', 'WorkflowStepChecklistAPIController');
    }
);
