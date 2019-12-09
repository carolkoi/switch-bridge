@extends('layouts.app')

@section('content')
    <section class="content-header">
        <h1>
            Workflow : - {{$workflowTypes->name}}
        </h1>
    </section>
    <div class="content">
        <div class="box-body">
            <div class="row">
                <div class="col-md-12">
                    <div class="nav-tabs-custom">
                        <ul class="nav nav-tabs">
                            <li class="active"><a href="#activity" data-toggle="tab" aria-expanded="true">Stages</a>
                            </li>
                            <li class=""><a href="#timeline" data-toggle="tab" aria-expanded="false">Steps</a></li>
                            <li class=""><a href="#settings" data-toggle="tab" aria-expanded="false">Settings</a></li>
                        </ul>
                        <div class="tab-content">
                            <div class="tab-pane active" id="activity">
                                Tab 1
                            </div>

                            <div class="tab-pane" id="timeline">
                                <p>Tab 2</p>
                            </div>

                            <div class="tab-pane" id="settings">
                                <p>Tab 3</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
@endsection
