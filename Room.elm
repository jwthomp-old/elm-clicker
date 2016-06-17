module Room exposing (roomView, update)

import Html exposing (..)
import Html.Events exposing (onClick)
import Model exposing (Model, Msg(..), UIState(..), RoomCmds(..))



update : RoomCmds -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    Logout -> ({ model | uiState = LoginUIState}, Cmd.none)

roomView : Model -> Html Msg
roomView model =
  div []
    [ text "room"
    , button [ onClick (RoomView Logout) ] [ text "logout" ]
    ]