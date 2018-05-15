module Update.Register exposing (..)

import Model.Register exposing (..)
import Http
import Delay
import Time


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        InputEvent s ->
            { model | eventName = s } ! []

        InputMemo s ->
            { model | memo = s } ! []

        NewDate d ->
            { model | dates = (model.dates ++ "\n" ++ d |> String.trim) } ! []

        InputDates s ->
            { model | dates = s } ! []

        PrevMonth ->
            { model | currentMonth = model.currentMonth |> Maybe.map (moveMonth Prev) } ! []

        NextMonth ->
            { model | currentMonth = model.currentMonth |> Maybe.map (moveMonth Next) } ! []

        HideMessage ->
            { model | msg = Nothing } ! []

        Submit ->
            { model | msg = Nothing } ! [ submit model ]

        GetResponse r ->
            let
                hideMessage =
                    Delay.after 1000 Time.millisecond HideMessage
            in
                case r of
                    Ok a ->
                        { model | memo = "", eventName = "", dates = "" } ! [ hideMessage ]

                    Err e ->
                        let
                            msg =
                                case e of
                                    Http.BadUrl _ ->
                                        "bad url!"

                                    Http.Timeout ->
                                        "timeout!"

                                    Http.NetworkError ->
                                        "network error!"

                                    Http.BadStatus res ->
                                        "Bad Status!:" ++ res.body

                                    Http.BadPayload s r ->
                                        "Payload is wrong:" ++ s ++ r.body
                        in
                            { model | msg = Just msg } ! [ hideMessage ]

        _ ->
            model ! []
