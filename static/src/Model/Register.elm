module Model.Register exposing (..)

import Date
import Time
import View.Calendar
import Http
import Json.Decode exposing (..)


type alias Model =
    { eventName : String
    , memo : String
    , dates : String
    , currentMonth : Maybe Date.Date
    , msg : Maybe String
    }


type Msg
    = InputEvent String
    | InputMemo String
    | NewDate String
    | InputDates String
    | PrevMonth
    | NextMonth
    | Submit
    | GetResponse (Result.Result Http.Error String)
    | HideMessage
    | Noop


type MoveType
    = Prev
    | Next


moveMonth : MoveType -> Date.Date -> Date.Date
moveMonth mType month =
    let
        pl =
            case mType of
                Prev ->
                    (+)

                Next ->
                    (-)
    in
        Date.toTime month |> pl (Time.hour * 24 * 30) |> Date.fromTime


submit : Model -> Cmd Msg
submit m =
    Http.request
        { method = "POST"
        , headers = []
        , url = "/api/schedules/"
        , body = Http.emptyBody
        , expect = Http.expectString
        , timeout = Nothing
        , withCredentials = False
        }
        |> Http.send GetResponse
