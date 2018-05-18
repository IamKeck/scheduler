<?php

use Illuminate\Database\Seeder;

class ScheduleSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        DB::table("schedules")->insert([
            "name" => "テストスケジュール",
            "memo" => "テストメモ"
        ]);
        $schedule = DB::table("schedules")->first();
        $times = [
            "2018-5-1 10:00",
            "2018-5-1 11:00",
            "2018-5-1 12:00",
            "2018-5-1 13:00",
            "2018-5-1 14:00"
        ];
        foreach ($times as $time) {
            DB::table("schedule_options")->insert([
                "schedules_id" => $schedule->id,
                "initial_time" => $time
            ]);
        }
        $schedule_option_ids = DB::table("schedule_options")->orderBy("id", "asc")->pluck("id")->toArray();
        $users = ["ユーザーA" => [1, 3, 2, 2, 3]
            , "ユーザーB" => [3, 3, 3, 2, 1]
            , "ユーザーC" => [1, 1, 1, 2, 1]
        ];

        $insert_list = array_map(function ($user_name) use ($users, $schedule_option_ids) {
            $attendance_list = $users[$user_name];
            $id_and_attendance_list = array_map(null, $schedule_option_ids, $attendance_list); //zip
            return array_map(function ($id_and_attendance) use ($user_name) {
                list($schedule_option_id, $attendance) = $id_and_attendance;
                return [
                    "schedule_options_id" => $schedule_option_id,
                    "attendance" => $attendance,
                    "name" => $user_name,
                ];
            }, $id_and_attendance_list);
        }, array_keys($users));
        $flatten_insert_list = array_reduce($insert_list, "array_merge", []); //flatten
        DB::table("user_schedule_options")->insert($flatten_insert_list);

    }
}
