<?php

namespace WizPack\Workflow\Http\Controllers;

use App\Models\SessionTxn;
use Illuminate\Support\Facades\Auth;
use WizPack\Workflow\DataTables\ApprovalsDataTable;
use WizPack\Workflow\DataTables\FloatApprovalsDataTable;
use WizPack\Workflow\Http\Requests\CreateApprovalsRequest;
use WizPack\Workflow\Http\Requests\UpdateApprovalsRequest;
use WizPack\Workflow\Repositories\ApprovalsRepository;
use WizPack\Workflow\Transformers\ApprovalTransformer;
use Exception;
use Illuminate\Auth\Access\Response;
use Laracasts\Flash\Flash;
use League\Fractal\Manager;
use League\Fractal\Resource\Collection;
use Prettus\Validator\Exceptions\ValidatorException;

class FloatApprovalsController extends AppBaseController
{
    /** @var  ApprovalsRepository */
    private $approvalsRepository;

    public function __construct(ApprovalsRepository $approvalsRepo)
    {
        $this->approvalsRepository = $approvalsRepo;
        $this->middleware('auth');
    }

    /**
     * Display a listing of the Approvals.
     *
     * @param FloatApprovalsDataTable $floatApprovalsDataTable
     * @return Response
     */
    public function index(FloatApprovalsDataTable $floatApprovalsDataTable)
    {
        return $floatApprovalsDataTable->render('wizpack::approvals.float_index');
    }
}
