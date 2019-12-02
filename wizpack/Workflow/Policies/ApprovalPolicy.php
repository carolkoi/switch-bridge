<?php

namespace WizPack\Workflow\Policies;

use App\User;
use WizPack\Workflow\Models\Approvals;
use Illuminate\Auth\Access\HandlesAuthorization;

class ApprovalPolicy
{
    use HandlesAuthorization;
    
    /**
     * Determine whether the user can view any approvals.
     *
     * @param User $user
     * @return mixed
     */
    public function viewAny(User $user)
    {
        //
    }

    /**
     * Determine whether the user can view the approvals.
     *
     * @param User $user
     * @param Approvals $approvals
     * @return mixed
     */
    public function view(User $user, Approvals $approvals)
    {
        return $user->id == $approvals->user_id;
    }

    /**
     * Determine whether the user can create approvals.
     *
     * @param User $user
     * @return mixed
     */
    public function create(User $user)
    {
        //
    }

    /**
     * Determine whether the user can update the approvals.
     *
     * @param User $user
     * @param Approvals $approvals
     * @return mixed
     */
    public function update(User $user, Approvals $approvals)
    {
        //
    }

    /**
     * Determine whether the user can delete the approvals.
     *
     * @param User $user
     * @param Approvals $approvals
     * @return mixed
     */
    public function delete(User $user, Approvals $approvals)
    {
        //
    }

    /**
     * Determine whether the user can restore the approvals.
     *
     * @param User $user
     * @param Approvals $approvals
     * @return mixed
     */
    public function restore(User $user, Approvals $approvals)
    {
        //
    }

    /**
     * Determine whether the user can permanently delete the approvals.
     *
     * @param User $user
     * @param Approvals $approvals
     * @return mixed
     */
    public function forceDelete(User $user, Approvals $approvals)
    {
        return $user->id == $approvals->user_id;
    }
}
