module Login exposing (Model, Msg, init, update, view, Msg(..))

import Html exposing (..)
import Html.Events exposing (on, keyCode, onClick)
import Task


-- MODEL
type alias Model = Bool

init : Bool -> Model
init authenticated =
  authenticated


-- UPDATE
type Msg
  = Login
  | Authenticated
  | None

update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    None -> (model, Cmd.none)
    Login -> (model, Task.perform (always None) (always Authenticated) <| Task.succeed True)
    Authenticated ->
      let
        _ = Debug.log "login authenticated" model
      in
        (model, Cmd.none)


-- VIEW
view : Model -> Html Msg
view model =
  div []
    [ text "username"
    , input [] [text "username"]
    , input [] [text "password"]
    , button [ onClick Login] [ text "login"]
    ]

