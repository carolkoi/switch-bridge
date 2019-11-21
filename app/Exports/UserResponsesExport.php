<?php

namespace App\Exports;

use App\Models\Template;
use Illuminate\Support\Collection;
use Maatwebsite\Excel\Concerns\FromCollection;
use App\Models\Question;
use App\Models\Answer;
use App\Models\Response;

class UserResponsesExport implements FromCollection
{
    protected $templateId;

    public function __construct($templateId)
    {
        $this->templateId = $templateId;
    }

    public function extractAnswer($response)
    {
//        dd(collect($response)->map(function ($response){
//            dd($response->answer);
//        }));

        return collect($response)->map(function ($response){
            if ($response->answer_type == Question::SELECT_MULTIPLE || $response->answer_type == Question::DROP_DOWN_LIST) {
                return collect(json_decode($response->answer))->map(function ($answer){
                    return [
                        'answer'=>Answer::find($answer)->choice
                        ];
                })->implode('answer', ',');

            }
            return $response->answer;

        });

    }
    /**
     * @return Collection
     */
    public function collection()
    {
        return Template::where('id',$this->templateId)->with(['questions','questions.responses'])->get()
            ->pluck('questions')->flatten(1)->map(function ($question){
                return[
                    'question' => $question->question,
                    'answer'=>$this->extractAnswer($question->responses)

                ];
            });


}
}

//public function collection()
//{
//    // TODO: Implement collection() method.
//    $datas = Question::where('template_id', $this->templateId)->with(['responses', 'answer'])->get();
//    $responseDetails = collect();
//    foreach ($datas as $data) {
//        foreach ($data->responses as $key => $respons) {
//
//            if ($key == 0) {
//
//                $response['question'] = $data->question;
//                if ($respons->answer_type == Question::SELECT_MULTIPLE) {
//                    $data = collect(json_decode($respons->answer))->toArray();
//                    $choice = [];
//                    foreach ($data as $key => $ans) {
//                        $choice[$key] = Answer::find($ans)->choice;
//                    }
//                    $response['answer'] = implode(',', $choice);
//                } elseif ($respons->answer_type == Question::DROP_DOWN_LIST) {
//                    $data = collect(json_decode($respons->answer))->toArray();
//                    foreach ($data as $ans) {
//                        $response['answer'] = Answer::find($ans)->choice;
//                    }
//                } else {
//                    $response['answer'] = $respons->answer;
//                }
//            } else {
//                $response['question'] = null;
//                $response['answer'] = $respons->answer;
//            }
//
//            $responseDetails->push($response);
//        };
//    }
//
//    return $responseDetails;
//
//
//    return new Collection($responseDetails);
//}



