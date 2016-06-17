module Login exposing (loginView)

import Html exposing (..)
import Html.Events exposing (onClick)
import Model exposing (Model, Msg(..))

loginView : Model -> Html Msg
loginView model =
  div []
    [ text "login" 
    , button [ onClick LoginAction ] [ text "login" ]
    ]