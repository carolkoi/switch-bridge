<!-- Date Time Added Field -->
<div class="form-group col-sm-6">
    {!! Form::label('date_time_added', 'Date Time Added:') !!}
    {!! Form::number('date_time_added', null, ['class' => 'form-control']) !!}
</div>

<!-- Added By Field -->
<div class="form-group col-sm-6">
    {!! Form::label('added_by', 'Added By:') !!}
    {!! Form::number('added_by', null, ['class' => 'form-control']) !!}
</div>

<!-- Date Time Modified Field -->
<div class="form-group col-sm-6">
    {!! Form::label('date_time_modified', 'Date Time Modified:') !!}
    {!! Form::number('date_time_modified', null, ['class' => 'form-control']) !!}
</div>

<!-- Modified By Field -->
<div class="form-group col-sm-6">
    {!! Form::label('modified_by', 'Modified By:') !!}
    {!! Form::number('modified_by', null, ['class' => 'form-control']) !!}
</div>

<!-- Source Ip Field -->
<div class="form-group col-sm-6">
    {!! Form::label('source_ip', 'Source Ip:') !!}
    {!! Form::text('source_ip', null, ['class' => 'form-control']) !!}
</div>

<!-- Latest Ip Field -->
<div class="form-group col-sm-6">
    {!! Form::label('latest_ip', 'Latest Ip:') !!}
    {!! Form::text('latest_ip', null, ['class' => 'form-control']) !!}
</div>

<!-- Prev Iso Id Field -->
<div class="form-group col-sm-6">
    {!! Form::label('prev_iso_id', 'Prev Iso Id:') !!}
    {!! Form::number('prev_iso_id', null, ['class' => 'form-control']) !!}
</div>

<!-- Company Id Field -->
<div class="form-group col-sm-6">
    {!! Form::label('company_id', 'Company Id:') !!}
    {!! Form::number('company_id', null, ['class' => 'form-control']) !!}
</div>

<!-- Need Sync Field -->
<div class="form-group col-sm-6">
    {!! Form::label('need_sync', 'Need Sync:') !!}
    <label class="checkbox-inline">
        {!! Form::hidden('need_sync', 0) !!}
        {!! Form::checkbox('need_sync', '1', null) !!}
    </label>
</div>


<!-- Synced Field -->
<div class="form-group col-sm-6">
    {!! Form::label('synced', 'Synced:') !!}
    <label class="checkbox-inline">
        {!! Form::hidden('synced', 0) !!}
        {!! Form::checkbox('synced', '1', null) !!}
    </label>
</div>


<!-- Iso Source Field -->
<div class="form-group col-sm-6">
    {!! Form::label('iso_source', 'Iso Source:') !!}
    {!! Form::text('iso_source', null, ['class' => 'form-control']) !!}
</div>

<!-- Iso Type Field -->
<div class="form-group col-sm-6">
    {!! Form::label('iso_type', 'Iso Type:') !!}
    {!! Form::text('iso_type', null, ['class' => 'form-control']) !!}
</div>

<!-- Request Type Field -->
<div class="form-group col-sm-6">
    {!! Form::label('request_type', 'Request Type:') !!}
    {!! Form::text('request_type', null, ['class' => 'form-control']) !!}
</div>

<!-- Iso Status Field -->
<div class="form-group col-sm-6">
    {!! Form::label('iso_status', 'Iso Status:') !!}
    {!! Form::text('iso_status', null, ['class' => 'form-control']) !!}
</div>

