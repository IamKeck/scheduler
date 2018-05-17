module View.Register exposing (..)

import Model.Register exposing (..)
import View.Calendar
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Date
import Debug


dateClicked : Maybe Date.Date -> Msg
dateClicked d =
    let
        monthStr m =
            case m of
                Date.Jan ->
                    1

                Date.Feb ->
                    2

                Date.Mar ->
                    3

                Date.Apr ->
                    4

                Date.May ->
                    5

                Date.Jun ->
                    6

                Date.Jul ->
                    7

                Date.Aug ->
                    8

                Date.Sep ->
                    9

                Date.Oct ->
                    10

                Date.Nov ->
                    11

                Date.Dec ->
                    12
    in
        case d of
            Just d ->
                (Date.year d |> toString)
                    ++ "/"
                    ++ (Date.month d |> monthStr |> toString)
                    ++ "/"
                    ++ (Date.day d |> toString)
                    |> NewDate

            Nothing ->
                Noop


view : Model -> Html Msg
view m =
    div []
        [ m.currentMonth |> Maybe.map (View.Calendar.view dateClicked) |> Maybe.withDefault (text "")
        , m.msg |> Maybe.map (\msg -> p [] [ text msg ]) |> Maybe.withDefault (text "")
        , div []
            [ p [] [ text "イベント名" ]
            , input [ onInput InputEvent ] []
            , p [] [ text "メモ" ]
            , input [ onInput InputMemo ] []
            , p [] [ text "候補日時" ]
            , textarea [ onInput InputDates, value m.dates ] []
            ]
        , button [ onClick Submit ] [ text "登録" ]
        ]
