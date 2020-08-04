{{--<div class="row col-md-12">--}}
<div class="card">
    <div class="card-body">
        {{--        <div class="card-title">Transaction Details</div>--}}
{{--        <h3 class="card-title">Transaction Details</h3>--}}
        <div class="table-responsive  col-md-6">
            <table class="table table-striped table-hover table-bordered table-fw-widget table no-margin">
                {{--                <thead><tr>Transaction Details</tr></thead>--}}
                <tbody>
                <tr><td colspan="1" style="width: 300px">Transaction Type</td><td>{!! $transactions->req_field41 !!}</td></tr>
                {{--                <tr><td>Transaction Type</td><td>{!! $transactions->req_field122 !!}</td></tr>--}}
                <tr><td>Transaction ID</td><td>{!! $transactions->req_field42 !!}</td></tr>
                <tr><td>Bridge Reference</td><td>{!! $transactions->req_field37 !!}</td></tr>
                <tr><td>Request Number</td><td>{!! $transactions->req_field33 !!}</td></tr>
                <tr><td>Iso Source</td><td>{!! $transactions->iso_source !!}</td></tr>
                <tr><td>Iso Type</td><td>{!! $transactions->iso_type !!}</td></tr>
                <tr><td>Date Time Added</td>
                    <td>{!!  date('Y-m-d H:i:s',strtotime('+3 hours',strtotime(date('Y-m-d H:i:s', $transactions->date_time_added / 1000)))) !!}</td>
                </tr>
                <tr><td>Date Time Modified</td><td>{!! date('Y-m-d H:i:s',strtotime('+3 hours',strtotime(date('Y-m-d H:i:s', $transactions->date_time_modified / 1000)))) !!}</td></tr>

                <tr><td>Service Provider</td><td>{!! $transactions->req_field89 !!}</td></tr>
                <tr><td>Channel</td><td>{!! $transactions->req_field77 !!}</td></tr>
                <tr><td>Processing Code</td><td>{!! $transactions->req_field3 !!}</td></tr>
                <tr><td>Merchant Type</td><td>{!! $transactions->req_field18 !!}</td></tr>

                                <tr><td>Amount Sent</td><td>{!!intval($transactions->req_field4) / 100 !!}</td></tr>
                                <tr><td>Amount Received</td><td>{!! intval($transactions->req_field5) / 100 !!}</td></tr>
                <tr><td>Conversion rate / Settlement</td><td>{!! intval($transactions->req_field9) / 100 !!}</td></tr>
                <tr><td>System Trace Audit Number (STAN)</td><td>{!! $transactions->req_field11 !!}</td></tr>
                <tr><td>Forwarding Institution (country code)</td><td>{!! $transactions->req_field21 !!}</td></tr>

{{--                <tr><td>Original Message</td><td>{!! $transactions->req_field74 !!}</td></tr>--}}

{{--                <tr><td>Original Message</td><td>{!! $transactions->req_field74 !!}</td></tr>--}}

                <tr><td>Request</td><td>{!! $transactions->request !!}</td></tr>
                <tr><td>Response</td><td>{!! $transactions->response !!}</td></tr>
                <tr><td>Extra Data</td><td>{!! $transactions->extra_data !!}</td></tr>

                </tbody>
            </table>
        </div>
    </div>
