module View.Calendar exposing (..)

import Html
import Html.Events
import Date
import Time
import List
import Debug


isLeapYear : Int -> Bool
isLeapYear y =
    if y % 400 == 0 then
        True
    else if y % 100 == 0 then
        False
    else if y % 4 == 0 then
        True
    else
        False


getDays : Date.Date -> Int
getDays date =
    case Date.month date of
        Date.Feb ->
            if isLeapYear (Date.year date) then
                29
            else
                28

        Date.Apr ->
            30

        Date.Jul ->
            30

        Date.Sep ->
            30

        Date.Nov ->
            30

        _ ->
            31


msPerDay =
    Time.hour * 24


toFirstDayOfMonth : Date.Date -> Date.Date
toFirstDayOfMonth m =
    (Date.toTime m) - (msPerDay * (Date.day m - 1 |> toFloat)) |> Date.fromTime


toLastDayOfMonth : Date.Date -> Date.Date
toLastDayOfMonth m =
    let
        days =
            getDays m

        currentDay =
            Date.day m
    in
        (Date.toTime m) + (msPerDay * (days - currentDay |> toFloat)) |> Date.fromTime


divideList : Int -> List a -> List (List a)
divideList c l =
    let
        indexed_list =
            List.indexedMap (,) l

        folder ( index, el ) acc =
            if (index + 1) % c == 0 then
                [ el ] :: acc
            else
                case acc of
                    acc_ :: accs ->
                        (el :: acc_) :: accs

                    [] ->
                        [ [ el ] ]
    in
        List.indexedMap (,) l |> List.foldr folder []


view : (Maybe Date.Date -> msg) -> Date.Date -> Html.Html msg
view msger currentDay =
    let
        firstDay =
            toFirstDayOfMonth currentDay

        firstDayTime =
            Date.toTime firstDay

        lastDay =
            toLastDayOfMonth currentDay

        previousSpace =
            case Date.dayOfWeek firstDay of
                Date.Sun ->
                    0

                Date.Mon ->
                    1

                Date.Tue ->
                    2

                Date.Wed ->
                    3

                Date.Thu ->
                    4

                Date.Fri ->
                    5

                Date.Sat ->
                    6

        afterSpace =
            case Date.dayOfWeek lastDay of
                Date.Sun ->
                    6

                Date.Mon ->
                    5

                Date.Tue ->
                    4

                Date.Wed ->
                    3

                Date.Thu ->
                    2

                Date.Fri ->
                    1

                Date.Sat ->
                    0

        numberDayList =
            Date.day lastDay |> List.range 1

        dayList =
            (List.repeat previousSpace Nothing) ++ (List.map Just numberDayList) ++ (List.repeat afterSpace Nothing) |> divideList 7

        shower =
            Maybe.map toString >> Maybe.withDefault ""

        event day =
            case day of
                Just day ->
                    (60 * 1000 * 60 * 24) * (day - 1) |> toFloat |> (+) firstDayTime |> Date.fromTime |> Just |> msger |> Html.Events.onClick

                Nothing ->
                    msger Nothing |> Html.Events.onClick
    in
        Html.table [] <|
            List.map
                (\ds ->
                    Html.tr [] <|
                        List.map
                            (\d -> Html.td [ event d ] [ Html.text (shower d) ])
                            ds
                )
                dayList