<!-- Iso Version Field -->
<div class="form-group col-sm-6">
    {!! Form::label('iso_version', 'Iso Version:') !!}
    {!! Form::number('iso_version', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Mti Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_mti', 'Req Mti:') !!}
    {!! Form::text('req_mti', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field1 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field1', 'Req Field1:') !!}
    {!! Form::text('req_field1', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field2 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field2', 'Req Field2:') !!}
    {!! Form::text('req_field2', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field3 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field3', 'Req Field3:') !!}
    {!! Form::text('req_field3', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field4 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field4', 'Req Field4:') !!}
    {!! Form::text('req_field4', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field5 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field5', 'Req Field5:') !!}
    {!! Form::text('req_field5', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field6 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field6', 'Req Field6:') !!}
    {!! Form::text('req_field6', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field7 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field7', 'Req Field7:') !!}
    {!! Form::text('req_field7', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field8 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field8', 'Req Field8:') !!}
    {!! Form::text('req_field8', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field9 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field9', 'Req Field9:') !!}
    {!! Form::text('req_field9', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field10 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field10', 'Req Field10:') !!}
    {!! Form::text('req_field10', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field11 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field11', 'Req Field11:') !!}
    {!! Form::text('req_field11', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field12 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field12', 'Req Field12:') !!}
    {!! Form::text('req_field12', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field13 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field13', 'Req Field13:') !!}
    {!! Form::text('req_field13', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field14 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field14', 'Req Field14:') !!}
    {!! Form::text('req_field14', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field15 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field15', 'Req Field15:') !!}
    {!! Form::text('req_field15', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field16 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field16', 'Req Field16:') !!}
    {!! Form::text('req_field16', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field17 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field17', 'Req Field17:') !!}
    {!! Form::text('req_field17', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field18 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field18', 'Req Field18:') !!}
    {!! Form::text('req_field18', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field19 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field19', 'Req Field19:') !!}
    {!! Form::text('req_field19', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field20 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field20', 'Req Field20:') !!}
    {!! Form::text('req_field20', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field21 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field21', 'Req Field21:') !!}
    {!! Form::text('req_field21', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field22 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field22', 'Req Field22:') !!}
    {!! Form::text('req_field22', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field23 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field23', 'Req Field23:') !!}
    {!! Form::text('req_field23', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field24 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field24', 'Req Field24:') !!}
    {!! Form::text('req_field24', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field25 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field25', 'Req Field25:') !!}
    {!! Form::text('req_field25', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field26 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field26', 'Req Field26:') !!}
    {!! Form::text('req_field26', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field27 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field27', 'Req Field27:') !!}
    {!! Form::text('req_field27', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field28 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field28', 'Req Field28:') !!}
    {!! Form::text('req_field28', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field29 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field29', 'Req Field29:') !!}
    {!! Form::text('req_field29', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field30 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field30', 'Req Field30:') !!}
    {!! Form::text('req_field30', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field31 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field31', 'Req Field31:') !!}
    {!! Form::text('req_field31', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field32 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field32', 'Req Field32:') !!}
    {!! Form::text('req_field32', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field33 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field33', 'Req Field33:') !!}
    {!! Form::text('req_field33', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field34 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field34', 'Req Field34:') !!}
    {!! Form::text('req_field34', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field35 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field35', 'Req Field35:') !!}
    {!! Form::text('req_field35', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field36 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field36', 'Req Field36:') !!}
    {!! Form::text('req_field36', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field37 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field37', 'Req Field37:') !!}
    {!! Form::text('req_field37', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field38 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field38', 'Req Field38:') !!}
    {!! Form::text('req_field38', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field39 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field39', 'Req Field39:') !!}
    {!! Form::text('req_field39', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field40 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field40', 'Req Field40:') !!}
    {!! Form::text('req_field40', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field41 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field41', 'Req Field41:') !!}
    {!! Form::text('req_field41', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field42 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field42', 'Req Field42:') !!}
    {!! Form::text('req_field42', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field43 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field43', 'Req Field43:') !!}
    {!! Form::text('req_field43', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field44 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field44', 'Req Field44:') !!}
    {!! Form::text('req_field44', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field45 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field45', 'Req Field45:') !!}
    {!! Form::text('req_field45', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field46 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field46', 'Req Field46:') !!}
    {!! Form::text('req_field46', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field47 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field47', 'Req Field47:') !!}
    {!! Form::text('req_field47', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field48 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field48', 'Req Field48:') !!}
    {!! Form::text('req_field48', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field49 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field49', 'Req Field49:') !!}
    {!! Form::text('req_field49', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field50 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field50', 'Req Field50:') !!}
    {!! Form::text('req_field50', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field51 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field51', 'Req Field51:') !!}
    {!! Form::text('req_field51', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field52 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field52', 'Req Field52:') !!}
    {!! Form::text('req_field52', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field53 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field53', 'Req Field53:') !!}
    {!! Form::text('req_field53', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field54 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field54', 'Req Field54:') !!}
    {!! Form::text('req_field54', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field55 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field55', 'Req Field55:') !!}
    {!! Form::text('req_field55', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field56 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field56', 'Req Field56:') !!}
    {!! Form::text('req_field56', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field57 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field57', 'Req Field57:') !!}
    {!! Form::text('req_field57', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field58 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field58', 'Req Field58:') !!}
    {!! Form::text('req_field58', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field59 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field59', 'Req Field59:') !!}
    {!! Form::text('req_field59', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field60 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field60', 'Req Field60:') !!}
    {!! Form::text('req_field60', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field61 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field61', 'Req Field61:') !!}
    {!! Form::text('req_field61', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field62 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field62', 'Req Field62:') !!}
    {!! Form::text('req_field62', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field63 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field63', 'Req Field63:') !!}
    {!! Form::text('req_field63', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field64 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field64', 'Req Field64:') !!}
    {!! Form::text('req_field64', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field65 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field65', 'Req Field65:') !!}
    {!! Form::text('req_field65', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field66 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field66', 'Req Field66:') !!}
    {!! Form::text('req_field66', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field67 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field67', 'Req Field67:') !!}
    {!! Form::text('req_field67', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field68 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field68', 'Req Field68:') !!}
    {!! Form::text('req_field68', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field69 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field69', 'Req Field69:') !!}
    {!! Form::text('req_field69', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field70 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field70', 'Req Field70:') !!}
    {!! Form::text('req_field70', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field71 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field71', 'Req Field71:') !!}
    {!! Form::text('req_field71', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field72 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field72', 'Req Field72:') !!}
    {!! Form::text('req_field72', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field73 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field73', 'Req Field73:') !!}
    {!! Form::text('req_field73', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field74 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field74', 'Req Field74:') !!}
    {!! Form::text('req_field74', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field75 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field75', 'Req Field75:') !!}
    {!! Form::text('req_field75', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field76 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field76', 'Req Field76:') !!}
    {!! Form::text('req_field76', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field77 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field77', 'Req Field77:') !!}
    {!! Form::text('req_field77', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field78 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field78', 'Req Field78:') !!}
    {!! Form::text('req_field78', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field79 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field79', 'Req Field79:') !!}
    {!! Form::text('req_field79', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field80 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field80', 'Req Field80:') !!}
    {!! Form::text('req_field80', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field81 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field81', 'Req Field81:') !!}
    {!! Form::text('req_field81', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field82 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field82', 'Req Field82:') !!}
    {!! Form::text('req_field82', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field83 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field83', 'Req Field83:') !!}
    {!! Form::text('req_field83', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field84 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field84', 'Req Field84:') !!}
    {!! Form::text('req_field84', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field85 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field85', 'Req Field85:') !!}
    {!! Form::text('req_field85', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field86 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field86', 'Req Field86:') !!}
    {!! Form::text('req_field86', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field87 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field87', 'Req Field87:') !!}
    {!! Form::text('req_field87', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field88 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field88', 'Req Field88:') !!}
    {!! Form::text('req_field88', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field89 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field89', 'Req Field89:') !!}
    {!! Form::text('req_field89', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field90 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field90', 'Req Field90:') !!}
    {!! Form::text('req_field90', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field91 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field91', 'Req Field91:') !!}
    {!! Form::text('req_field91', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field92 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field92', 'Req Field92:') !!}
    {!! Form::text('req_field92', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field93 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field93', 'Req Field93:') !!}
    {!! Form::text('req_field93', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field94 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field94', 'Req Field94:') !!}
    {!! Form::text('req_field94', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field95 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field95', 'Req Field95:') !!}
    {!! Form::text('req_field95', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field96 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field96', 'Req Field96:') !!}
    {!! Form::text('req_field96', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field97 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field97', 'Req Field97:') !!}
    {!! Form::text('req_field97', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field98 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field98', 'Req Field98:') !!}
    {!! Form::text('req_field98', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field99 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field99', 'Req Field99:') !!}
    {!! Form::text('req_field99', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field100 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field100', 'Req Field100:') !!}
    {!! Form::text('req_field100', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field101 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field101', 'Req Field101:') !!}
    {!! Form::text('req_field101', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field102 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field102', 'Req Field102:') !!}
    {!! Form::text('req_field102', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field103 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field103', 'Req Field103:') !!}
    {!! Form::text('req_field103', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field104 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field104', 'Req Field104:') !!}
    {!! Form::text('req_field104', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field105 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field105', 'Req Field105:') !!}
    {!! Form::text('req_field105', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field106 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field106', 'Req Field106:') !!}
    {!! Form::text('req_field106', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field107 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field107', 'Req Field107:') !!}
    {!! Form::text('req_field107', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field108 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field108', 'Req Field108:') !!}
    {!! Form::text('req_field108', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field109 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field109', 'Req Field109:') !!}
    {!! Form::text('req_field109', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field110 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field110', 'Req Field110:') !!}
    {!! Form::text('req_field110', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field111 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field111', 'Req Field111:') !!}
    {!! Form::text('req_field111', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field112 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field112', 'Req Field112:') !!}
    {!! Form::text('req_field112', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field113 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field113', 'Req Field113:') !!}
    {!! Form::text('req_field113', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field114 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field114', 'Req Field114:') !!}
    {!! Form::text('req_field114', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field115 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field115', 'Req Field115:') !!}
    {!! Form::text('req_field115', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field116 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field116', 'Req Field116:') !!}
    {!! Form::text('req_field116', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field117 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field117', 'Req Field117:') !!}
    {!! Form::text('req_field117', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field118 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field118', 'Req Field118:') !!}
    {!! Form::text('req_field118', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field119 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field119', 'Req Field119:') !!}
    {!! Form::text('req_field119', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field120 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field120', 'Req Field120:') !!}
    {!! Form::text('req_field120', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field121 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field121', 'Req Field121:') !!}
    {!! Form::text('req_field121', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field122 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field122', 'Req Field122:') !!}
    {!! Form::text('req_field122', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field123 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field123', 'Req Field123:') !!}
    {!! Form::text('req_field123', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field124 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field124', 'Req Field124:') !!}
    {!! Form::text('req_field124', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field125 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field125', 'Req Field125:') !!}
    {!! Form::text('req_field125', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field126 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field126', 'Req Field126:') !!}
    {!! Form::text('req_field126', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field127 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field127', 'Req Field127:') !!}
    {!! Form::text('req_field127', null, ['class' => 'form-control']) !!}
</div>

<!-- Req Field128 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('req_field128', 'Req Field128:') !!}
    {!! Form::text('req_field128', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Mti Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_mti', 'Res Mti:') !!}
    {!! Form::text('res_mti', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field1 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field1', 'Res Field1:') !!}
    {!! Form::text('res_field1', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field2 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field2', 'Res Field2:') !!}
    {!! Form::text('res_field2', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field3 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field3', 'Res Field3:') !!}
    {!! Form::text('res_field3', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field4 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field4', 'Res Field4:') !!}
    {!! Form::text('res_field4', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field5 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field5', 'Res Field5:') !!}
    {!! Form::text('res_field5', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field6 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field6', 'Res Field6:') !!}
    {!! Form::text('res_field6', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field7 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field7', 'Res Field7:') !!}
    {!! Form::text('res_field7', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field8 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field8', 'Res Field8:') !!}
    {!! Form::text('res_field8', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field9 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field9', 'Res Field9:') !!}
    {!! Form::text('res_field9', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field10 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field10', 'Res Field10:') !!}
    {!! Form::text('res_field10', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field11 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field11', 'Res Field11:') !!}
    {!! Form::text('res_field11', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field12 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field12', 'Res Field12:') !!}
    {!! Form::text('res_field12', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field13 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field13', 'Res Field13:') !!}
    {!! Form::text('res_field13', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field14 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field14', 'Res Field14:') !!}
    {!! Form::text('res_field14', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field15 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field15', 'Res Field15:') !!}
    {!! Form::text('res_field15', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field16 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field16', 'Res Field16:') !!}
    {!! Form::text('res_field16', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field17 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field17', 'Res Field17:') !!}
    {!! Form::text('res_field17', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field18 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field18', 'Res Field18:') !!}
    {!! Form::text('res_field18', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field19 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field19', 'Res Field19:') !!}
    {!! Form::text('res_field19', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field20 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field20', 'Res Field20:') !!}
    {!! Form::text('res_field20', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field21 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field21', 'Res Field21:') !!}
    {!! Form::text('res_field21', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field22 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field22', 'Res Field22:') !!}
    {!! Form::text('res_field22', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field23 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field23', 'Res Field23:') !!}
    {!! Form::text('res_field23', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field24 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field24', 'Res Field24:') !!}
    {!! Form::text('res_field24', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field25 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field25', 'Res Field25:') !!}
    {!! Form::text('res_field25', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field26 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field26', 'Res Field26:') !!}
    {!! Form::text('res_field26', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field27 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field27', 'Res Field27:') !!}
    {!! Form::text('res_field27', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field28 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field28', 'Res Field28:') !!}
    {!! Form::text('res_field28', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field29 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field29', 'Res Field29:') !!}
    {!! Form::text('res_field29', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field30 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field30', 'Res Field30:') !!}
    {!! Form::text('res_field30', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field31 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field31', 'Res Field31:') !!}
    {!! Form::text('res_field31', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field32 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field32', 'Res Field32:') !!}
    {!! Form::text('res_field32', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field33 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field33', 'Res Field33:') !!}
    {!! Form::text('res_field33', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field34 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field34', 'Res Field34:') !!}
    {!! Form::text('res_field34', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field35 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field35', 'Res Field35:') !!}
    {!! Form::text('res_field35', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field36 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field36', 'Res Field36:') !!}
    {!! Form::text('res_field36', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field37 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field37', 'Res Field37:') !!}
    {!! Form::text('res_field37', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field38 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field38', 'Res Field38:') !!}
    {!! Form::text('res_field38', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field39 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field39', 'Res Field39:') !!}
    {!! Form::text('res_field39', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field40 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field40', 'Res Field40:') !!}
    {!! Form::text('res_field40', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field41 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field41', 'Res Field41:') !!}
    {!! Form::text('res_field41', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field42 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field42', 'Res Field42:') !!}
    {!! Form::text('res_field42', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field43 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field43', 'Res Field43:') !!}
    {!! Form::text('res_field43', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field44 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field44', 'Res Field44:') !!}
    {!! Form::text('res_field44', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field45 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field45', 'Res Field45:') !!}
    {!! Form::text('res_field45', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field46 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field46', 'Res Field46:') !!}
    {!! Form::text('res_field46', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field47 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field47', 'Res Field47:') !!}
    {!! Form::text('res_field47', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field48 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field48', 'Res Field48:') !!}
    {!! Form::text('res_field48', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field49 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field49', 'Res Field49:') !!}
    {!! Form::text('res_field49', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field50 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field50', 'Res Field50:') !!}
    {!! Form::text('res_field50', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field51 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field51', 'Res Field51:') !!}
    {!! Form::text('res_field51', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field52 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field52', 'Res Field52:') !!}
    {!! Form::text('res_field52', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field53 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field53', 'Res Field53:') !!}
    {!! Form::text('res_field53', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field54 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field54', 'Res Field54:') !!}
    {!! Form::text('res_field54', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field55 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field55', 'Res Field55:') !!}
    {!! Form::text('res_field55', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field56 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field56', 'Res Field56:') !!}
    {!! Form::text('res_field56', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field57 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field57', 'Res Field57:') !!}
    {!! Form::text('res_field57', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field58 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field58', 'Res Field58:') !!}
    {!! Form::text('res_field58', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field59 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field59', 'Res Field59:') !!}
    {!! Form::text('res_field59', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field60 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field60', 'Res Field60:') !!}
    {!! Form::text('res_field60', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field61 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field61', 'Res Field61:') !!}
    {!! Form::text('res_field61', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field62 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field62', 'Res Field62:') !!}
    {!! Form::text('res_field62', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field63 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field63', 'Res Field63:') !!}
    {!! Form::text('res_field63', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field64 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field64', 'Res Field64:') !!}
    {!! Form::text('res_field64', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field65 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field65', 'Res Field65:') !!}
    {!! Form::text('res_field65', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field66 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field66', 'Res Field66:') !!}
    {!! Form::text('res_field66', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field67 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field67', 'Res Field67:') !!}
    {!! Form::text('res_field67', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field68 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field68', 'Res Field68:') !!}
    {!! Form::text('res_field68', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field69 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field69', 'Res Field69:') !!}
    {!! Form::text('res_field69', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field70 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field70', 'Res Field70:') !!}
    {!! Form::text('res_field70', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field71 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field71', 'Res Field71:') !!}
    {!! Form::text('res_field71', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field72 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field72', 'Res Field72:') !!}
    {!! Form::text('res_field72', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field73 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field73', 'Res Field73:') !!}
    {!! Form::text('res_field73', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field74 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field74', 'Res Field74:') !!}
    {!! Form::text('res_field74', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field75 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field75', 'Res Field75:') !!}
    {!! Form::text('res_field75', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field76 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field76', 'Res Field76:') !!}
    {!! Form::text('res_field76', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field77 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field77', 'Res Field77:') !!}
    {!! Form::text('res_field77', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field78 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field78', 'Res Field78:') !!}
    {!! Form::text('res_field78', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field79 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field79', 'Res Field79:') !!}
    {!! Form::text('res_field79', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field80 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field80', 'Res Field80:') !!}
    {!! Form::text('res_field80', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field81 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field81', 'Res Field81:') !!}
    {!! Form::text('res_field81', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field82 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field82', 'Res Field82:') !!}
    {!! Form::text('res_field82', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field83 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field83', 'Res Field83:') !!}
    {!! Form::text('res_field83', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field84 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field84', 'Res Field84:') !!}
    {!! Form::text('res_field84', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field85 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field85', 'Res Field85:') !!}
    {!! Form::text('res_field85', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field86 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field86', 'Res Field86:') !!}
    {!! Form::text('res_field86', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field87 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field87', 'Res Field87:') !!}
    {!! Form::text('res_field87', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field88 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field88', 'Res Field88:') !!}
    {!! Form::text('res_field88', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field89 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field89', 'Res Field89:') !!}
    {!! Form::text('res_field89', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field90 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field90', 'Res Field90:') !!}
    {!! Form::text('res_field90', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field91 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field91', 'Res Field91:') !!}
    {!! Form::text('res_field91', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field92 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field92', 'Res Field92:') !!}
    {!! Form::text('res_field92', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field93 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field93', 'Res Field93:') !!}
    {!! Form::text('res_field93', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field94 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field94', 'Res Field94:') !!}
    {!! Form::text('res_field94', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field95 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field95', 'Res Field95:') !!}
    {!! Form::text('res_field95', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field96 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field96', 'Res Field96:') !!}
    {!! Form::text('res_field96', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field97 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field97', 'Res Field97:') !!}
    {!! Form::text('res_field97', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field98 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field98', 'Res Field98:') !!}
    {!! Form::text('res_field98', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field99 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field99', 'Res Field99:') !!}
    {!! Form::text('res_field99', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field100 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field100', 'Res Field100:') !!}
    {!! Form::text('res_field100', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field101 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field101', 'Res Field101:') !!}
    {!! Form::text('res_field101', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field102 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field102', 'Res Field102:') !!}
    {!! Form::text('res_field102', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field103 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field103', 'Res Field103:') !!}
    {!! Form::text('res_field103', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field104 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field104', 'Res Field104:') !!}
    {!! Form::text('res_field104', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field105 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field105', 'Res Field105:') !!}
    {!! Form::text('res_field105', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field106 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field106', 'Res Field106:') !!}
    {!! Form::text('res_field106', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field107 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field107', 'Res Field107:') !!}
    {!! Form::text('res_field107', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field108 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field108', 'Res Field108:') !!}
    {!! Form::text('res_field108', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field109 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field109', 'Res Field109:') !!}
    {!! Form::text('res_field109', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field110 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field110', 'Res Field110:') !!}
    {!! Form::text('res_field110', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field111 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field111', 'Res Field111:') !!}
    {!! Form::text('res_field111', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field112 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field112', 'Res Field112:') !!}
    {!! Form::text('res_field112', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field113 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field113', 'Res Field113:') !!}
    {!! Form::text('res_field113', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field114 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field114', 'Res Field114:') !!}
    {!! Form::text('res_field114', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field115 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field115', 'Res Field115:') !!}
    {!! Form::text('res_field115', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field116 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field116', 'Res Field116:') !!}
    {!! Form::text('res_field116', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field117 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field117', 'Res Field117:') !!}
    {!! Form::text('res_field117', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field118 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field118', 'Res Field118:') !!}
    {!! Form::text('res_field118', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field119 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field119', 'Res Field119:') !!}
    {!! Form::text('res_field119', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field120 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field120', 'Res Field120:') !!}
    {!! Form::text('res_field120', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field121 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field121', 'Res Field121:') !!}
    {!! Form::text('res_field121', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field122 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field122', 'Res Field122:') !!}
    {!! Form::text('res_field122', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field123 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field123', 'Res Field123:') !!}
    {!! Form::text('res_field123', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field124 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field124', 'Res Field124:') !!}
    {!! Form::text('res_field124', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field125 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field125', 'Res Field125:') !!}
    {!! Form::text('res_field125', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field126 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field126', 'Res Field126:') !!}
    {!! Form::text('res_field126', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field127 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field127', 'Res Field127:') !!}
    {!! Form::text('res_field127', null, ['class' => 'form-control']) !!}
</div>

<!-- Res Field128 Field -->
<div class="form-group col-sm-6">
    {!! Form::label('res_field128', 'Res Field128:') !!}
    {!! Form::text('res_field128', null, ['class' => 'form-control']) !!}
</div>

<!-- Request Field -->
<div class="form-group col-sm-6">
    {!! Form::label('request', 'Request:') !!}
    {!! Form::text('request', null, ['class' => 'form-control']) !!}
</div>

<!-- Response Field -->
<div class="form-group col-sm-6">
    {!! Form::label('response', 'Response:') !!}
    {!! Form::text('response', null, ['class' => 'form-control']) !!}
</div>

<!-- Extra Data Field -->
<div class="form-group col-sm-6">
    {!! Form::label('extra_data', 'Extra Data:') !!}
    {!! Form::text('extra_data', null, ['class' => 'form-control']) !!}
</div>

<!-- Sync Message Field -->
<div class="form-group col-sm-6">
    {!! Form::label('sync_message', 'Sync Message:') !!}
    {!! Form::text('sync_message', null, ['class' => 'form-control']) !!}
</div>

<!-- Need Sending Field -->
<div class="form-group col-sm-6">
    {!! Form::label('need_sending', 'Need Sending:') !!}
    <label class="checkbox-inline">
        {!! Form::hidden('need_sending', 0) !!}
        {!! Form::checkbox('need_sending', '1', null) !!}
    </label>
</div>


<!-- Sent Field -->
<div class="form-group col-sm-6">
    {!! Form::label('sent', 'Sent:') !!}
    <label class="checkbox-inline">
        {!! Form::hidden('sent', 0) !!}
        {!! Form::checkbox('sent', '1', null) !!}
    </label>
</div>


<!-- Received Field -->
<div class="form-group col-sm-6">
    {!! Form::label('received', 'Received:') !!}
    <label class="checkbox-inline">
        {!! Form::hidden('received', 0) !!}
        {!! Form::checkbox('received', '1', null) !!}
    </label>
</div>


<!-- Aml Check Field -->
<div class="form-group col-sm-6">
    {!! Form::label('aml_check', 'Aml Check:') !!}
    <label class="checkbox-inline">
        {!! Form::hidden('aml_check', 0) !!}
        {!! Form::checkbox('aml_check', '1', null) !!}
    </label>
</div>


<!-- Aml Check Sent Field -->
<div class="form-group col-sm-6">
    {!! Form::label('aml_check_sent', 'Aml Check Sent:') !!}
    <label class="checkbox-inline">
        {!! Form::hidden('aml_check_sent', 0) !!}
        {!! Form::checkbox('aml_check_sent', '1', null) !!}
    </label>
</div>


<!-- Aml Check Retries Field -->
<div class="form-group col-sm-6">
    {!! Form::label('aml_check_retries', 'Aml Check Retries:') !!}
    {!! Form::number('aml_check_retries', null, ['class' => 'form-control']) !!}
</div>

<!-- Aml Listed Field -->
<div class="form-group col-sm-6">
    {!! Form::label('aml_listed', 'Aml Listed:') !!}
    <label class="checkbox-inline">
        {!! Form::hidden('aml_listed', 0) !!}
        {!! Form::checkbox('aml_listed', '1', null) !!}
    </label>
</div>


<!-- Posted Field -->
<div class="form-group col-sm-6">
    {!! Form::label('posted', 'Posted:') !!}
    <label class="checkbox-inline">
        {!! Form::hidden('posted', 0) !!}
        {!! Form::checkbox('posted', '1', null) !!}
    </label>
</div>


<!-- Maker Checker Approve Status Field -->
<div class="form-group col-sm-6">
    {!! Form::label('maker_checker_approve_status', 'Maker Checker Approve Status:') !!}
    <label class="checkbox-inline">
        {!! Form::hidden('maker_checker_approve_status', 0) !!}
        {!! Form::checkbox('maker_checker_approve_status', '1', null) !!}
    </label>
</div>


<!-- Maker Checker Reject Status Field -->
<div class="form-group col-sm-6">
    {!! Form::label('maker_checker_reject_status', 'Maker Checker Reject Status:') !!}
    <label class="checkbox-inline">
        {!! Form::hidden('maker_checker_reject_status', 0) !!}
        {!! Form::checkbox('maker_checker_reject_status', '1', null) !!}
    </label>
</div>


<!-- Approved At Field -->
<div class="form-group col-sm-6">
    {!! Form::label('approved_at', 'Approved At:') !!}
    {!! Form::text('approved_at', null, ['class' => 'form-control']) !!}
</div>

<!-- Rejected At Field -->
<div class="form-group col-sm-6">
    {!! Form::label('rejected_at', 'Rejected At:') !!}
    {!! Form::text('rejected_at', null, ['class' => 'form-control']) !!}
</div>

<!-- Submit Field -->
<div class="form-group col-sm-12">
    {!! Form::submit('Save', ['class' => 'btn btn-primary']) !!}
    <a href="{{ route('tXNS.index') }}" class="btn btn-default">Cancel</a>
</div>