</div>

        <div class="table-responsive col-md-6">
            <table class="table table-striped table-hover table-bordered table-fw-widget table no-margin">
                <tr><td>Partner ID</td><td>{!! $transactions->req_field32 !!}</td></tr>
                <tr><td>Partner Name</td><td>{!! $transactions->req_field123 !!}</td></tr>
                <tr><td>Partner Reference</td><td>{!! $transactions->req_field34 !!}</td></tr>
                <tr><td>Partner Status</td><td>{!! $transactions->req_field78 !!}</td></tr>
                <tr><td>Partner Status Name</td><td>{!! $transactions->req_field79 !!}</td></tr>

                {{--                <tr><td>Partner</td><td>{!! $transactions->req_field123 !!}</td></tr>--}}
                {{--                <tr><td>Acquiring Institution Identification Code / Partner Id</td><td>{!! $transactions->req_field32 !!}</td></tr>--}}
                {{--                <tr><td>Retrieval Reference Number / Transaction Number</td><td>{!! $transactions->req_field37 !!}</td></tr>--}}
                <tr><td>Transmission date & time</td><td>{!! $transactions->req_field7 !!}</td></tr>
                <tr><td>Local transaction time</td><td>{!! $transactions->req_field12 !!}</td></tr>
                <tr><td>Local transaction date</td><td>{!! $transactions->req_field13 !!}</td></tr>
                <tr><td>Expiration date</td><td>{!! $transactions->req_field14 !!}</td></tr>
                <tr><td>Settlement date</td><td>{!! $transactions->req_field15 !!}</td></tr>
                <tr><td>Transaction Fee</td><td>{!! intval($transactions->req_field28) / 100 !!}</td></tr>
                <tr><td>Settlement Fee</td><td>{!! intval($transactions->req_field29) / 100 !!}</td></tr>
                <tr><td>Transaction Processing Fee</td><td>{!! intval($transactions->req_field30) / 100 !!}</td></tr>
                <tr><td>Settlement Processing Fee</td><td>{!! intval($transactions->req_field31) / 100 !!}</td></tr>
                <tr><td>Sync Message</td><td>{!! $transactions->sync_message !!}</td></tr>
                <tr><td>Original Message</td><td>{!! $transactions->req_field74 !!}</td></tr>
                <tr><td>Payment Mode ID</td><td>{!! $transactions->req_field75 !!}</td></tr>
                <tr><td>Payment Mode Name</td><td>{!! $transactions->req_field76 !!}</td></tr>
{{--                <tr><td>Transaction Remarks</td><td>{!! $transactions->req_field42 !!}</td></tr>--}}
{{--                <tr><td>Additional Response Data</td><td>{!! $transactions->res_field44 !!}</td></tr>--}}
{{--                <tr><td>Transaction Status</td><td>{!! $transactions->res_field48 !!}</td></tr>--}}
                <tr><td>Need Sending</td><td>{!! $transactions->need_sending !!}</td></tr>
                <tr><td>Sent</td><td>{!! $transactions->sent !!}</td></tr>
                <tr><td>Received</td><td>{!! $transactions->received !!}</td></tr>
                <tr><td>Aml Check</td><td>{!! $transactions->aml_check !!}</td></tr>
                <tr><td>Aml Check Sent</td><td>{!! $transactions->aml_check_sent !!}</td></tr>
                <tr><td>Aml Check Retries</td><td>{!! $transactions->aml_check_retries !!}</td></tr>
                <tr><td>Aml Listed</td><td>{!! $transactions->aml_listed !!}</td></tr>
                <tr><td>Posted</td><td>{!! $transactions->posted !!}</td></tr>

            </table>
        </div>
