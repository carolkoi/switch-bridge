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
        $template = Template::with('surveyType')->find($this->templateId);

        if ($template->surveyType->status == 1){
            return [
                'Questions',
                'Rating',
                'Average Rating Per Question',
                'Total Average'

            ];
        }else
            return [
                'Questions',
                'Responses',
            ];

    }


    public function collection()
    {
        $datas = Question::where('template_id', $this->templateId)->with(['responses','answer'])->get();
        $xx = Response::where('template_id', $this->templateId)->get()->count();
        $template = Template::with('surveyType')->find($this->templateId);

        $info = [];
        $answers = [];
        $respondents = 0;
        $total = 0;
        //numeric,dropdown,multiple,text
        foreach ($datas as $data){
            foreach ($data->responses as $key => $response) {

                if ($data->type == Question::SELECT_MULTIPLE || $data->type == Question::DROP_DOWN_LIST) {
                    $multiple_answers = collect(json_decode($response->answer))->toArray();
                    $answers = [];
                    foreach ($multiple_answers as $ans) {
                        $answers[] = Answer::find($ans)->choice;
                    }
                }
                $responses = implode(',', $answers);
                if ($data->type == Question::RATING){
                    $respondents = count($data->responses);

                    $data->responses->reduce(function ($acc, $response){
                        return $response['ave_rating'] = $acc + $response->answer;
                    });
                    $data->responses->reduce(function ($acc, $response){
                        return $response['total_rating'] = $acc + $response->total;

                    });
                }
                if ($template->surveyType->status == 1){
                    $info[] = [
                        'question' => empty($key) ? $data->question : null,
                        'responses' => $data->type == Question::SELECT_MULTIPLE || $data->type == Question::DROP_DOWN_LIST ? $responses : $response->answer,
                        'average' => count($data->responses) -1 == $key ? $response->ave_rating / $respondents : null,
                        'total_average' => count($data->responses) -1 == $key ? $response->total_rating / $respondents: null

                    ];

                }else
                    $info[] = [
                        'question' => empty($key) ? $data->question : null,
                        'responses' => $data->type == Question::SELECT_MULTIPLE || $data->type == Question::DROP_DOWN_LIST ? $responses : $response->answer

                    ];

            }
//dd($info);
            }


        return new Collection($info);


    }
}




