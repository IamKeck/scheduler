module Calendar exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)
import Date
import Html
import Html.Events
import View.Calendar exposing (view)


-- 14th May 2018


may =
    Date.fromTime 1526272438000


suite : Test
suite =
    describe "Calendar Test"
        [ describe "May Test"
            [ test "Month is May" <|
                \_ ->
                    Date.month may |> Expect.equal Date.May
            , test "Day is 14" <|
                \_ ->
                    Date.day may |> Expect.equal 14
            , test "Year is 2018" <|
                \_ ->
                    Date.year may |> Expect.equal 2018
            ]
        , describe "Leap Year Test "
            [ test "2000 is a leap year" <|
                \_ ->
                    View.Calendar.isLeapYear 2000 |> Expect.equal True
            , test "2100 is not a leap year" <|
                \_ ->
                    View.Calendar.isLeapYear 2100 |> Expect.equal False
            , test "2004 is a leap year" <|
                \_ ->
                    View.Calendar.isLeapYear 2004 |> Expect.equal True
            , test "1999 is not a leap year" <|
                \_ ->
                    View.Calendar.isLeapYear 1999 |> Expect.equal False
            ]
        , describe "First And Last Day Of Month Test"
            [ test "to first day - month" <|
                \_ ->
                    View.Calendar.toFirstDayOfMonth may |> Date.month |> Expect.equal Date.May
            , test "to first day - day" <|
                \_ ->
                    View.Calendar.toFirstDayOfMonth may |> Date.day |> Expect.equal 1
            , test "to last day -  month" <|
                \_ ->
                    View.Calendar.toLastDayOfMonth may |> Date.month |> Expect.equal Date.May
            , test "to last day - day" <|
                \_ ->
                    View.Calendar.toLastDayOfMonth may |> Date.day |> Expect.equal 31
            ]
        , test "valid calendar" <|
            \_ ->
                let
                    days =
                        [ [ "", "", "1", "2", "3", "4", "5" ]
                        , [ "6", "7", "8", "9", "10", "11", "12" ]
                        , [ "13", "14", "15", "16", "17", "18", "19" ]
                        , [ "20", "21", "22", "23", "24", "25", "26" ]
                        , [ "27", "28", "29", "30", "31", "", "" ]
                        ]

                    msger _ =
                        "hoge"

                    html =
                        Html.div []
                            [ Html.p [] [ Html.text "5月" ]
                            , Html.table [] <|
                                List.map
                                    (\dl ->
                                        Html.tr [] <|
                                            List.map
                                                (\ds ->
                                                    Html.td [ Html.Events.onClick <| msger "dmy" ]
                                                        [ Html.text ds ]
                                                )
                                                dl
                                    )
                                    days
                            ]
                in
                    Expect.equal (view msger may) html
        ]
