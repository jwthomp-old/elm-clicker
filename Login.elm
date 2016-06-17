module Login exposing (view, update)

import Html exposing (..)
import Html.Events exposing (on, keyCode)
import Model exposing (Model, Msg(..), UIState(..), LoginCmds(..))
import Json.Decode as Json
import Debug exposing (log)

onStuff : (Int -> msg) -> Attribute msg
onStuff tagger =
  on "keyup" (Json.map tagger keyCode)

handleClick : Int -> Model -> (Model, Cmd Msg)
handleClick val model =
  if val == 13 then
    ({ model | uiState = RoomUIState}, Cmd.none)
  else
    (model, Cmd.none)
    


update : LoginCmds -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    Click val -> handleClick val model
    Login -> ({ model | uiState = RoomUIState}, Cmd.none)

view : Model -> Html Msg
view model =
  div []
    [ text "username"
    , input [ onStuff <| \v -> LoginView (Click v)] [text "username"]
    ]