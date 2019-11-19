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
        return collect($response)->map(function ($response){
            if ($response->answer_type == Question::SELECT_MULTIPLE || $response->answer_type == Question::DROP_DOWN_LIST) {
                return collect(json_decode($response->answer))->map(function ($answer){
                    return [
                        'answer'=>Answer::find($answer)->choice
                        ];
                })->implode('answer',',');

            }
            return $response->answer;

        });

    }
    /**
     * @return Collection
     */
    public function collection()
    {
        return  Template::where('id',$this->templateId)->with(['questions','questions.responses'])->get()
            ->pluck('questions')->flatten(1)->map(function ($question){
                return[
                    'question' => $question->question,
                    'answer'=>$this->extractAnswer($question->responses)

                ];
            });

    }
}

