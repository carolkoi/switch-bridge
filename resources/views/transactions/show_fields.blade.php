<!-- Date Time Added Field -->
<div class="form-group">
    {!! Form::label('date_time_added', 'Date Time Added:') !!}
    <p>{!!  date('Y-m-d H:i:s',strtotime('+3 hours',strtotime(date('Y-m-d H:i:s', $transactions->date_time_added / 1000)))) !!}</p>
</div>

<!-- Added By Field -->
{{--<div class="form-group">--}}
{{--    {!! Form::label('added_by', 'Added By:') !!}--}}
{{--    <p>{!! \App\Models\User::where('id', $transactions->added_by)->first()['name'] ?  \App\Models\User::where('id', $transactions->added_by)->first()['name'] : null!!}</p>--}}
{{--</div>--}}

<!-- Date Time Modified Field -->
<div class="form-group">
    {!! Form::label('date_time_modified', 'Date Time Modified:') !!}
    <p>{!! date('Y-m-d H:i:s',strtotime('+3 hours',strtotime(date('Y-m-d H:i:s', $transactions->date_time_modified / 1000)))) !!}</p>
</div>

<!-- Modified By Field -->
<div class="form-group">
    {!! Form::label('modified_by', 'Modified By:') !!}
{{--    <p>{!! $transactions->modified_by !!}</p>--}}
    <p>{!! \App\Models\User::where('id', $transactions->modified_by)->first()['name'] ?  \App\Models\User::where('id', $transactions->modified_by)->first()['name'] : null!!}</p>

</div>

{{--<!-- Source Ip Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('source_ip', 'Source Ip:') !!}--}}
{{--    <p>{!! $transactions->source_ip !!}</p>--}}
{{--</div>--}}

{{--<!-- Latest Ip Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('latest_ip', 'Latest Ip:') !!}--}}
{{--    <p>{!! $transactions->latest_ip !!}</p>--}}
{{--</div>--}}

{{--<!-- Prev Iso Id Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('prev_iso_id', 'Prev Iso Id:') !!}--}}
{{--    <p>{!! $transactions->prev_iso_id !!}</p>--}}
{{--</div>--}}

<!-- Company Id Field -->
<div class="form-group">
    {!! Form::label('company_id', 'Company:') !!}
    <p>{!! \App\Models\Company::where('companyid',$transactions->company_id)->first()['companyname'] ?
\App\Models\Company::where('companyid',$transactions->company_id)->first()['companyname'] : null!!}</p>
</div>

{{--<!-- Need Sync Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('need_sync', 'Need Sync:') !!}--}}
{{--    <p>{!! $transactions->need_sync !!}</p>--}}
{{--</div>--}}

{{--<!-- Synced Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('synced', 'Synced:') !!}--}}
{{--    <p>{!! $transactions->synced !!}</p>--}}
{{--</div>--}}

<!-- Iso Source Field -->
<div class="form-group">
    {!! Form::label('iso_source', 'Iso Source:') !!}
    <p>{!! $transactions->iso_source !!}</p>
</div>

<!-- Iso Type Field -->
<div class="form-group">
    {!! Form::label('iso_type', 'Iso Type:') !!}
    <p>{!! $transactions->iso_type !!}</p>
</div>

<!-- Request Type Field -->
<div class="form-group">
    {!! Form::label('request_type', 'Request Type:') !!}
    <p>{!! $transactions->request_type !!}</p>
</div>

<!-- Iso Status Field -->
<div class="form-group">
    {!! Form::label('iso_status', 'Iso Status:') !!}
    <p>{!! $transactions->iso_status !!}</p>
</div>

<!-- Iso Version Field -->
{{--<div class="form-group">--}}
{{--    {!! Form::label('iso_version', 'Iso Version:') !!}--}}
{{--    <p>{!! $transactions->iso_version !!}</p>--}}
{{--</div>--}}

<!-- Req Mti Field -->
<div class="form-group">
    {!! Form::label('req_mti', 'Req Mti:') !!}
    <p>{!! $transactions->req_mti !!}</p>
</div>

<!-- Req Field1 Field -->
<div class="form-group">
    {!! Form::label('req_field1', 'Req Field1:') !!}
    <p>{!! $transactions->req_field1 !!}</p>
</div>

<!-- Req Field2 Field -->
<div class="form-group">
    {!! Form::label('req_field2', 'PAN -Primary Account Number / Sender Mobile:') !!}
    <p>{!! $transactions->req_field2 !!}</p>
</div>
<!-- Req Field3 Field -->
<div class="form-group">
    {!! Form::label('req_field3', 'Req Field3:') !!}
    <p>{!! $transactions->req_field3 !!}</p>
</div>

<!-- Req Field4 Field -->
<div class="form-group">
    {!! Form::label('req_field4', 'Amount Sent:') !!}
    <p>{!!intval($transactions->req_field4) / 100 !!}</p>
</div>

<!-- Req Field5 Field -->
<div class="form-group">
    {!! Form::label('req_field5', 'Amount Received:') !!}
    <p>{!! intval($transactions->req_field5) / 100 !!}</p>
</div>

<!-- Req Field6 Field -->
<div class="form-group">
    {!! Form::label('req_field6', 'Req Field6:') !!}
    <p>{!! $transactions->req_field6 !!}</p>
</div>

<!-- Req Field7 Field -->
<div class="form-group">
    {!! Form::label('req_field7', 'Transmission date & time:') !!}
    <p>{!! $transactions->req_field7 !!}</p>
</div>

<!-- Req Field8 Field -->
<div class="form-group">
    {!! Form::label('req_field8', 'Req Field8:') !!}
    <p>{!! $transactions->req_field8 !!}</p>
</div>

<!-- Req Field9 Field -->
<div class="form-group">
    {!! Form::label('req_field9', 'Conversion rate / Settlement:') !!}
    <p>{!! $transactions->req_field9 !!}</p>
