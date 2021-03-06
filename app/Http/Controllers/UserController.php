<?php

namespace App\Http\Controllers;

use App\DataTables\UserDataTable;
use App\Http\Requests;
use App\Http\Requests\CreateUserRequest;
use App\Http\Requests\UpdateUserRequest;
use App\Mail\AccountCreated;
use App\Models\Company;
use App\Models\Role;
use App\Models\User;
use App\Repositories\UserRepository;
use Flash;
use App\Http\Controllers\AppBaseController;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Str;
use Response;
use Spatie\Permission\Models\Permission;
use Illuminate\Http\Request;

class UserController extends AppBaseController
{
    /** @var  UserRepository */
    private $userRepository;

    public function __construct(UserRepository $userRepo)
    {
        $this->userRepository = $userRepo;
    }

    /**
     * Display a listing of the User.
     *
     * @param UserDataTable $userDataTable
     * @return Response
     */
    public function index(UserDataTable $userDataTable)
    {
//        dd(User::users()->get());
        return $userDataTable->render('users.index');
    }
//    public function index(Request $request)
//    {
////        dd(User::users()->get());
//        if ($request->ajax()) {
//            $data = User::select()->with('company')->orderBy('id', 'desc');
//            return Datatables::of($data)
//                ->addIndexColumn()
//                ->addColumn('role', function ($query){
//                    return \Spatie\Permission\Models\Role::where('id', $query->role_id)->first()['name'];
//                })
//                ->addColumn('company', function ($query){
//                    return $query->company['companyname'];
//                })
//                ->addColumn('action', 'users.datatables_actions')
//                ->rawColumns(['action'])
//                ->make(true);
//        }
//
//        return view('users.index');
//    }

    /**
     * Show the form for creating a new User.
     *
     * @return Response
     */
    public function create()
    {
        $companies = Company::pluck('companyname', 'companyid');
        $roles = \Spatie\Permission\Models\Role::pluck('name', 'id');
        return view('users.create', ['companies' => $companies, 'roles' => $roles]);
    }

    /**
     * Store a newly created User in storage.
     *
     * @param CreateUserRequest $request
     *
     * @return Response
     */
    public function store(Request $request)
    {
        $input = $request->all();
//        $user->password = Hash::make($password);
//
//        $user->setRememberToken(Str::random(60));
        $random = str_shuffle('abcdefghjklmnopqrstuvwxyzABCDEFGHJKLMNOPQRSTUVWXYZ234567890!$%^&!$%^&');
        $password = substr($random, 0, 15);
        $input['password'] = Hash::make($password);
        $input['password_confirmation'] = Hash::make($password);
        $input['status'] = "ACTIVE";
        $role = \Spatie\Permission\Models\Role::where('id', $input['role_id'])->first()->name;
        $permissions = \Spatie\Permission\Models\Permission::pluck('name');
        $user = $this->userRepository->create($input);
        $user->assignRole($role);
        Mail::to($user->email)->send(new AccountCreated($user, $password));
        Flash::success('User saved successfully.');

        return redirect(route('users.index'));
    }

    /**
     * Display the specified User.
     *
     * @param  int $id
     *
     * @return Response
     */
    public function show($id)
    {
        $user = $this->userRepository->find($id);

        if (empty($user)) {
            Flash::error('User not found');

            return redirect(route('users.index'));
        }

        return view('users.show')->with('user', $user);
    }

    /**
     * Show the form for editing the specified User.
     *
     * @param  int $id
     *
     * @return Response
     */
    public function edit($id)
    {
        $user = $this->userRepository->find($id);

        if (empty($user)) {
            Flash::error('User not found');

            return redirect(route('users.index'));
        }
        $companies = Company::pluck('companyname', 'companyid');
        $roles = \Spatie\Permission\Models\Role::pluck('name', 'id');

        return view('users.edit')->with(['user' => $user, 'companies' => $companies, 'roles' => $roles]);
    }

    /**
     * Update the specified User in storage.
     *
     * @param  int              $id
     * @param UpdateUserRequest $request
     *
     * @return Response
     */
    public function update($id, Request $request)
    {
        $random = str_shuffle('abcdefghjklmnopqrstuvwxyzABCDEFGHJKLMNOPQRSTUVWXYZ234567890!$%^&!$%^&');
        $password = substr($random, 0, 15);

        $hashed_password = Hash::make($password);
//        dd($hashed_password);
        $user = $this->userRepository->find($id);
        $input = $request->all();

        $input['password'] = $hashed_password;
        $input['password_confirmation'] = $hashed_password;


        if (empty($user)) {
            Flash::error('User not found');

            return redirect(route('users.index'));
        }
        $role = \Spatie\Permission\Models\Role::where('id', $user->role_id)->first()['name'];

        $user = $this->userRepository->update($input, $id);
        $user->syncRoles($role);
        Mail::to($user->email)->send(new AccountCreated($user, $password));
        Flash::success('User updated successfully.');

        return redirect(route('users.index'));
    }

    /**
     * Remove the specified User from storage.
     *
     * @param  int $id
     *
     * @return Response
     */
    public function destroy($id)
    {
        $user = $this->userRepository->find($id);

        if (empty($user)) {
            Flash::error('User not found');

            return redirect(route('users.index'));
        }

        $this->userRepository->delete($id);

        Flash::success('User deleted successfully.');

        return redirect(route('users.index'));
    }

    public function userProfile($id){
        $user = $this->userRepository->find($id);

        if (empty($user)) {
            Flash::error('User not found');

            return redirect(route('users.index'));
        }

        return view('users.profile')->with('user', $user);

    }

    public function updatePassword($id, Request $request){
        $user = $this->userRepository->find($id);
        $input = $request->all();
        $input['password'] = Hash::make($request->input('password'));
        $user = User::where('id', $id)->update(['password' => $input['password']]);
        Flash::success('Password updated successfully.');

        return redirect(url('profile/'.$id));

    }

    public function uploadPic($id){
        $user = $this->userRepository->find($id);
        return view('users.upload')->with('user', $user);
    }

    public function uploadSuccess(Request $request, $id){
        $user = $this->userRepository->find($id);
//        dd($user, $request->all());

    }
}
