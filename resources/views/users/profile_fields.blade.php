<div class="container">
<div class="row" style="font-size: larger;border: 11px">
<div class="card col-md-6">
    <div class="card-body">
{{--        <h4 class="card-title">Profile Picture</h4>--}}

        {{--        <p class="card-text">Some example text some example text. John Doe is an architect and engineer</p>--}}
        <img class="card-img-top" src="{{URL::asset('images/blue_logo_150x150.jpg')}}" alt="Card image" style="width:300px">

    </div>
    <a href="{{url('/set-profile/'.$user->id)}}">Change Profile</a>

</div>
<div class="card col-md-6">
{{--    <img class="card-img-top" src="{{asset('images/blue_logo_150x150.jpg')}}" alt="Card image" style="width:100%">--}}
    <div class="card-body">
        <h3 class="card-title">Personal Details</h3>
        <div class="form-group">
            {!! Form::label('name', 'Name:') !!}
            <p>{!! $user->name !!}</p>
        </div>
        <!-- Role Id Field -->
        <div class="form-group">
            {!! Form::label('role_id', 'Role:') !!}
            <p>{!! implode(' ,', $user->getRoleNames()->toArray()) !!}</p>
        </div>
        <!-- Email Field -->
        <div class="form-group">
            {!! Form::label('email', 'Email:') !!}
            <p>{!! $user->email !!}</p>
        </div>
        <!-- Company Id Field -->
        <div class="form-group">
            {!! Form::label('company_id', 'Company:') !!}
            <p>{!! \App\Models\Company::where('companyid', $user->company_id)->first()->companyname !!}</p>
        </div>
        <!-- Msisdn Field -->
        <div class="form-group">
            {!! Form::label('msisdn', 'Msisdn:') !!}
            <p>{!! $user->msisdn !!}</p>
        </div>

        <!-- Status Field -->
        <div class="form-group">
            {!! Form::label('status', 'Status:') !!}
            <p>{!! $user->status !!}</p>
        </div>

    </div>
</div>
</div>
<hr>
<div class="row" style="font-size: larger;border-color: #0b58a2">
    <div class="card col-md-6" >
{{--        <img class="card-img-top" src="{{asset('images/blue_logo_150x150.jpg')}}" alt="Card image" style="width:300px">--}}
        <div class="card-body">
                    <h3 class="card-title">User Management Rights</h3>
            <div class="form-group">
                {!! Form::label('', 'Permissions /Rights:') !!}
                @foreach($user->getPermissionsViaRoles() as $permission)
                    <ul>
                        <li>  {!! $permission['name'];!!}
                        </li>
                    </ul>
                @endforeach

            </div>

            {{--        <p class="card-text">Some example text some example text. John Doe is an architect and engineer</p>--}}
        </div>
    </div>
    <div class="card col-md-6">
        {{--    <img class="card-img-top" src="{{asset('images/blue_logo_150x150.jpg')}}" alt="Card image" style="width:100%">--}}
        <div class="card-body">
            <h3 class="card-title">Account Settings</h3>
                <p class="card-text"><a href="#" id="reset-id">Reset Password</a></p>

            <div id="reset-password-wrap" style="display: none">
            @include('adminlte-templates::common.errors')
            <!-- Password Field -->
                <div class="form-group col-sm-8">
                    {!! Form::label('password', 'Current Password:') !!}
                    {!! Form::password('current_password', ['class' => 'form-control', 'id' => 'current_password_id']) !!}
                </div>
                <!-- Password Field -->
                <div class="form-group col-sm-8">
                    {!! Form::label('password', 'Enter Password:') !!}
                    {!! Form::password('password', ['class' => 'form-control', 'id' => 'password_id']) !!}
                </div>
            <!-- Password Field -->
            <div class="form-group col-sm-8">
                {!! Form::label('password', 'Confirm Password:') !!}
                {!! Form::password('password_confirmation', ['class' => 'form-control', 'id' => 'password_confirmation_id',
'onChange'=>'checkPasswordMatch()']) !!}

            </div>
            <span id="confirmMessageId" class="confirmMessage col-sm-8"></span>
            <!-- Submit Field -->
            <div class="form-group col-sm-12">
                {!! Form::submit('Change Password', ['class' => 'btn btn-primary', 'id' =>'submit']) !!}
{{--                <a href="{!! route('users.index') !!}" class="btn btn-default">Cancel</a>--}}
            </div>
            </div>
        </div>
    </div>
</div>
</div>

