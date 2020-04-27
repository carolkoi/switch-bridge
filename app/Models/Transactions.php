<?php

namespace App\Models;

use Carbon\Carbon;
use Eloquent as Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use WizPack\Workflow\Interfaces\ApprovableInterface;
use WizPack\Workflow\Traits\ApprovableTrait;

/**
 * @SWG\Definition(
 *      definition="Transactions",
 *      required={""},
 *      @SWG\Property(
 *          property="date_time_added",
 *          description="date_time_added",
 *          type="number",
 *          format="number"
 *      ),
 *      @SWG\Property(
 *          property="added_by",
 *          description="added_by",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="date_time_modified",
 *          description="date_time_modified",
 *          type="number",
 *          format="number"
 *      ),
 *      @SWG\Property(
 *          property="modified_by",
 *          description="modified_by",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="source_ip",
 *          description="source_ip",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="latest_ip",
 *          description="latest_ip",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="iso_id",
 *          description="iso_id",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="prev_iso_id",
 *          description="prev_iso_id",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="company_id",
 *          description="company_id",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="need_sync",
 *          description="need_sync",
 *          type="boolean"
 *      ),
 *      @SWG\Property(
 *          property="synced",
 *          description="synced",
 *          type="boolean"
 *      ),
 *      @SWG\Property(
 *          property="iso_source",
 *          description="iso_source",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="iso_type",
 *          description="iso_type",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="request_type",
 *          description="request_type",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="iso_status",
 *          description="iso_status",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="iso_version",
 *          description="iso_version",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="req_mti",
 *          description="req_mti",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field1",
 *          description="req_field1",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field2",
 *          description="req_field2",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field3",
 *          description="req_field3",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field4",
 *          description="req_field4",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field5",
 *          description="req_field5",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field6",
 *          description="req_field6",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field7",
 *          description="req_field7",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field8",
 *          description="req_field8",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field9",
 *          description="req_field9",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field10",
 *          description="req_field10",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field11",
 *          description="req_field11",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field12",
 *          description="req_field12",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field13",
 *          description="req_field13",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field14",
 *          description="req_field14",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field15",
 *          description="req_field15",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field16",
 *          description="req_field16",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field17",
 *          description="req_field17",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field18",
 *          description="req_field18",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field19",
 *          description="req_field19",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field20",
 *          description="req_field20",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field21",
 *          description="req_field21",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field22",
 *          description="req_field22",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field23",
 *          description="req_field23",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field24",
 *          description="req_field24",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field25",
 *          description="req_field25",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field26",
 *          description="req_field26",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field27",
 *          description="req_field27",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field28",
 *          description="req_field28",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field29",
 *          description="req_field29",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field30",
 *          description="req_field30",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field31",
 *          description="req_field31",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field32",
 *          description="req_field32",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field33",
 *          description="req_field33",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field34",
 *          description="req_field34",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field35",
 *          description="req_field35",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field36",
 *          description="req_field36",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field37",
 *          description="req_field37",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field38",
 *          description="req_field38",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field39",
 *          description="req_field39",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field40",
 *          description="req_field40",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field41",
 *          description="req_field41",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field42",
 *          description="req_field42",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field43",
 *          description="req_field43",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field44",
 *          description="req_field44",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field45",
 *          description="req_field45",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field46",
 *          description="req_field46",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field47",
 *          description="req_field47",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field48",
 *          description="req_field48",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field49",
 *          description="req_field49",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field50",
 *          description="req_field50",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field51",
 *          description="req_field51",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field52",
 *          description="req_field52",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field53",
 *          description="req_field53",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field54",
 *          description="req_field54",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field55",
 *          description="req_field55",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field56",
 *          description="req_field56",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field57",
 *          description="req_field57",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field58",
 *          description="req_field58",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field59",
 *          description="req_field59",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field60",
 *          description="req_field60",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field61",
 *          description="req_field61",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field62",
 *          description="req_field62",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field63",
 *          description="req_field63",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field64",
 *          description="req_field64",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field65",
 *          description="req_field65",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field66",
 *          description="req_field66",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field67",
 *          description="req_field67",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field68",
 *          description="req_field68",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field69",
 *          description="req_field69",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field70",
 *          description="req_field70",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field71",
 *          description="req_field71",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field72",
 *          description="req_field72",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field73",
 *          description="req_field73",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field74",
 *          description="req_field74",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field75",
 *          description="req_field75",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field76",
 *          description="req_field76",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field77",
 *          description="req_field77",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field78",
 *          description="req_field78",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field79",
 *          description="req_field79",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field80",
 *          description="req_field80",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field81",
 *          description="req_field81",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field82",
 *          description="req_field82",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field83",
 *          description="req_field83",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field84",
 *          description="req_field84",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field85",
 *          description="req_field85",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field86",
 *          description="req_field86",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field87",
 *          description="req_field87",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field88",
 *          description="req_field88",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field89",
 *          description="req_field89",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field90",
 *          description="req_field90",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field91",
 *          description="req_field91",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field92",
 *          description="req_field92",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field93",
 *          description="req_field93",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field94",
 *          description="req_field94",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field95",
 *          description="req_field95",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field96",
 *          description="req_field96",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field97",
 *          description="req_field97",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field98",
 *          description="req_field98",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field99",
 *          description="req_field99",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field100",
 *          description="req_field100",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field101",
 *          description="req_field101",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field102",
 *          description="req_field102",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field103",
 *          description="req_field103",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field104",
 *          description="req_field104",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field105",
 *          description="req_field105",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field106",
 *          description="req_field106",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field107",
 *          description="req_field107",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field108",
 *          description="req_field108",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field109",
 *          description="req_field109",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field110",
 *          description="req_field110",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field111",
 *          description="req_field111",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field112",
 *          description="req_field112",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field113",
 *          description="req_field113",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field114",
 *          description="req_field114",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field115",
 *          description="req_field115",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field116",
 *          description="req_field116",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field117",
 *          description="req_field117",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field118",
 *          description="req_field118",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field119",
 *          description="req_field119",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field120",
 *          description="req_field120",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field121",
 *          description="req_field121",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field122",
 *          description="req_field122",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field123",
 *          description="req_field123",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field124",
 *          description="req_field124",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field125",
 *          description="req_field125",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field126",
 *          description="req_field126",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field127",
 *          description="req_field127",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="req_field128",
 *          description="req_field128",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_mti",
 *          description="res_mti",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field1",
 *          description="res_field1",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field2",
 *          description="res_field2",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field3",
 *          description="res_field3",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field4",
 *          description="res_field4",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field5",
 *          description="res_field5",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field6",
 *          description="res_field6",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field7",
 *          description="res_field7",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field8",
 *          description="res_field8",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field9",
 *          description="res_field9",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field10",
 *          description="res_field10",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field11",
 *          description="res_field11",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field12",
 *          description="res_field12",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field13",
 *          description="res_field13",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field14",
 *          description="res_field14",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field15",
 *          description="res_field15",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field16",
 *          description="res_field16",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field17",
 *          description="res_field17",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field18",
 *          description="res_field18",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field19",
 *          description="res_field19",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field20",
 *          description="res_field20",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field21",
 *          description="res_field21",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field22",
 *          description="res_field22",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field23",
 *          description="res_field23",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field24",
 *          description="res_field24",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field25",
 *          description="res_field25",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field26",
 *          description="res_field26",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field27",
 *          description="res_field27",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field28",
 *          description="res_field28",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field29",
 *          description="res_field29",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field30",
 *          description="res_field30",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field31",
 *          description="res_field31",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field32",
 *          description="res_field32",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field33",
 *          description="res_field33",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field34",
 *          description="res_field34",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field35",
 *          description="res_field35",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field36",
 *          description="res_field36",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field37",
 *          description="res_field37",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field38",
 *          description="res_field38",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field39",
 *          description="res_field39",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field40",
 *          description="res_field40",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field41",
 *          description="res_field41",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field42",
 *          description="res_field42",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field43",
 *          description="res_field43",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field44",
 *          description="res_field44",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field45",
 *          description="res_field45",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field46",
 *          description="res_field46",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field47",
 *          description="res_field47",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field48",
 *          description="res_field48",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field49",
 *          description="res_field49",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field50",
 *          description="res_field50",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field51",
 *          description="res_field51",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field52",
 *          description="res_field52",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field53",
 *          description="res_field53",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field54",
 *          description="res_field54",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field55",
 *          description="res_field55",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field56",
 *          description="res_field56",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field57",
 *          description="res_field57",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field58",
 *          description="res_field58",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field59",
 *          description="res_field59",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field60",
 *          description="res_field60",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field61",
 *          description="res_field61",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field62",
 *          description="res_field62",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field63",
 *          description="res_field63",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field64",
 *          description="res_field64",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field65",
 *          description="res_field65",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field66",
 *          description="res_field66",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field67",
 *          description="res_field67",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field68",
 *          description="res_field68",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field69",
 *          description="res_field69",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field70",
 *          description="res_field70",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field71",
 *          description="res_field71",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field72",
 *          description="res_field72",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field73",
 *          description="res_field73",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field74",
 *          description="res_field74",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field75",
 *          description="res_field75",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field76",
 *          description="res_field76",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field77",
 *          description="res_field77",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field78",
 *          description="res_field78",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field79",
 *          description="res_field79",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field80",
 *          description="res_field80",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field81",
 *          description="res_field81",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field82",
 *          description="res_field82",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field83",
 *          description="res_field83",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field84",
 *          description="res_field84",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field85",
 *          description="res_field85",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field86",
 *          description="res_field86",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field87",
 *          description="res_field87",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field88",
 *          description="res_field88",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field89",
 *          description="res_field89",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field90",
 *          description="res_field90",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field91",
 *          description="res_field91",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field92",
 *          description="res_field92",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field93",
 *          description="res_field93",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field94",
 *          description="res_field94",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field95",
 *          description="res_field95",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field96",
 *          description="res_field96",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field97",
 *          description="res_field97",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field98",
 *          description="res_field98",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field99",
 *          description="res_field99",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field100",
 *          description="res_field100",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field101",
 *          description="res_field101",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field102",
 *          description="res_field102",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field103",
 *          description="res_field103",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field104",
 *          description="res_field104",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field105",
 *          description="res_field105",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field106",
 *          description="res_field106",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field107",
 *          description="res_field107",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field108",
 *          description="res_field108",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field109",
 *          description="res_field109",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field110",
 *          description="res_field110",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field111",
 *          description="res_field111",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field112",
 *          description="res_field112",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field113",
 *          description="res_field113",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field114",
 *          description="res_field114",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field115",
 *          description="res_field115",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field116",
 *          description="res_field116",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field117",
 *          description="res_field117",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field118",
 *          description="res_field118",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field119",
 *          description="res_field119",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field120",
 *          description="res_field120",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field121",
 *          description="res_field121",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field122",
 *          description="res_field122",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field123",
 *          description="res_field123",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field124",
 *          description="res_field124",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field125",
 *          description="res_field125",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field126",
 *          description="res_field126",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field127",
 *          description="res_field127",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="res_field128",
 *          description="res_field128",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="request",
 *          description="request",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="response",
 *          description="response",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="extra_data",
 *          description="extra_data",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="sync_message",
 *          description="sync_message",
 *          type="string"
 *      ),
 *      @SWG\Property(
 *          property="need_sending",
 *          description="need_sending",
 *          type="boolean"
 *      ),
 *      @SWG\Property(
 *          property="sent",
 *          description="sent",
 *          type="boolean"
 *      ),
 *      @SWG\Property(
 *          property="received",
 *          description="received",
 *          type="boolean"
 *      ),
 *      @SWG\Property(
 *          property="aml_check",
 *          description="aml_check",
 *          type="boolean"
 *      ),
 *      @SWG\Property(
 *          property="aml_check_sent",
 *          description="aml_check_sent",
 *          type="boolean"
 *      ),
 *      @SWG\Property(
 *          property="aml_check_retries",
 *          description="aml_check_retries",
 *          type="integer",
 *          format="int32"
 *      ),
 *      @SWG\Property(
 *          property="aml_listed",
 *          description="aml_listed",
 *          type="boolean"
 *      ),
 *      @SWG\Property(
 *          property="posted",
 *          description="posted",
 *          type="boolean"
 *      )
 * )
 */
