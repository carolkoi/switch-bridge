<?php

namespace App\Http\Controllers\Workflow;

use App\Repositories\Workflow\ApprovalsRepository;


class RejectRequestController extends AppBaseController
{
    /** @var  ApprovalsRepository */
    private $approvalsRepository;

    public function __construct(ApprovalsRepository $approvalsRepo)
    {
        $this->approvalsRepository = $approvalsRepo;
    }
}