</div>

<!-- Req Field10 Field -->
<div class="form-group">
    {!! Form::label('req_field10', 'Req Field10:') !!}
    <p>{!! $transactions->req_field10 !!}</p>
</div>

<!-- Req Field11 Field -->
<div class="form-group">
    {!! Form::label('req_field11', 'System Trace Audit Number (STAN):') !!}
    <p>{!! $transactions->req_field11 !!}</p>
</div>

<!-- Req Field12 Field -->
<div class="form-group">
    {!! Form::label('req_field12', 'Local transaction time (hhmmss):') !!}
    <p>{!! $transactions->req_field12 !!}</p>
</div>

<!-- Req Field13 Field -->
<div class="form-group">
    {!! Form::label('req_field13', 'Local transaction date (MMdd):') !!}
    <p>{!! $transactions->req_field13 !!}</p>
</div>

<!-- Req Field14 Field -->
<div class="form-group">
    {!! Form::label('req_field14', 'Expiration date (MMdd):') !!}
    <p>{!! $transactions->req_field14 !!}</p>
</div>

<!-- Req Field15 Field -->
<div class="form-group">
    {!! Form::label('req_field15', 'Settlement date (MMdd):') !!}
    <p>{!! $transactions->req_field15 !!}</p>
</div>

{{--<!-- Req Field16 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field16', 'Req Field16:') !!}--}}
{{--    <p>{!! $transactions->req_field16 !!}</p>--}}
{{--</div>--}}

{{--<!-- Req Field17 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field17', 'Req Field17:') !!}--}}
{{--    <p>{!! $transactions->req_field17 !!}</p>--}}
{{--</div>--}}

<!-- Req Field18 Field -->
<div class="form-group">
    {!! Form::label('req_field18', 'Req Field18:') !!}
    <p>{!! $transactions->req_field18 !!}</p>
</div>

<!-- Req Field19 Field -->
<div class="form-group">
    {!! Form::label('req_field19', 'Acquiring institution (country code) /Sender Country Code:') !!}
    <p>{!! $transactions->req_field19 !!}</p>
</div>

<!-- Req Field20 Field -->
<div class="form-group">
    {!! Form::label('req_field20', 'Req Field20:') !!}
    <p>{!! $transactions->req_field20 !!}</p>
</div>

<!-- Req Field21 Field -->
<div class="form-group">
    {!! Form::label('req_field21', 'Forwarding Institution (country code) / KES:') !!}
    <p>{!! $transactions->req_field21 !!}</p>
</div>

{{--<!-- Req Field22 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field22', 'Req Field22:') !!}--}}
{{--    <p>{!! $transactions->req_field22 !!}</p>--}}
{{--</div>--}}

{{--<!-- Req Field23 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field23', 'Req Field23:') !!}--}}
{{--    <p>{!! $transactions->req_field23 !!}</p>--}}
{{--</div>--}}

{{--<!-- Req Field24 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field24', 'Req Field24:') !!}--}}
{{--    <p>{!! $transactions->req_field24 !!}</p>--}}
{{--</div>--}}

{{--<!-- Req Field25 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field25', 'Req Field25:') !!}--}}
{{--    <p>{!! $transactions->req_field25 !!}</p>--}}
{{--</div>--}}

{{--<!-- Req Field26 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field26', 'Req Field26:') !!}--}}
{{--    <p>{!! $transactions->req_field26 !!}</p>--}}
{{--</div>--}}

{{--<!-- Req Field27 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field27', 'Req Field27:') !!}--}}
{{--    <p>{!! $transactions->req_field27 !!}</p>--}}
{{--</div>--}}

<!-- Req Field28 Field -->
<div class="form-group">
    {!! Form::label('req_field28', 'Transaction Fee:') !!}
    <p>{!! $transactions->req_field28 !!}</p>
</div>

<!-- Req Field29 Field -->
<div class="form-group">
    {!! Form::label('req_field29', 'Settlement Fee:') !!}
    <p>{!! $transactions->req_field29 !!}</p>
</div>

<!-- Req Field30 Field -->
<div class="form-group">
    {!! Form::label('req_field30', 'Transaction Processing Fee:') !!}
    <p>{!! $transactions->req_field30 !!}</p>
</div>

<!-- Req Field31 Field -->
<div class="form-group">
    {!! Form::label('req_field31', 'Settlement Processing Fee:') !!}
    <p>{!! $transactions->req_field31 !!}</p>
</div>

<!-- Req Field32 Field -->
<div class="form-group">
    {!! Form::label('req_field32', 'Acquiring Institution Identification Code / Partner Id:') !!}
    <p>{!! $transactions->req_field32 !!}</p>
</div>

<!-- Req Field33 Field -->
<div class="form-group">
    {!! Form::label('req_field33', 'Forwarding Institution Identification Code / Request Number:') !!}
    <p>{!! $transactions->req_field33 !!}</p>
</div>

<!-- Req Field34 Field -->
<div class="form-group">
    {!! Form::label('req_field34', 'Primary Account Number / Transaction Reference:') !!}
    <p>{!! $transactions->req_field34 !!}</p>
</div>

{{--<!-- Req Field35 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field35', 'Req Field35:') !!}--}}
{{--    <p>{!! $transactions->req_field35 !!}</p>--}}
{{--</div>--}}

{{--<!-- Req Field36 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field36', 'Req Field36:') !!}--}}
{{--    <p>{!! $transactions->req_field36 !!}</p>--}}
{{--</div>--}}

<!-- Req Field37 Field -->
<div class="form-group">
    {!! Form::label('req_field37', 'Retrieval Reference Number / Transaction Number:') !!}
    <p>{!! $transactions->req_field37 !!}</p>
</div>

{{--<!-- Req Field38 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field38', 'Req Field38:') !!}--}}
{{--    <p>{!! $transactions->req_field38 !!}</p>--}}
{{--</div>--}}

{{--<!-- Req Field39 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field39', 'Req Field39:') !!}--}}
{{--    <p>{!! $transactions->req_field39 !!}</p>--}}
{{--</div>--}}

{{--<!-- Req Field40 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field40', 'Req Field40:') !!}--}}
{{--    <p>{!! $transactions->req_field40 !!}</p>--}}
{{--</div>--}}

<!-- Req Field41 Field -->
<div class="form-group">
    {!! Form::label('req_field41', 'Req Field41:') !!}
    <p>{!! $transactions->req_field41 !!}</p>
</div>

<!-- Req Field42 Field -->
<div class="form-group">
    {!! Form::label('req_field42', 'Card Acceptor Terminal Identification (transaction_type):') !!}
    <p>{!! $transactions->req_field42 !!}</p>
</div>

{{--<!-- Req Field43 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field43', 'Req Field43:') !!}--}}
{{--    <p>{!! $transactions->req_field43 !!}</p>--}}
{{--</div>--}}

{{--<!-- Req Field44 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field44', 'Req Field44:') !!}--}}
{{--    <p>{!! $transactions->req_field44 !!}</p>--}}
{{--</div>--}}

{{--<!-- Req Field45 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field45', 'Req Field45:') !!}--}}
{{--    <p>{!! $transactions->req_field45 !!}</p>--}}
{{--</div>--}}

{{--<!-- Req Field46 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field46', 'Req Field46:') !!}--}}
{{--    <p>{!! $transactions->req_field46 !!}</p>--}}
{{--</div>--}}

{{--<!-- Req Field47 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field47', 'Req Field47:') !!}--}}
{{--    <p>{!! $transactions->req_field47 !!}</p>--}}
{{--</div>--}}

{{--<!-- Req Field48 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field48', 'Req Field48:') !!}--}}
{{--    <p>{!! $transactions->req_field48 !!}</p>--}}
{{--</div>--}}

<!-- Req Field49 Field -->
<div class="form-group">
    {!! Form::label('req_field49', 'Sender Currency Code:') !!}
    <p>{!! $transactions->req_field49 !!}</p>
</div>

<!-- Req Field50 Field -->
<div class="form-group">
    {!! Form::label('req_field50', 'Receiver Currency Code:') !!}
    <p>{!! $transactions->req_field50 !!}</p>
</div>

<!-- Req Field51 Field -->
<div class="form-group">
    {!! Form::label('req_field51', 'Req Field51:') !!}
    <p>{!! $transactions->req_field51 !!}</p>
</div>

<!-- Req Field52 Field -->
<div class="form-group">
    {!! Form::label('req_field52', 'Personal Identification Number Data / Sender ID Number:') !!}
    <p>{!! $transactions->req_field52 !!}</p>
</div>

<!-- Req Field53 Field -->
<div class="form-group">
    {!! Form::label('req_field53', 'Personal Identification Number Data / Receiver ID Number:') !!}
    <p>{!! $transactions->req_field53 !!}</p>
</div>

{{--<!-- Req Field54 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field54', 'Req Field54:') !!}--}}
{{--    <p>{!! $transactions->req_field54 !!}</p>--}}
{{--</div>--}}

{{--<!-- Req Field55 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field55', 'Req Field55:') !!}--}}
{{--    <p>{!! $transactions->req_field55 !!}</p>--}}
{{--</div>--}}

{{--<!-- Req Field56 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field56', 'Req Field56:') !!}--}}
{{--    <p>{!! $transactions->req_field56 !!}</p>--}}
{{--</div>--}}

{{--<!-- Req Field57 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field57', 'Req Field57:') !!}--}}
{{--    <p>{!! $transactions->req_field57 !!}</p>--}}
{{--</div>--}}

{{--<!-- Req Field58 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field58', 'Req Field58:') !!}--}}
{{--    <p>{!! $transactions->req_field58 !!}</p>--}}
{{--</div>--}}

{{--<!-- Req Field59 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field59', 'Req Field59:') !!}--}}
{{--    <p>{!! $transactions->req_field59 !!}</p>--}}
{{--</div>--}}

{{--<!-- Req Field60 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field60', 'Req Field60:') !!}--}}
{{--    <p>{!! $transactions->req_field60 !!}</p>--}}
{{--</div>--}}

{{--<!-- Req Field61 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field61', 'Req Field61:') !!}--}}
{{--    <p>{!! $transactions->req_field61 !!}</p>--}}
{{--</div>--}}

{{--<!-- Req Field62 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field62', 'Req Field62:') !!}--}}
{{--    <p>{!! $transactions->req_field62 !!}</p>--}}
{{--</div>--}}

{{--<!-- Req Field63 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field63', 'Req Field63:') !!}--}}
{{--    <p>{!! $transactions->req_field63 !!}</p>--}}
{{--</div>--}}

{{--<!-- Req Field64 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field64', 'Req Field64:') !!}--}}
{{--    <p>{!! $transactions->req_field64 !!}</p>--}}
{{--</div>--}}

{{--<!-- Req Field65 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field65', 'Req Field65:') !!}--}}
{{--    <p>{!! $transactions->req_field65 !!}</p>--}}
{{--</div>--}}

{{--<!-- Req Field66 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field66', 'Req Field66:') !!}--}}
{{--    <p>{!! $transactions->req_field66 !!}</p>--}}
{{--</div>--}}

{{--<!-- Req Field67 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field67', 'Req Field67:') !!}--}}
{{--    <p>{!! $transactions->req_field67 !!}</p>--}}
{{--</div>--}}

{{--<!-- Req Field68 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field68', 'Req Field68:') !!}--}}
{{--    <p>{!! $transactions->req_field68 !!}</p>--}}
{{--</div>--}}

<!-- Req Field69 Field -->
<div class="form-group">
    {!! Form::label('req_field69', 'Settlement Institution Country Code:') !!}
    <p>{!! $transactions->req_field69 !!}</p>
</div>

{{--<!-- Req Field70 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field70', 'Req Field70:') !!}--}}
{{--    <p>{!! $transactions->req_field70 !!}</p>--}}
{{--</div>--}}

{{--<!-- Req Field71 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field71', 'Req Field71:') !!}--}}
{{--    <p>{!! $transactions->req_field71 !!}</p>--}}
{{--</div>--}}

{{--<!-- Req Field72 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field72', 'Req Field72:') !!}--}}
{{--    <p>{!! $transactions->req_field72 !!}</p>--}}
{{--</div>--}}

<!-- Req Field73 Field -->
<div class="form-group">
    {!! Form::label('req_field73', 'Action date (YYMMDD) / Transaction Date:') !!}
    <p>{!! $transactions->req_field73 !!}</p>
</div>

<!-- Req Field74 Field -->
<div class="form-group">
    {!! Form::label('req_field74', 'Req Field74:') !!}
    <p>{!! $transactions->req_field74 !!}</p>
</div>

{{--<!-- Req Field75 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field75', 'Req Field75:') !!}--}}
{{--    <p>{!! $transactions->req_field75 !!}</p>--}}
{{--</div>--}}

{{--<!-- Req Field76 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field76', 'Req Field76:') !!}--}}
{{--    <p>{!! $transactions->req_field76 !!}</p>--}}
{{--</div>--}}

{{--<!-- Req Field77 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field77', 'Req Field77:') !!}--}}
{{--    <p>{!! $transactions->req_field77 !!}</p>--}}
{{--</div>--}}

{{--<!-- Req Field78 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field78', 'Req Field78:') !!}--}}
{{--    <p>{!! $transactions->req_field78 !!}</p>--}}
{{--</div>--}}

{{--<!-- Req Field79 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field79', 'Req Field79:') !!}--}}
{{--    <p>{!! $transactions->req_field79 !!}</p>--}}
{{--</div>--}}

{{--<!-- Req Field80 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field80', 'Req Field80:') !!}--}}
{{--    <p>{!! $transactions->req_field80 !!}</p>--}}
{{--</div>--}}

{{--<!-- Req Field81 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field81', 'Req Field81:') !!}--}}
{{--    <p>{!! $transactions->req_field81 !!}</p>--}}
{{--</div>--}}

{{--<!-- Req Field82 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field82', 'Req Field82:') !!}--}}
{{--    <p>{!! $transactions->req_field82 !!}</p>--}}
{{--</div>--}}

{{--<!-- Req Field83 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field83', 'Req Field83:') !!}--}}
{{--    <p>{!! $transactions->req_field83 !!}</p>--}}
{{--</div>--}}

{{--<!-- Req Field84 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field84', 'Req Field84:') !!}--}}
{{--    <p>{!! $transactions->req_field84 !!}</p>--}}
{{--</div>--}}

{{--<!-- Req Field85 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field85', 'Req Field85:') !!}--}}
{{--    <p>{!! $transactions->req_field85 !!}</p>--}}
{{--</div>--}}

{{--<!-- Req Field86 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field86', 'Req Field86:') !!}--}}
{{--    <p>{!! $transactions->req_field86 !!}</p>--}}
{{--</div>--}}

{{--<!-- Req Field87 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field87', 'Req Field87:') !!}--}}
{{--    <p>{!! $transactions->req_field87 !!}</p>--}}
{{--</div>--}}

{{--<!-- Req Field88 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field88', 'Req Field88:') !!}--}}
{{--    <p>{!! $transactions->req_field88 !!}</p>--}}
{{--</div>--}}

{{--<!-- Req Field89 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field89', 'Req Field89:') !!}--}}
{{--    <p>{!! $transactions->req_field89 !!}</p>--}}
{{--</div>--}}

{{--<!-- Req Field90 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field90', 'Req Field90:') !!}--}}
{{--    <p>{!! $transactions->req_field90 !!}</p>--}}
{{--</div>--}}

{{--<!-- Req Field91 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field91', 'Req Field91:') !!}--}}
{{--    <p>{!! $transactions->req_field91 !!}</p>--}}
{{--</div>--}}

{{--<!-- Req Field92 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field92', 'Req Field92:') !!}--}}
{{--    <p>{!! $transactions->req_field92 !!}</p>--}}
{{--</div>--}}

{{--<!-- Req Field93 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field93', 'Req Field93:') !!}--}}
{{--    <p>{!! $transactions->req_field93 !!}</p>--}}
{{--</div>--}}

{{--<!-- Req Field94 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field94', 'Req Field94:') !!}--}}
{{--    <p>{!! $transactions->req_field94 !!}</p>--}}
{{--</div>--}}

{{--<!-- Req Field95 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field95', 'Req Field95:') !!}--}}
{{--    <p>{!! $transactions->req_field95 !!}</p>--}}
{{--</div>--}}

{{--<!-- Req Field96 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field96', 'Req Field96:') !!}--}}
{{--    <p>{!! $transactions->req_field96 !!}</p>--}}
{{--</div>--}}

{{--<!-- Req Field97 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field97', 'Req Field97:') !!}--}}
{{--    <p>{!! $transactions->req_field97 !!}</p>--}}
{{--</div>--}}

{{--<!-- Req Field98 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field98', 'Req Field98:') !!}--}}
{{--    <p>{!! $transactions->req_field98 !!}</p>--}}
{{--</div>--}}

{{--<!-- Req Field99 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field99', 'Req Field99:') !!}--}}
{{--    <p>{!! $transactions->req_field99 !!}</p>--}}
{{--</div>--}}

{{--<!-- Req Field100 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field100', 'Req Field100:') !!}--}}
{{--    <p>{!! $transactions->req_field100 !!}</p>--}}
{{--</div>--}}

{{--<!-- Req Field101 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field101', 'Req Field101:') !!}--}}
{{--    <p>{!! $transactions->req_field101 !!}</p>--}}
{{--</div>--}}

<!-- Req Field102 Field -->
<div class="form-group">
    {!! Form::label('req_field102', 'Transaction Description / Receiver Mobile or Receiver Account depending on Transaction Type:') !!}
    <p>{!! $transactions->req_field102 !!}</p>
</div>

<!-- Req Field103 Field -->
<div class="form-group">
    {!! Form::label('req_field103', 'Req Field103:') !!}
    <p>{!! $transactions->req_field103 !!}</p>
</div>

<!-- Req Field104 Field -->
<div class="form-group">
    {!! Form::label('req_field104', 'Transaction Remarks:') !!}
    <p>{!! $transactions->req_field104 !!}</p>
</div>

<!-- Req Field105 Field -->
<div class="form-group">
    {!! Form::label('req_field105', 'Sender Full Name:') !!}
    <p>{!! $transactions->req_field105 !!}</p>
</div>

<!-- Req Field106 Field -->
<div class="form-group">
    {!! Form::label('req_field106', 'Sender Address:') !!}
    <p>{!! $transactions->req_field106 !!}</p>
</div>

<!-- Req Field107 Field -->
<div class="form-group">
    {!! Form::label('req_field107', 'Sender City:') !!}
    <p>{!! $transactions->req_field107 !!}</p>
</div>

<!-- Req Field108 Field -->
<div class="form-group">
    {!! Form::label('req_field108', 'Receiver Full Name:') !!}
    <p>{!! $transactions->req_field108 !!}</p>
</div>

<!-- Req Field109 Field -->
<div class="form-group">
    {!! Form::label('req_field109', 'Receiver Address:') !!}
    <p>{!! $transactions->req_field109 !!}</p>
</div>

<!-- Req Field110 Field -->
<div class="form-group">
    {!! Form::label('req_field110', 'Receiver City:') !!}
    <p>{!! $transactions->req_field110 !!}</p>
</div>

<!-- Req Field111 Field -->
<div class="form-group">
    {!! Form::label('req_field111', 'Collection Branch:') !!}
    <p>{!! $transactions->req_field111 !!}</p>
</div>

<!-- Req Field112 Field -->
<div class="form-group">
    {!! Form::label('req_field112', 'Receiver Bank:') !!}
    <p>{!! $transactions->req_field112 !!}</p>
</div>

<!-- Req Field113 Field -->
<div class="form-group">
    {!! Form::label('req_field113', 'Receiver Bank Code:') !!}
    <p>{!! $transactions->req_field113 !!}</p>
</div>

<!-- Req Field114 Field -->
<div class="form-group">
    {!! Form::label('req_field114', 'Receiver Swiftcode:') !!}
    <p>{!! $transactions->req_field114 !!}</p>
</div>

<!-- Req Field115 Field -->
<div class="form-group">
    {!! Form::label('req_field115', 'receiver Branch:') !!}
    <p>{!! $transactions->req_field115 !!}</p>
</div>

<!-- Req Field116 Field -->
<div class="form-group">
    {!! Form::label('req_field116', 'Receiver Branch Code:') !!}
    <p>{!! $transactions->req_field116 !!}</p>
</div>

<!-- Req Field117 Field -->
<div class="form-group">
    {!! Form::label('req_field117', 'Mobile Operator:') !!}
    <p>{!! $transactions->req_field117 !!}</p>
</div>

<!-- Req Field118 Field -->
<div class="form-group">
    {!! Form::label('req_field118', 'Sender ID Type:') !!}
    <p>{!! $transactions->req_field118 !!}</p>
</div>

<!-- Req Field119 Field -->
<div class="form-group">
    {!! Form::label('req_field119', 'Receiver ID Type:') !!}
    <p>{!! $transactions->req_field119 !!}</p>
</div>

<!-- Req Field120 Field -->
<div class="form-group">
    {!! Form::label('req_field120', 'Sender Type:') !!}
    <p>{!! $transactions->req_field120 !!}</p>
</div>

<!-- Req Field121 Field -->
<div class="form-group">
    {!! Form::label('req_field121', 'Receiver Type:') !!}
    <p>{!! $transactions->req_field121 !!}</p>
</div>

<!-- Req Field122 Field -->
<div class="form-group">
    {!! Form::label('req_field122', 'Req Field122:') !!}
    <p>{!! $transactions->req_field122 !!}</p>
</div>

<!-- Req Field123 Field -->
<div class="form-group">
    {!! Form::label('req_field123', 'Partner:') !!}
    <p>{!! $transactions->req_field123 !!}</p>
</div>

<!-- Req Field124 Field -->
<div class="form-group">
    {!! Form::label('req_field124', 'Req Field124:') !!}
    <p>{!! $transactions->req_field124 !!}</p>
</div>

{{--<!-- Req Field125 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field125', 'Req Field125:') !!}--}}
{{--    <p>{!! $transactions->req_field125 !!}</p>--}}
{{--</div>--}}

{{--<!-- Req Field126 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field126', 'Req Field126:') !!}--}}
{{--    <p>{!! $transactions->req_field126 !!}</p>--}}
{{--</div>--}}

{{--<!-- Req Field127 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field127', 'Req Field127:') !!}--}}
{{--    <p>{!! $transactions->req_field127 !!}</p>--}}
{{--</div>--}}

{{--<!-- Req Field128 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('req_field128', 'Req Field128:') !!}--}}
{{--    <p>{!! $transactions->req_field128 !!}</p>--}}
{{--</div>--}}

<!-- Res Mti Field -->
<div class="form-group">
    {!! Form::label('res_mti', 'Res Mti:') !!}
    <p>{!! $transactions->res_mti !!}</p>
</div>

{{--<!-- Res Field1 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field1', 'Res Field1:') !!}--}}
{{--    <p>{!! $transactions->res_field1 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field2 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field2', 'Res Field2:') !!}--}}
{{--    <p>{!! $transactions->res_field2 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field3 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field3', 'Res Field3:') !!}--}}
{{--    <p>{!! $transactions->res_field3 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field4 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field4', 'Res Field4:') !!}--}}
{{--    <p>{!! $transactions->res_field4 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field5 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field5', 'Res Field5:') !!}--}}
{{--    <p>{!! $transactions->res_field5 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field6 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field6', 'Res Field6:') !!}--}}
{{--    <p>{!! $transactions->res_field6 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field7 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field7', 'Res Field7:') !!}--}}
{{--    <p>{!! $transactions->res_field7 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field8 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field8', 'Res Field8:') !!}--}}
{{--    <p>{!! $transactions->res_field8 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field9 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field9', 'Res Field9:') !!}--}}
{{--    <p>{!! $transactions->res_field9 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field10 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field10', 'Res Field10:') !!}--}}
{{--    <p>{!! $transactions->res_field10 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field11 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field11', 'Res Field11:') !!}--}}
{{--    <p>{!! $transactions->res_field11 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field12 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field12', 'Res Field12:') !!}--}}
{{--    <p>{!! $transactions->res_field12 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field13 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field13', 'Res Field13:') !!}--}}
{{--    <p>{!! $transactions->res_field13 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field14 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field14', 'Res Field14:') !!}--}}
{{--    <p>{!! $transactions->res_field14 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field15 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field15', 'Res Field15:') !!}--}}
{{--    <p>{!! $transactions->res_field15 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field16 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field16', 'Res Field16:') !!}--}}
{{--    <p>{!! $transactions->res_field16 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field17 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field17', 'Res Field17:') !!}--}}
{{--    <p>{!! $transactions->res_field17 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field18 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field18', 'Res Field18:') !!}--}}
{{--    <p>{!! $transactions->res_field18 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field19 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field19', 'Res Field19:') !!}--}}
{{--    <p>{!! $transactions->res_field19 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field20 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field20', 'Res Field20:') !!}--}}
{{--    <p>{!! $transactions->res_field20 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field21 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field21', 'Res Field21:') !!}--}}
{{--    <p>{!! $transactions->res_field21 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field22 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field22', 'Res Field22:') !!}--}}
{{--    <p>{!! $transactions->res_field22 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field23 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field23', 'Res Field23:') !!}--}}
{{--    <p>{!! $transactions->res_field23 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field24 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field24', 'Res Field24:') !!}--}}
{{--    <p>{!! $transactions->res_field24 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field25 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field25', 'Res Field25:') !!}--}}
{{--    <p>{!! $transactions->res_field25 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field26 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field26', 'Res Field26:') !!}--}}
{{--    <p>{!! $transactions->res_field26 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field27 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field27', 'Res Field27:') !!}--}}
{{--    <p>{!! $transactions->res_field27 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field28 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field28', 'Res Field28:') !!}--}}
{{--    <p>{!! $transactions->res_field28 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field29 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field29', 'Res Field29:') !!}--}}
{{--    <p>{!! $transactions->res_field29 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field30 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field30', 'Res Field30:') !!}--}}
{{--    <p>{!! $transactions->res_field30 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field31 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field31', 'Res Field31:') !!}--}}
{{--    <p>{!! $transactions->res_field31 !!}</p>--}}
{{--</div>--}}

<!-- Res Field32 Field -->
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field32', 'Res Field32:') !!}--}}
{{--    <p>{!! $transactions->res_field32 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field33 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field33', 'Res Field33:') !!}--}}
{{--    <p>{!! $transactions->res_field33 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field34 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field34', 'Res Field34:') !!}--}}
{{--    <p>{!! $transactions->res_field34 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field35 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field35', 'Res Field35:') !!}--}}
{{--    <p>{!! $transactions->res_field35 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field36 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field36', 'Res Field36:') !!}--}}
{{--    <p>{!! $transactions->res_field36 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field37 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field37', 'Res Field37:') !!}--}}
{{--    <p>{!! $transactions->res_field37 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field38 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field38', 'Res Field38:') !!}--}}
{{--    <p>{!! $transactions->res_field38 !!}</p>--}}
{{--</div>--}}

<!-- Res Field39 Field -->
<div class="form-group">
    {!! Form::label('res_field39', 'Response Code:') !!}
    <p>{!! $transactions->res_field39 !!}</p>
</div>

{{--<!-- Res Field40 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field40', 'Res Field40:') !!}--}}
{{--    <p>{!! $transactions->res_field40 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field41 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field41', 'Res Field41:') !!}--}}
{{--    <p>{!! $transactions->res_field41 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field42 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field42', 'Res Field42:') !!}--}}
{{--    <p>{!! $transactions->res_field42 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field43 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field43', 'Res Field43:') !!}--}}
{{--    <p>{!! $transactions->res_field43 !!}</p>--}}
{{--</div>--}}

<!-- Res Field44 Field -->
<div class="form-group">
    {!! Form::label('res_field44', 'Additional Response Data:') !!}
    <p>{!! $transactions->res_field44 !!}</p>
</div>

{{--<!-- Res Field45 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field45', 'Res Field45:') !!}--}}
{{--    <p>{!! $transactions->res_field45 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field46 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field46', 'Res Field46:') !!}--}}
{{--    <p>{!! $transactions->res_field46 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field47 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field47', 'Res Field47:') !!}--}}
{{--    <p>{!! $transactions->res_field47 !!}</p>--}}
{{--</div>--}}

<!-- Res Field48 Field -->
<div class="form-group">
    {!! Form::label('res_field48', 'Transaction Status:') !!}
    <p>{!! $transactions->res_field48 !!}</p>
</div>

<!-- Res Field49 Field -->
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field49', 'Res Field49:') !!}--}}
{{--    <p>{!! $transactions->res_field49 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field50 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field50', 'Res Field50:') !!}--}}
{{--    <p>{!! $transactions->res_field50 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field51 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field51', 'Res Field51:') !!}--}}
{{--    <p>{!! $transactions->res_field51 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field52 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field52', 'Res Field52:') !!}--}}
{{--    <p>{!! $transactions->res_field52 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field53 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field53', 'Res Field53:') !!}--}}
{{--    <p>{!! $transactions->res_field53 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field54 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field54', 'Res Field54:') !!}--}}
{{--    <p>{!! $transactions->res_field54 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field55 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field55', 'Res Field55:') !!}--}}
{{--    <p>{!! $transactions->res_field55 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field56 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field56', 'Res Field56:') !!}--}}
{{--    <p>{!! $transactions->res_field56 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field57 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field57', 'Res Field57:') !!}--}}
{{--    <p>{!! $transactions->res_field57 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field58 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field58', 'Res Field58:') !!}--}}
{{--    <p>{!! $transactions->res_field58 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field59 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field59', 'Res Field59:') !!}--}}
{{--    <p>{!! $transactions->res_field59 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field60 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field60', 'Res Field60:') !!}--}}
{{--    <p>{!! $transactions->res_field60 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field61 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field61', 'Res Field61:') !!}--}}
{{--    <p>{!! $transactions->res_field61 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field62 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field62', 'Res Field62:') !!}--}}
{{--    <p>{!! $transactions->res_field62 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field63 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field63', 'Res Field63:') !!}--}}
{{--    <p>{!! $transactions->res_field63 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field64 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field64', 'Res Field64:') !!}--}}
{{--    <p>{!! $transactions->res_field64 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field65 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field65', 'Res Field65:') !!}--}}
{{--    <p>{!! $transactions->res_field65 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field66 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field66', 'Res Field66:') !!}--}}
{{--    <p>{!! $transactions->res_field66 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field67 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field67', 'Res Field67:') !!}--}}
{{--    <p>{!! $transactions->res_field67 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field68 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field68', 'Res Field68:') !!}--}}
{{--    <p>{!! $transactions->res_field68 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field69 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field69', 'Res Field69:') !!}--}}
{{--    <p>{!! $transactions->res_field69 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field70 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field70', 'Res Field70:') !!}--}}
{{--    <p>{!! $transactions->res_field70 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field71 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field71', 'Res Field71:') !!}--}}
{{--    <p>{!! $transactions->res_field71 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field72 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field72', 'Res Field72:') !!}--}}
{{--    <p>{!! $transactions->res_field72 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field73 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field73', 'Res Field73:') !!}--}}
{{--    <p>{!! $transactions->res_field73 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field74 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field74', 'Res Field74:') !!}--}}
{{--    <p>{!! $transactions->res_field74 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field75 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field75', 'Res Field75:') !!}--}}
{{--    <p>{!! $transactions->res_field75 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field76 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field76', 'Res Field76:') !!}--}}
{{--    <p>{!! $transactions->res_field76 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field77 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field77', 'Res Field77:') !!}--}}
{{--    <p>{!! $transactions->res_field77 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field78 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field78', 'Res Field78:') !!}--}}
{{--    <p>{!! $transactions->res_field78 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field79 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field79', 'Res Field79:') !!}--}}
{{--    <p>{!! $transactions->res_field79 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field80 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field80', 'Res Field80:') !!}--}}
{{--    <p>{!! $transactions->res_field80 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field81 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field81', 'Res Field81:') !!}--}}
{{--    <p>{!! $transactions->res_field81 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field82 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field82', 'Res Field82:') !!}--}}
{{--    <p>{!! $transactions->res_field82 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field83 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field83', 'Res Field83:') !!}--}}
{{--    <p>{!! $transactions->res_field83 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field84 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field84', 'Res Field84:') !!}--}}
{{--    <p>{!! $transactions->res_field84 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field85 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field85', 'Res Field85:') !!}--}}
{{--    <p>{!! $transactions->res_field85 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field86 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field86', 'Res Field86:') !!}--}}
{{--    <p>{!! $transactions->res_field86 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field87 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field87', 'Res Field87:') !!}--}}
{{--    <p>{!! $transactions->res_field87 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field88 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field88', 'Res Field88:') !!}--}}
{{--    <p>{!! $transactions->res_field88 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field89 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field89', 'Res Field89:') !!}--}}
{{--    <p>{!! $transactions->res_field89 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field90 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field90', 'Res Field90:') !!}--}}
{{--    <p>{!! $transactions->res_field90 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field91 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field91', 'Res Field91:') !!}--}}
{{--    <p>{!! $transactions->res_field91 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field92 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field92', 'Res Field92:') !!}--}}
{{--    <p>{!! $transactions->res_field92 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field93 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field93', 'Res Field93:') !!}--}}
{{--    <p>{!! $transactions->res_field93 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field94 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field94', 'Res Field94:') !!}--}}
{{--    <p>{!! $transactions->res_field94 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field95 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field95', 'Res Field95:') !!}--}}
{{--    <p>{!! $transactions->res_field95 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field96 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field96', 'Res Field96:') !!}--}}
{{--    <p>{!! $transactions->res_field96 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field97 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field97', 'Res Field97:') !!}--}}
{{--    <p>{!! $transactions->res_field97 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field98 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field98', 'Res Field98:') !!}--}}
{{--    <p>{!! $transactions->res_field98 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field99 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field99', 'Res Field99:') !!}--}}
{{--    <p>{!! $transactions->res_field99 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field100 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field100', 'Res Field100:') !!}--}}
{{--    <p>{!! $transactions->res_field100 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field101 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field101', 'Res Field101:') !!}--}}
{{--    <p>{!! $transactions->res_field101 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field102 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field102', 'Res Field102:') !!}--}}
{{--    <p>{!! $transactions->res_field102 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field103 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field103', 'Res Field103:') !!}--}}
{{--    <p>{!! $transactions->res_field103 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field104 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field104', 'Res Field104:') !!}--}}
{{--    <p>{!! $transactions->res_field104 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field105 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field105', 'Res Field105:') !!}--}}
{{--    <p>{!! $transactions->res_field105 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field106 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field106', 'Res Field106:') !!}--}}
{{--    <p>{!! $transactions->res_field106 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field107 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field107', 'Res Field107:') !!}--}}
{{--    <p>{!! $transactions->res_field107 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field108 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field108', 'Res Field108:') !!}--}}
{{--    <p>{!! $transactions->res_field108 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field109 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field109', 'Res Field109:') !!}--}}
{{--    <p>{!! $transactions->res_field109 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field110 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field110', 'Res Field110:') !!}--}}
{{--    <p>{!! $transactions->res_field110 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field111 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field111', 'Res Field111:') !!}--}}
{{--    <p>{!! $transactions->res_field111 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field112 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field112', 'Res Field112:') !!}--}}
{{--    <p>{!! $transactions->res_field112 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field113 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field113', 'Res Field113:') !!}--}}
{{--    <p>{!! $transactions->res_field113 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field114 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field114', 'Res Field114:') !!}--}}
{{--    <p>{!! $transactions->res_field114 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field115 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field115', 'Res Field115:') !!}--}}
{{--    <p>{!! $transactions->res_field115 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field116 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field116', 'Res Field116:') !!}--}}
{{--    <p>{!! $transactions->res_field116 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field117 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field117', 'Res Field117:') !!}--}}
{{--    <p>{!! $transactions->res_field117 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field118 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field118', 'Res Field118:') !!}--}}
{{--    <p>{!! $transactions->res_field118 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field119 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field119', 'Res Field119:') !!}--}}
{{--    <p>{!! $transactions->res_field119 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field120 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field120', 'Res Field120:') !!}--}}
{{--    <p>{!! $transactions->res_field120 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field121 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field121', 'Res Field121:') !!}--}}
{{--    <p>{!! $transactions->res_field121 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field122 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field122', 'Res Field122:') !!}--}}
{{--    <p>{!! $transactions->res_field122 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field123 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field123', 'Res Field123:') !!}--}}
{{--    <p>{!! $transactions->res_field123 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field124 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field124', 'Res Field124:') !!}--}}
{{--    <p>{!! $transactions->res_field124 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field125 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field125', 'Res Field125:') !!}--}}
{{--    <p>{!! $transactions->res_field125 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field126 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field126', 'Res Field126:') !!}--}}
{{--    <p>{!! $transactions->res_field126 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field127 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field127', 'Res Field127:') !!}--}}
{{--    <p>{!! $transactions->res_field127 !!}</p>--}}
{{--</div>--}}

{{--<!-- Res Field128 Field -->--}}
{{--<div class="form-group">--}}
{{--    {!! Form::label('res_field128', 'Res Field128:') !!}--}}
{{--    <p>{!! $transactions->res_field128 !!}</p>--}}
{{--</div>--}}

<!-- Request Field -->
<div class="form-group">
    {!! Form::label('request', 'Request:') !!}
    <p>{!! $transactions->request !!}</p>
</div>

<!-- Response Field -->
<div class="form-group">
    {!! Form::label('response', 'Response:') !!}
    <p>{!! $transactions->response !!}</p>
</div>

<!-- Extra Data Field -->
<div class="form-group">
    {!! Form::label('extra_data', 'Extra Data:') !!}
    <p>{!! $transactions->extra_data !!}</p>
</div>

<!-- Sync Message Field -->
<div class="form-group">
    {!! Form::label('sync_message', 'Sync Message:') !!}
    <p>{!! $transactions->sync_message !!}</p>
</div>

<!-- Need Sending Field -->
<div class="form-group">
    {!! Form::label('need_sending', 'Need Sending:') !!}
    <p>{!! $transactions->need_sending !!}</p>
</div>

<!-- Sent Field -->
<div class="form-group">
    {!! Form::label('sent', 'Sent:') !!}
    <p>{!! $transactions->sent !!}</p>
</div>

<!-- Received Field -->
<div class="form-group">
    {!! Form::label('received', 'Received:') !!}
    <p>{!! $transactions->received !!}</p>
</div>

<!-- Aml Check Field -->
<div class="form-group">
    {!! Form::label('aml_check', 'Aml Check:') !!}
    <p>{!! $transactions->aml_check !!}</p>
</div>

<!-- Aml Check Sent Field -->
<div class="form-group">
    {!! Form::label('aml_check_sent', 'Aml Check Sent:') !!}
    <p>{!! $transactions->aml_check_sent !!}</p>
</div>

<!-- Aml Check Retries Field -->
<div class="form-group">
    {!! Form::label('aml_check_retries', 'Aml Check Retries:') !!}
    <p>{!! $transactions->aml_check_retries !!}</p>
</div>

<!-- Aml Listed Field -->
<div class="form-group">
    {!! Form::label('aml_listed', 'Aml Listed:') !!}
    <p>{!! $transactions->aml_listed !!}</p>
</div>

<!-- Posted Field -->
<div class="form-group">
    {!! Form::label('posted', 'Posted:') !!}
    <p>{!! $transactions->posted !!}</p>
</div>

