<?php /** @noinspection PhpUnused */

namespace App\Http\Controllers;

use App\DataTables\AmlMakerCheckerDataTable;
use App\Http\Requests;
use App\Imports\BlacklistImport;
use Illuminate\Support\Facades\Input;
use App\Http\Requests\CreateAmlMakerCheckerRequest;
use App\Http\Requests\UpdateAmlMakerCheckerRequest;
use App\Repositories\AmlMakerCheckerRepository;
use Flash;
use App\Http\Controllers\AppBaseController;
use Illuminate\Http\Request;
use Response;
use App\Models\AmlMakerChecker;
use Carbon\Carbon;
use Auth;
use Maatwebsite\Excel\Facades\Excel;
//use Swagger\Annotations\Contact;

class AmlMakerCheckerController extends AppBaseController
{
    /** @var  AmlMakerCheckerRepository */
    private $amlMakerCheckerRepository;

    public function __construct(AmlMakerCheckerRepository $amlMakerCheckerRepo)
    {
        $this->amlMakerCheckerRepository = $amlMakerCheckerRepo;
    }

    /**
     * Display a listing of the AmlMakerChecker.
     *
     * @param AmlMakerCheckerDataTable $amlMakerCheckerDataTable
     * @return Response
     */
    public function index(AmlMakerCheckerDataTable $amlMakerCheckerDataTable)
    {
        return $amlMakerCheckerDataTable->render('aml_maker_checkers.index');
    }

    /**
     * Show the form for creating a new AmlMakerChecker.
     *
     * @return Response
     */
    public function create()
    {
        return view('aml_maker_checkers.create');
    }

    /**
     * Store a newly created AmlMakerChecker in storage.
     *
     * @param CreateAmlMakerCheckerRequest $request
     *
     * @return \Illuminate\Http\RedirectResponse
     */
    public function store(CreateAmlMakerCheckerRequest $request)
    {
        $input = $request->all();
        if ($request->has('blacklist_source')) {
            $path = $request->file('blacklist_source')->getRealPath();
            if ($request->has('csv_header')) {
//                $data = Excel::load($path, function ($reader) {
//                })->get()->toArray();
                $data = Excel::toArray(new BlacklistImport(),$request->file('blacklist_source'))[0];
            } else {
                $data = array_map('str_getcsv', file($path));
            }
            if (count($data) > 0) {
                if ($request->has('csv_header')) {
                    $csv_header_fields = [];
                    foreach ($data[0] as $key => $value) {
                        $csv_header_fields[] = $key;
                    }
                }
                $csv_data = array_slice($data, 0, 3);
                $csv_data_file = AmlMakerChecker::create([
                    'csv_filename' => $request->file('blacklist_source')->getClientOriginalName(),
                    'csv_header' => $request->has('csv_header'),
                    'csv_data' => json_encode($data)
                ]);
            } else {
                return redirect()->back();
            }
//
            return view('aml_maker_checkers.import_table', compact('csv_data', 'csv_data_file'));
        } else {
            $input['added_by'] = Auth::user()->id;
            $input['modified_by'] = Auth::user()->id;

            $input['date_time_added'] = time();
//        dd($input);
            $amlMakerChecker = $this->amlMakerCheckerRepository->create($input);
//        dd($amlMakerChecker);
            foreach ($request->input('blacklist_source', []) as $file) {
                $amlMakerChecker->addMedia(storage_path('tmp/uploads/' . $file))->toMediaCollection('document');
            }

            Flash::success('Member blacklist record saved successfully.');

            return redirect(route('aml-listing.index'));
        }
    }

    /**
     * Display the specified AmlMakerChecker.
     *
     * @param int $id
     *
     * @return Response
     */
    public function show($blacklist_id)
    {
        $amlMakerChecker = AmlMakerChecker::where('blacklist_id', $blacklist_id)->first();


        if (empty($amlMakerChecker)) {
            Flash::error('Aml Maker Checker not found');

            return redirect(route('aml-listing.index'));
        }

        return view('aml_maker_checkers.show')->with('amlMakerChecker', $amlMakerChecker);
    }

    /**
     * Show the form for editing the specified AmlMakerChecker.
     *
     * @param int $blacklist_id
     *
     * @return Response
     */
    public function edit($blacklist_id)
    {
        $amlMakerChecker = AmlMakerChecker::where('blacklist_id', $blacklist_id)->first();

        if (empty($amlMakerChecker)) {
            Flash::error('Aml Maker Checker not found');

            return redirect(route('aml-listing.index'));
        }

        return view('aml_maker_checkers.edit')->with('amlMakerChecker', $amlMakerChecker);
    }

    /**
     * Update the specified AmlMakerChecker in storage.
     *
     * @param int $blacklist_id
     * @param UpdateAmlMakerCheckerRequest $request
     *
     * @return Response
     */
    public function update($blacklist_id, UpdateAmlMakerCheckerRequest $request)
    {
        $amlMakerChecker = AmlMakerChecker::where('blacklist_id', $blacklist_id)->first();
        if (empty($amlMakerChecker)) {
            Flash::error('Aml Maker Checker not found');

            return redirect(route('aml-listing.index'));
        }
        $input = $request->except(['_method', '_token', 'blacklist_source']);
        $input['date_time_modified'] = time();
//        dd($input);


        $amlMakerChecker = AmlMakerChecker::where('blacklist_id', $blacklist_id)->update($input);
        $amlMakerCheckerData = AmlMakerChecker::where('blacklist_id', $blacklist_id)->first();
//        dd($amlMakerCheckerData);
        if ($request->has('blacklist_source')) {

            foreach ($request->input('blacklist_source', []) as $file) {
//            dd($file, $amlMakerChecker);
                $amlMakerCheckerData->addMedia(storage_path('tmp/uploads/' . $file))->toMediaCollection('document');
            }
        }

        Flash::success('Member blacklist record updated successfully.');

        return redirect(route('aml-listing.index'));
    }

    /**
     * Remove the specified AmlMakerChecker from storage.
     *
     * @param int $id
     *
     * @return Response
     */
    public function destroy($id)
    {
        $amlMakerChecker = $this->amlMakerCheckerRepository->find($id);

        if (empty($amlMakerChecker)) {
            Flash::error('Blacklist record not found');

            return redirect(route('aml-listing.index'));
        }

        $this->amlMakerCheckerRepository->delete($id);

        Flash::success('Blacklist record deleted successfully.');

        return redirect(route('aml-listing.index'));
    }

    public function storeMedia(Request $request)
    {
        $path = storage_path('tmp/uploads');

        if (!file_exists($path)) {
            mkdir($path, 0777, true);
        }

        $file = $request->file('file');

        $name = uniqid() . '_' . trim($file->getClientOriginalName());

        $file->move($path, $name);

        return response()->json([
            'name' => $name,
            'original_name' => $file->getClientOriginalName(),
        ]);

    }

    public function getImport()
    {
        return view('aml_maker_checkers.import');
    }

    public function processImport(Request $request)
    {
//        dd($request->all());
        $data = AmlMakerChecker::find($request->blacklist_id);
        $csv_data = json_decode($data->csv_data, true);

        foreach ($csv_data as $row) {
            $record = new AmlMakerChecker();
            foreach (config('app.db_fields') as $index => $field) {
                if ($data->csv_header) {
//                    dd($row[$field]);
//                    dd($request->fields[$index]);
                    $record->$field = $row[$index];
//                    dd($record->$field);
                } else {
                    $record->$field = $row[$field];
                }
            }
            $record->save();
        }
        Flash::success('Data imported successfully.');

        return redirect(route('aml-listing.index'));

    }
}
