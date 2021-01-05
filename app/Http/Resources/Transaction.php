<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class Transaction extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return array
     */
    public function toArray($request)
    {
//        return parent::toArray($request);


        return [
            'iso_id' => $this['iso_id'],
            'req_field123' => $this->req_field123,
            'req_field7' => $this->req_field7,
            'date_time_added' => date('Y-m-d H:i:s',strtotime('+3 hours',strtotime(date('Y-m-d H:i:s', ($this->date_time_added/ 1000))))),
            'paid_out_date' => !empty($this->paid_out_date) ?  date("Y-m-d H:i:s", strtotime($this->paid_out_date)+10800):null,
            'res_field48' => $this->res_field48,
            'req_field41' => $this->req_field41,
            'req_field34' => $this->req_field34,
            'sync_message' => $this->sync_message,
            'req_field105' => $this->req_field105,
            'req_field49' => $this->req_field49,
            'req_field4' => intval($this->req_field4)/100,
            'req_field50' => $this->req_field50,
            'req_field5' => intval($this->req_field5)/100,
            'req_field3' => $this->req_field3,
            'req_field37' => $this->req_field37,
            'req_field108' => $this->req_field108,
            'req_field102' => $this->req_field102,
            'res_field44' => $this->res_field44,
            'req_field112' => $this->req_field112,
        ];
    }
}
