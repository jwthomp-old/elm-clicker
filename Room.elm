module Room exposing (roomView)

import Html exposing (..)
import Html.Events exposing (onClick)
import Model exposing (Model, Msg(..))

roomView : Model -> Html Msg
roomView model =
  div 
    [] 
    [ text "room"
    , button [ onClick LogoutAction ] [ text "logout" ]
    ]