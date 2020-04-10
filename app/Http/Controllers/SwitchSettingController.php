<?php

namespace App\Http\Controllers;

use App\DataTables\SwitchSettingDataTable;
use App\Http\Requests;
use App\Http\Requests\CreateSwitchSettingRequest;
use App\Http\Requests\UpdateSwitchSettingRequest;
use App\Repositories\SwitchSettingRepository;
use Flash;
use App\Http\Controllers\AppBaseController;
use Response;
use App\Models\SwitchSetting;

class SwitchSettingController extends AppBaseController
{
    /** @var  SwitchSettingRepository */
    private $switchSettingRepository;

    public function __construct(SwitchSettingRepository $switchSettingRepo)
    {
        $this->switchSettingRepository = $switchSettingRepo;
    }

    /**
     * Display a listing of the SwitchSetting.
     *
     * @param SwitchSettingDataTable $switchSettingDataTable
     * @return Response
     */
    public function index(SwitchSettingDataTable $switchSettingDataTable)
    {
        return $switchSettingDataTable->render('switch_settings.index');
    }

    /**
     * Show the form for creating a new SwitchSetting.
     *
     * @return Response
     */
    public function create()
    {
        return view('switch_settings.create');
    }

    /**
     * Store a newly created SwitchSetting in storage.
     *
     * @param CreateSwitchSettingRequest $request
     *
     * @return Response
     */
    public function store(CreateSwitchSettingRequest $request)
    {
        $input = $request->all();

        $switchSetting = $this->switchSettingRepository->create($input);

        Flash::success('Switch Setting saved successfully.');

        return redirect(route('switchSettings.index'));
    }

    /**
     * Display the specified SwitchSetting.
     *
     * @param  int $id
     *
     * @return Response
     */
    public function show($id)
    {
        $switchSetting = SwitchSetting::where('setting_id', $id)->first();

        if (empty($switchSetting)) {
            Flash::error('Switch Setting not found');

            return redirect(route('switchSettings.index'));
        }

        return view('switch_settings.show')->with('switchSetting', $switchSetting);
    }

    /**
     * Show the form for editing the specified SwitchSetting.
     *
     * @param  int $id
     *
     * @return Response
     */
    public function edit($id)
    {
        $switchSetting = SwitchSetting::where('setting_id', $id)->first();


        if (empty($switchSetting)) {
            Flash::error('Switch Setting not found');

            return redirect(route('switchSettings.index'));
        }

        return view('switch_settings.edit')->with('switchSetting', $switchSetting);
    }

    /**
     * Update the specified SwitchSetting in storage.
     *
     * @param  int              $id
     * @param UpdateSwitchSettingRequest $request
     *
     * @return Response
     */
    public function update($id, UpdateSwitchSettingRequest $request)
    {
        $switchSetting = SwitchSetting::where('setting_id', $id)->first();


        if (empty($switchSetting)) {
            Flash::error('Switch Setting not found');

            return redirect(route('switchSettings.index'));
        }

        $switchSetting = SwitchSetting::where('setting_id', $id)->update($request->all());

        Flash::success('Switch Setting updated successfully.');

        return redirect(route('switchSettings.index'));
    }

    /**
     * Remove the specified SwitchSetting from storage.
     *
     * @param  int $id
     *
     * @return Response
     */
    public function destroy($id)
    {
        $switchSetting = $this->switchSettingRepository->find($id);

        if (empty($switchSetting)) {
            Flash::error('Switch Setting not found');

            return redirect(route('switchSettings.index'));
        }

        $this->switchSettingRepository->delete($id);

        Flash::success('Switch Setting deleted successfully.');

        return redirect(route('switchSettings.index'));
    }
}
