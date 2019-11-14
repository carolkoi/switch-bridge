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
    /**
     * @return \Illuminate\Support\Collection
     */
    public function collection()
    {
        $templates = Template::get();
        foreach ($templates as $template) {
            $datas = Question::where('template_id', 10)->with(['responses', 'answer'])->get();
            $responseDetails = collect();
            foreach ($datas as $data) {
                foreach ($data->responses as $key => $respons) {
                    $response = collect();
                    if ($key == 0) {
                        $response['question'] = $data->question;
                        if ($respons->answer_type == Question::SELECT_MULTIPLE) {
                            $data = collect(json_decode($respons->answer))->toArray();
                            $choice = collect();
                            foreach ($data as $key => $ans) {
                                $choice[] = Answer::find($ans)->choice;
                            }
                            $response['answer'] = $choice;
                        } elseif ($respons->answer_type == Question::DROP_DOWN_LIST) {
                            $data = collect(json_decode($respons->answer))->toArray();
                            foreach ($data as $ans) {
                                $response['answer'] = Answer::find($ans)->choice;
                            }
                        } else {
                            $response['answer'] = $respons->answer;
                        }
                    } else {
                        $response['question'] = null;
                        $response['answer'] = $respons->answer;
                    }

                    $responseDetails->push($response);
                };
            }

            return $responseDetails;


            return new Collection($responseDetails);
        }
    }
}
