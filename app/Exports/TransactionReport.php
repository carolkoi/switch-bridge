<?php

namespace App\Exports;
use App\Models\Transactions;
use Illuminate\Support\Collection;
use Maatwebsite\Excel\Concerns\FromCollection;
use Illuminate\Contracts\View\View;
use Maatwebsite\Excel\Concerns\FromView;
use Maatwebsite\Excel\Concerns\ShouldAutoSize;
use Maatwebsite\Excel\Concerns\WithEvents;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Maatwebsite\Excel\Events\AfterSheet;
use Maatwebsite\Excel\Concerns\WithMapping;

class TransactionReport implements FromView, ShouldAutoSize
{
    protected $transactions;

    /**
     * @param $transactions
     */
    public function __construct($transactions)
    {
        $this->transactions = $transactions;
        //
    }

    public function view(): View
    {

        return view('transactions.normal_table', ['transactions' => $this->transactions]);
    }

//    public function registerEvents(): array
//    {
//        // TODO: Implement registerEvents() method.
//    }
//
//    public function map($row): array
//    {
//        // TODO: Implement map() method.
//    }
    public function collection()
    {
        // TODO: Implement collection() method.
    }

    public function headings(): array
    {
        // TODO: Implement headings() method.

        $transactions = Transactions::orderBy('iso_id', 'desc')->transactionsByCompany()
            ->search()->get();
            return [
                'Partner',
                'TXN Date',
                'Paid Date',
                'TXN Status',
                'TXN Type',
                'Primary Txn Ref',
                'Sync Msg Ref',
                'TXN No',
                'Amount Sent',
                'Rcver Cur',
                'Amount Received',
                'Sender',
                'Receiver',
                'Receiver Acc/No',
                'Response',
                'Receiver Bank'
            ];

    }
}
