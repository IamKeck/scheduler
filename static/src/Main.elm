module Main exposing (..)

import Model.Register as Register
import Update.Register as Register
import View.Register as Register
import Html
import Date
import Task


initModel =
    { registerModel =
        { eventName = ""
        , memo = ""
        , dates = ""
        , currentMonth = Nothing
        , msg = Nothing
        }
    }


type alias Model =
    { registerModel : Register.Model }


type Msg
    = RegisterMessage Register.Msg
    | GotDay Date.Date


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RegisterMessage m ->
            let
                ( r_model, r_cmd ) =
                    Register.update m model.registerModel
            in
                { model | registerModel = r_model } ! [ Cmd.map RegisterMessage r_cmd ]

        GotDay d ->
            let
                rm =
                    model.registerModel

                newRm =
                    { rm | currentMonth = Just d }
            in
                { model | registerModel = newRm } ! []


view : Model -> Html.Html Msg
view m =
    Register.view m.registerModel |> Html.map RegisterMessage


getDay : Cmd Msg
getDay =
    Date.now |> Task.perform GotDay


main =
    Html.program
        { init = initModel ! [ getDay ]
        , update = update
        , view = view
        , subscriptions = always Sub.none
        }
