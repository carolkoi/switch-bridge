<?php

namespace WizPack\Workflow\Controllers;

use WizPack\Workflow\Repositories\ApprovalsRepository;


class RejectRequestController extends AppBaseController
{
    /** @var  ApprovalsRepository */
    private $approvalsRepository;

    public function __construct(ApprovalsRepository $approvalsRepo)
    {
        $this->approvalsRepository = $approvalsRepo;
    }
}
