<?php

namespace App\Console;

use App\Console\Commands\automaticSurveySend;
use App\Console\Commands\ClientsCommand;
use App\Console\Commands\EmployeesCommand;
use Illuminate\Console\Scheduling\Schedule;
use Illuminate\Foundation\Console\Kernel as ConsoleKernel;

class Kernel extends ConsoleKernel
{
    /**
     * The Artisan commands provided by your application.
     *
     * @var array
     */
    protected $commands = [
        //
        EmployeesCommand::class,
        ClientsCommand::class,
        automaticSurveySend::class,
    ];

    /**
     * Define the application's command schedule.
     *
     * @param Schedule $schedule
     * @return void
     */
    protected function schedule(Schedule $schedule)
    {
        // $schedule->command('inspire')
        //          ->hourly();
        $schedule->command('employees:get')
            ->everyMinute();
        $schedule->command('clients:get')
            ->everyMinute();
        $schedule->command('survey:send')
            ->everyMinute();

    }

    /**
     * Register the commands for the application.
     *
     * @return void
     */
    protected function commands()
    {
        $this->load(__DIR__.'/Commands');

        require base_path('routes/console.php');
    }
}
