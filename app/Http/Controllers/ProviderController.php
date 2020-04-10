<?php

namespace App\Http\Controllers;

use App\DataTables\ProviderDataTable;
use App\Http\Requests;
use App\Http\Requests\CreateProviderRequest;
use App\Http\Requests\UpdateProviderRequest;
use App\Repositories\ProviderRepository;
use Flash;
use App\Http\Controllers\AppBaseController;
use Response;
use App\Models\Provider;

class ProviderController extends AppBaseController
{
    /** @var  ProviderRepository */
    private $providerRepository;

    public function __construct(ProviderRepository $providerRepo)
    {
        $this->providerRepository = $providerRepo;
    }

    /**
     * Display a listing of the Provider.
     *
     * @param ProviderDataTable $providerDataTable
     * @return Response
     */
    public function index(ProviderDataTable $providerDataTable)
    {
        return $providerDataTable->render('providers.index');
    }

    /**
     * Show the form for creating a new Provider.
     *
     * @return Response
     */
    public function create()
    {
        return view('providers.create');
    }

    /**
     * Store a newly created Provider in storage.
     *
     * @param CreateProviderRequest $request
     *
     * @return Response
     */
    public function store(CreateProviderRequest $request)
    {
        $input = $request->all();

        $provider = $this->providerRepository->create($input);

        Flash::success('Provider saved successfully.');

        return redirect(route('providers.index'));
    }

    /**
     * Display the specified Provider.
     *
     * @param  int $id
     *
     * @return Response
     */
    public function show($id)
    {
        $provider = Provider::where('serviceproviderid', $id)->first();

        if (empty($provider)) {
            Flash::error('Provider not found');

            return redirect(route('providers.index'));
        }

        return view('providers.show')->with('provider', $provider);
    }

    /**
     * Show the form for editing the specified Provider.
     *
     * @param  int $id
     *
     * @return Response
     */
    public function edit($id)
    {
        $provider = Provider::where('serviceproviderid', $id)->first();

        if (empty($provider)) {
            Flash::error('Provider not found');

            return redirect(route('providers.index'));
        }

        return view('providers.edit')->with('provider', $provider);
    }

    /**
     * Update the specified Provider in storage.
     *
     * @param  int              $id
     * @param UpdateProviderRequest $request
     *
     * @return Response
     */
    public function update($id, UpdateProviderRequest $request)
    {
        $provider = Provider::where('serviceproviderid', $id)->first();

        if (empty($provider)) {
            Flash::error('Provider not found');

            return redirect(route('providers.index'));
        }

        $provider = $provider = Provider::where('serviceproviderid', $id)->update($request->all());

        Flash::success('Provider updated successfully.');

        return redirect(route('providers.index'));
    }

    /**
     * Remove the specified Provider from storage.
     *
     * @param  int $id
     *
     * @return Response
     */
    public function destroy($id)
    {
        $provider = $this->providerRepository->find($id);

        if (empty($provider)) {
            Flash::error('Provider not found');

            return redirect(route('providers.index'));
        }

        $this->providerRepository->delete($id);

        Flash::success('Provider deleted successfully.');

        return redirect(route('providers.index'));
    }
}
