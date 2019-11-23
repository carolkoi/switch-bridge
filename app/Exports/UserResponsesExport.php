<?php

namespace App\Exports;

use App\Models\Template;
use Illuminate\Support\Collection;
use Maatwebsite\Excel\Concerns\FromCollection;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Maatwebsite\Excel\Concerns\ShouldAutoSize;
use App\Models\Question;
use App\Models\Answer;
use App\Models\Response;

class UserResponsesExport implements FromCollection, WithHeadings, ShouldAutoSize
{
    protected $templateId;

    public function __construct($templateId)
    {
        $this->templateId = $templateId;
    }

    public function headings(): array
    {
        return [
            'Questions',
            'Responses',
            'Total'

        ];
    }


public function collection()
{
        $datas = Question::where('template_id', $this->templateId)->with(['responses','answer'])->get();
        $responseDetails = collect();
        foreach($datas as $data){
            foreach($data->responses as $key => $respons){
                $response = collect();
                if(empty($key)){
                    $response['question'] = $data->question;
                    if ($respons->answer_type == Question::SELECT_MULTIPLE){
                        $data = collect(json_decode($respons->answer))->toArray();
                        $choice = [];
                        foreach ($data as $ans){
                            $choice[] = Answer::find($ans)->choice;
                        }
                        $response['answer'] = implode(',', $choice );
                    }elseif ($respons->answer_type == Question::DROP_DOWN_LIST){
                        $data = collect(json_decode($respons->answer))->toArray();
                        foreach ($data as $ans){
                            $response['answer'] = Answer::find($ans)->choice;
                        }
                    }else{
                        $response['answer'] = $respons->answer;
                    }
                }else{
                    $response['question'] = null;
                    $response['answer'] = $respons->answer;
                    $response['total'] = $respons->total;
                }

                $responseDetails->push($response);
            };
        }

        return $responseDetails;


        return new Collection($responseDetails);
}
}