<br>
<br/>
<br/>
<div class="card">
    <div class="card-body">
        <div class="table-responsive  col-md-6">
            <table class="table table-striped table-hover table-bordered table-fw-widget table no-margin">

                <thead><tr>        <h3 class="card-title">Sender Details</h3>
                </tr></thead>
                <tbody>
                <tr><td>Full Name</td><td>{!! $transactions->req_field105 !!}</td></tr>
                <tr><td>City</td><td>{!! $transactions->req_field107 !!}</td></tr>
                <tr><td>Address</td><td>{!! $transactions->req_field106 !!}</td></tr>
                <tr><td>Sender ID Number</td><td>{!! $transactions->req_field52 !!}</td></tr>
                <tr><td>Sender Account / Mobile</td><td>{!! $transactions->req_field2 !!}</td></tr>
                <tr><td>Currency Code</td><td>{!! $transactions->req_field49 !!}</td></tr>
{{--                <tr><td> Sender ID Number</td><td>{!! $transactions->req_field52 !!}</td></tr>--}}
                <tr><td>Sender Country Code</td><td>{!! $transactions->req_field19 !!}</td></tr>
{{--                <tr><td>Sender Account / Mobile</td><td>{!! $transactions->req_field2 !!}</td></tr>--}}
                <tr><td>Sender ID Type</td><td>{!! $transactions->req_field118 !!}</td></tr>
                <tr><td>Sender Amount</td><td>{!!intval($transactions->req_field4) / 100 !!}</td></tr>
{{--                <tr><td>Address</td><td>{!! $transactions->req_field109 !!}</td></tr>--}}
{{--                <tr><td>Address</td><td>{!! $transactions->req_field109 !!}</td></tr>--}}
{{--                <tr><td>Address</td><td>{!! $transactions->req_field109 !!}</td></tr>--}}
{{--                <tr><td>Address</td><td>{!! $transactions->req_field109 !!}</td></tr>--}}
{{--                <tr><td>Address</td><td>{!! $transactions->req_field109 !!}</td></tr>--}}
{{--                <tr><td>Address</td><td>{!! $transactions->req_field109 !!}</td></tr>--}}
{{--                <tr><td>Address</td><td>{!! $transactions->req_field109 !!}</td></tr>--}}
{{--                <tr><td>Address</td><td>{!! $transactions->req_field109 !!}</td></tr>--}}
{{--                <tr><td>Address</td><td>{!! $transactions->req_field109 !!}</td></tr>--}}

                </tbody>
            </table>
        </div>
    </div>
{{--    <div class="card col-md-6">--}}
{{--        <div class="card-body">--}}

            {{--        <h3 class="card-title">Sender Details</h3>--}}
            <div class="table-responsive  col-md-6">
                <table class="table table-striped table-hover table-bordered table-fw-widget table no-margin">
                    <thead><tr>        <h3 class="card-title">Receiver Details</h3>
                    </tr></thead>
                    <tbody>
                    <tr><td>Full Name</td><td>{!! $transactions->req_field108 !!}</td></tr>
                    <tr><td>City</td><td>{!! $transactions->req_field110 !!}</td></tr>
                    <tr><td>Address</td><td>{!! $transactions->req_field109 !!}</td></tr>
                    <tr><td>Receiver ID Number</td><td>{!! $transactions->req_field53 !!}</td></tr>
                    <tr><td>Receiver Account</td><td>{!! $transactions->req_field102 !!}</td></tr>
                    <tr><td>Currency Code</td><td>{!! $transactions->req_field50 !!}</td></tr>
                    <tr><td>Receiver Country Code</td><td>{!! $transactions->req_field69 !!}</td></tr>
                    <tr><td>Receiver ID Type</td><td>{!! $transactions->req_field119 !!}</td></tr>
                    <tr><td>Receiver Amount</td><td>{!!intval($transactions->req_field5) / 100 !!}</td></tr>

                    <tr><td>Receiver Branch</td><td>{!! $transactions->req_field115 !!}</td></tr>
                    <tr><td>Receiver Collection Branch</td><td>{!! $transactions->req_field111 !!}</td></tr>
                    <tr><td>Receiver Bank Code</td><td>{!! $transactions->req_field113 !!}</td></tr>
                    <tr><td>Receiver Bank</td><td>{!! $transactions->req_field112 !!}</td></tr>
                    <tr><td>Receiver Type</td><td>{!! $transactions->req_field121 !!}</td></tr>
                    <tr><td>Receiver Form of Payment</td><td>{!! $transactions->req_field83 !!}</td></tr>
                    <tr><td>Receiver proof of address</td><td>{!! $transactions->req_field84 !!}</td></tr>
                    <tr><td>Receiver KYC Verified</td><td>{!! $transactions->req_field85 !!}</td></tr>
                    <tr><td>Receiver Mobile Number</td><td>{!! $transactions->req_field124 !!}</td></tr>
                    <tr><td>Receiver Gender</td><td>{!! $transactions->req_field81 !!}</td></tr>
                    <tr><td>Receiver Date of Birth</td><td>{!! $transactions->req_field80 !!}</td></tr>
                    {{--                    <tr><td>Address</td><td>{!! $transactions->req_field109 !!}</td></tr>--}}
                    </tbody>
                </table>
            </div>
        </div>
<br>
<br>
<div class="card">
    <div class="card-body">
<div class="table-responsive  col-md-12">
    <table class="table table-striped table-hover table-bordered table-fw-widget table no-margin">
        <thead><tr>        <h3 class="card-title">FOR UPESI</h3>
        </tr>
        </thead>
        <tr><td>Modified By</td><td>{!! \App\Models\User::where('id', $transactions->modified_by)->first()['name'] ?  \App\Models\User::where('id', $transactions->modified_by)->first()['name'] : null!!}</td></tr>
        <tr><td>Approved / Rejected By</td><td>{!! \App\Models\User::where('id', $transactions->approved_rejected_by)->first()['name'] ?  \App\Models\User::where('id', $transactions->approved_rejected_by)->first()['name'] : null!!}
            </td>
        </tr>
    </table>
</div>
    </div>
</div>