class Transactions extends Model implements ApprovableInterface
{
    use SoftDeletes ,ApprovableTrait;

    public $table = 'tbl_sys_iso';
    public $primaryKey = 'iso_id';

    const CREATED_AT = 'created_at';
    const UPDATED_AT = 'updated_at';


    protected $dates = ['deleted_at'];
    public $timestamps = false;




    public $fillable = [
        'date_time_added',
        'added_by',
        'date_time_modified',
        'modified_by',
        'source_ip',
        'latest_ip',
        'prev_iso_id',
        'company_id',
        'need_sync',
        'synced',
        'iso_source',
        'iso_type',
        'request_type',
        'iso_status',
        'iso_version',
        'req_mti',
        'req_field1',
        'req_field2',
        'req_field3',
        'req_field4',
        'req_field5',
        'req_field6',
        'req_field7',
        'req_field8',
        'req_field9',
        'req_field10',
        'req_field11',
        'req_field12',
        'req_field13',
        'req_field14',
        'req_field15',
        'req_field16',
        'req_field17',
        'req_field18',
        'req_field19',
        'req_field20',
        'req_field21',
        'req_field22',
        'req_field23',
        'req_field24',
        'req_field25',
        'req_field26',
        'req_field27',
        'req_field28',
        'req_field29',
        'req_field30',
        'req_field31',
        'req_field32',
        'req_field33',
        'req_field34',
        'req_field35',
        'req_field36',
        'req_field37',
        'req_field38',
        'req_field39',
        'req_field40',
        'req_field41',
        'req_field42',
        'req_field43',
        'req_field44',
        'req_field45',
        'req_field46',
        'req_field47',
        'req_field48',
        'req_field49',
        'req_field50',
        'req_field51',
        'req_field52',
        'req_field53',
        'req_field54',
        'req_field55',
        'req_field56',
        'req_field57',
        'req_field58',
        'req_field59',
        'req_field60',
        'req_field61',
        'req_field62',
        'req_field63',
        'req_field64',
        'req_field65',
        'req_field66',
        'req_field67',
        'req_field68',
        'req_field69',
        'req_field70',
        'req_field71',
        'req_field72',
        'req_field73',
        'req_field74',
        'req_field75',
        'req_field76',
        'req_field77',
        'req_field78',
        'req_field79',
        'req_field80',
        'req_field81',
        'req_field82',
        'req_field83',
        'req_field84',
        'req_field85',
        'req_field86',
        'req_field87',
        'req_field88',
        'req_field89',
        'req_field90',
        'req_field91',
        'req_field92',
        'req_field93',
        'req_field94',
        'req_field95',
        'req_field96',
        'req_field97',
        'req_field98',
        'req_field99',
        'req_field100',
        'req_field101',
        'req_field102',
        'req_field103',
        'req_field104',
        'req_field105',
        'req_field106',
        'req_field107',
        'req_field108',
        'req_field109',
        'req_field110',
        'req_field111',
        'req_field112',
        'req_field113',
        'req_field114',
        'req_field115',
        'req_field116',
        'req_field117',
        'req_field118',
        'req_field119',
        'req_field120',
        'req_field121',
        'req_field122',
        'req_field123',
        'req_field124',
        'req_field125',
        'req_field126',
        'req_field127',
        'req_field128',
        'res_mti',
        'res_field1',
        'res_field2',
        'res_field3',
        'res_field4',
        'res_field5',
        'res_field6',
        'res_field7',
        'res_field8',
        'res_field9',
        'res_field10',
        'res_field11',
        'res_field12',
        'res_field13',
        'res_field14',
        'res_field15',
        'res_field16',
        'res_field17',
        'res_field18',
        'res_field19',
        'res_field20',
        'res_field21',
        'res_field22',
        'res_field23',
        'res_field24',
        'res_field25',
        'res_field26',
        'res_field27',
        'res_field28',
        'res_field29',
        'res_field30',
        'res_field31',
        'res_field32',
        'res_field33',
        'res_field34',
        'res_field35',
        'res_field36',
        'res_field37',
        'res_field38',
        'res_field39',
        'res_field40',
        'res_field41',
        'res_field42',
        'res_field43',
        'res_field44',
        'res_field45',
        'res_field46',
        'res_field47',
        'res_field48',
        'res_field49',
        'res_field50',
        'res_field51',
        'res_field52',
        'res_field53',
        'res_field54',
        'res_field55',
        'res_field56',
        'res_field57',
        'res_field58',
        'res_field59',
        'res_field60',
        'res_field61',
        'res_field62',
        'res_field63',
        'res_field64',
        'res_field65',
        'res_field66',
        'res_field67',
        'res_field68',
        'res_field69',
        'res_field70',
        'res_field71',
        'res_field72',
        'res_field73',
        'res_field74',
        'res_field75',
        'res_field76',
        'res_field77',
        'res_field78',
        'res_field79',
        'res_field80',
        'res_field81',
        'res_field82',
        'res_field83',
        'res_field84',
        'res_field85',
        'res_field86',
        'res_field87',
        'res_field88',
        'res_field89',
        'res_field90',
        'res_field91',
        'res_field92',
        'res_field93',
        'res_field94',
        'res_field95',
        'res_field96',
        'res_field97',
        'res_field98',
        'res_field99',
        'res_field100',
        'res_field101',
        'res_field102',
        'res_field103',
        'res_field104',
        'res_field105',
        'res_field106',
        'res_field107',
        'res_field108',
        'res_field109',
        'res_field110',
        'res_field111',
        'res_field112',
        'res_field113',
        'res_field114',
        'res_field115',
        'res_field116',
        'res_field117',
        'res_field118',
        'res_field119',
        'res_field120',
        'res_field121',
        'res_field122',
        'res_field123',
        'res_field124',
        'res_field125',
        'res_field126',
        'res_field127',
        'res_field128',
        'request',
        'response',
        'extra_data',
        'sync_message',
        'need_sending',
        'sent',
        'received',
        'aml_check',
        'aml_check_sent',
        'aml_check_retries',
        'aml_listed',
        'posted',
        'maker_checker_approve_status',
        'approved_at',
        'maker_checker_reject_status',
        'rejected_at'
    ];

    /**
     * The attributes that should be casted to native types.
     *
     * @var array
     */
    protected $casts = [
        'date_time_added' => 'float',
        'added_by' => 'integer',
        'date_time_modified' => 'float',
        'modified_by' => 'integer',
        'source_ip' => 'string',
        'latest_ip' => 'string',
        'iso_id' => 'integer',
        'prev_iso_id' => 'integer',
        'company_id' => 'integer',
        'need_sync' => 'boolean',
        'synced' => 'boolean',
        'iso_source' => 'string',
        'iso_type' => 'string',
        'request_type' => 'string',
        'iso_status' => 'string',
        'iso_version' => 'integer',
        'req_mti' => 'string',
        'req_field1' => 'string',
        'req_field2' => 'string',
        'req_field3' => 'string',
        'req_field4' => 'string',
        'req_field5' => 'string',
        'req_field6' => 'string',
        'req_field7' => 'string',
        'req_field8' => 'string',
        'req_field9' => 'string',
        'req_field10' => 'string',
        'req_field11' => 'string',
        'req_field12' => 'string',
        'req_field13' => 'string',
        'req_field14' => 'string',
        'req_field15' => 'string',
        'req_field16' => 'string',
        'req_field17' => 'string',
        'req_field18' => 'string',
        'req_field19' => 'string',
        'req_field20' => 'string',
        'req_field21' => 'string',
        'req_field22' => 'string',
        'req_field23' => 'string',
        'req_field24' => 'string',
        'req_field25' => 'string',
        'req_field26' => 'string',
        'req_field27' => 'string',
        'req_field28' => 'string',
        'req_field29' => 'string',
        'req_field30' => 'string',
        'req_field31' => 'string',
        'req_field32' => 'string',
        'req_field33' => 'string',
        'req_field34' => 'string',
        'req_field35' => 'string',
        'req_field36' => 'string',
        'req_field37' => 'string',
        'req_field38' => 'string',
        'req_field39' => 'string',
        'req_field40' => 'string',
        'req_field41' => 'string',
        'req_field42' => 'string',
        'req_field43' => 'string',
        'req_field44' => 'string',
        'req_field45' => 'string',
        'req_field46' => 'string',
        'req_field47' => 'string',
        'req_field48' => 'string',
        'req_field49' => 'string',
        'req_field50' => 'string',
        'req_field51' => 'string',
        'req_field52' => 'string',
        'req_field53' => 'string',
        'req_field54' => 'string',
        'req_field55' => 'string',
        'req_field56' => 'string',
        'req_field57' => 'string',
        'req_field58' => 'string',
        'req_field59' => 'string',
        'req_field60' => 'string',
        'req_field61' => 'string',
        'req_field62' => 'string',
        'req_field63' => 'string',
        'req_field64' => 'string',
        'req_field65' => 'string',
        'req_field66' => 'string',
        'req_field67' => 'string',
        'req_field68' => 'string',
        'req_field69' => 'string',
        'req_field70' => 'string',
        'req_field71' => 'string',
        'req_field72' => 'string',
        'req_field73' => 'string',
        'req_field74' => 'string',
        'req_field75' => 'string',
        'req_field76' => 'string',
        'req_field77' => 'string',
        'req_field78' => 'string',
        'req_field79' => 'string',
        'req_field80' => 'string',
        'req_field81' => 'string',
        'req_field82' => 'string',
        'req_field83' => 'string',
        'req_field84' => 'string',
        'req_field85' => 'string',
        'req_field86' => 'string',
        'req_field87' => 'string',
        'req_field88' => 'string',
        'req_field89' => 'string',
        'req_field90' => 'string',
        'req_field91' => 'string',
        'req_field92' => 'string',
        'req_field93' => 'string',
        'req_field94' => 'string',
        'req_field95' => 'string',
        'req_field96' => 'string',
        'req_field97' => 'string',
        'req_field98' => 'string',
        'req_field99' => 'string',
        'req_field100' => 'string',
        'req_field101' => 'string',
        'req_field102' => 'string',
        'req_field103' => 'string',
        'req_field104' => 'string',
        'req_field105' => 'string',
        'req_field106' => 'string',
        'req_field107' => 'string',
        'req_field108' => 'string',
        'req_field109' => 'string',
        'req_field110' => 'string',
        'req_field111' => 'string',
        'req_field112' => 'string',
        'req_field113' => 'string',
        'req_field114' => 'string',
        'req_field115' => 'string',
        'req_field116' => 'string',
        'req_field117' => 'string',
        'req_field118' => 'string',
        'req_field119' => 'string',
        'req_field120' => 'string',
        'req_field121' => 'string',
        'req_field122' => 'string',
        'req_field123' => 'string',
        'req_field124' => 'string',
        'req_field125' => 'string',
        'req_field126' => 'string',
        'req_field127' => 'string',
        'req_field128' => 'string',
        'res_mti' => 'string',
        'res_field1' => 'string',
        'res_field2' => 'string',
        'res_field3' => 'string',
        'res_field4' => 'string',
        'res_field5' => 'string',
        'res_field6' => 'string',
        'res_field7' => 'string',
        'res_field8' => 'string',
        'res_field9' => 'string',
        'res_field10' => 'string',
        'res_field11' => 'string',
        'res_field12' => 'string',
        'res_field13' => 'string',
        'res_field14' => 'string',
        'res_field15' => 'string',
        'res_field16' => 'string',
        'res_field17' => 'string',
        'res_field18' => 'string',
        'res_field19' => 'string',
        'res_field20' => 'string',
        'res_field21' => 'string',
        'res_field22' => 'string',
        'res_field23' => 'string',
        'res_field24' => 'string',
        'res_field25' => 'string',
        'res_field26' => 'string',
        'res_field27' => 'string',
        'res_field28' => 'string',
        'res_field29' => 'string',
        'res_field30' => 'string',
        'res_field31' => 'string',
        'res_field32' => 'string',
        'res_field33' => 'string',
        'res_field34' => 'string',
        'res_field35' => 'string',
        'res_field36' => 'string',
        'res_field37' => 'string',
        'res_field38' => 'string',
        'res_field39' => 'string',
        'res_field40' => 'string',
        'res_field41' => 'string',
        'res_field42' => 'string',
        'res_field43' => 'string',
        'res_field44' => 'string',
        'res_field45' => 'string',
        'res_field46' => 'string',
        'res_field47' => 'string',
        'res_field48' => 'string',
        'res_field49' => 'string',
        'res_field50' => 'string',
        'res_field51' => 'string',
        'res_field52' => 'string',
        'res_field53' => 'string',
        'res_field54' => 'string',
        'res_field55' => 'string',
        'res_field56' => 'string',
        'res_field57' => 'string',
        'res_field58' => 'string',
        'res_field59' => 'string',
        'res_field60' => 'string',
        'res_field61' => 'string',
        'res_field62' => 'string',
        'res_field63' => 'string',
        'res_field64' => 'string',
        'res_field65' => 'string',
        'res_field66' => 'string',
        'res_field67' => 'string',
        'res_field68' => 'string',
        'res_field69' => 'string',
        'res_field70' => 'string',
        'res_field71' => 'string',
        'res_field72' => 'string',
        'res_field73' => 'string',
        'res_field74' => 'string',
        'res_field75' => 'string',
        'res_field76' => 'string',
        'res_field77' => 'string',
        'res_field78' => 'string',
        'res_field79' => 'string',
        'res_field80' => 'string',
        'res_field81' => 'string',
        'res_field82' => 'string',
        'res_field83' => 'string',
        'res_field84' => 'string',
        'res_field85' => 'string',
        'res_field86' => 'string',
        'res_field87' => 'string',
        'res_field88' => 'string',
        'res_field89' => 'string',
        'res_field90' => 'string',
        'res_field91' => 'string',
        'res_field92' => 'string',
        'res_field93' => 'string',
        'res_field94' => 'string',
        'res_field95' => 'string',
        'res_field96' => 'string',
        'res_field97' => 'string',
        'res_field98' => 'string',
        'res_field99' => 'string',
        'res_field100' => 'string',
        'res_field101' => 'string',
        'res_field102' => 'string',
        'res_field103' => 'string',
        'res_field104' => 'string',
        'res_field105' => 'string',
        'res_field106' => 'string',
        'res_field107' => 'string',
        'res_field108' => 'string',
        'res_field109' => 'string',
        'res_field110' => 'string',
        'res_field111' => 'string',
        'res_field112' => 'string',
        'res_field113' => 'string',
        'res_field114' => 'string',
        'res_field115' => 'string',
        'res_field116' => 'string',
        'res_field117' => 'string',
        'res_field118' => 'string',
        'res_field119' => 'string',
        'res_field120' => 'string',
        'res_field121' => 'string',
        'res_field122' => 'string',
        'res_field123' => 'string',
        'res_field124' => 'string',
        'res_field125' => 'string',
        'res_field126' => 'string',
        'res_field127' => 'string',
        'res_field128' => 'string',
        'request' => 'string',
        'response' => 'string',
        'extra_data' => 'string',
        'sync_message' => 'string',
        'need_sending' => 'boolean',
        'sent' => 'boolean',
        'received' => 'boolean',
        'aml_check' => 'boolean',
        'aml_check_sent' => 'boolean',
        'aml_check_retries' => 'integer',
        'aml_listed' => 'boolean',
        'posted' => 'boolean',
        'maker_checker_approve_status' => 'boolean',
//        'approved_at' => 'datetime',
        'maker_checker_reject_status' => 'boolean',
//        'rejected_at' => 'datetime'
    ];

    /**
     * Validation rules
     *
     * @var array
     */
    public static $rules = [
    ];


    /**
     * @inheritDoc
     */
    public function previewLink()
    {
        // TODO: Implement previewLink() method.
        return env('APP_URL')."/all/transactions";
    }

    /**
     * @inheritDoc
     * @noinspection PhpHierarchyChecksInspection
     */
    public function markApprovalComplete($id)
    {
        // TODO: Implement markApprovalComplete() method.
        $model = self::find($id);
//        dd($model);
        $model->maker_checker_approve_status = 1;
        $model->approved_at = time();
        $model->save();
    }

    /**
     * @inheritDoc
     */
    public function markApprovalAsRejected($id)
    {
        // TODO: Implement markApprovalAsRejected() method.
        $model = self::find($id);
        $model->maker_checker_reject_status = 1;
        $model->rejected_at = time();
        $model->save();
    }
}
