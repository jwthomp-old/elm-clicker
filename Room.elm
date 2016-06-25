module Room exposing (Model, Msg, init, update, view, Msg(..))

import Html exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (..)
import Helper exposing (message)

-- MODEL
type alias Model = Int

init : Model
init = 0

-- UPDATE
type Msg
  = Logout
  | Deauthenticated

update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    Logout ->          model ! [message Deauthenticated]
    Deauthenticated -> model ! [] -- Handler if not captured by parent

-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ button [ onClick Logout ] [ text "logout" ]
    , displayMonster
    ]


-- HELPERS

displayMonster : Html msg
displayMonster =
  div []
    [ div [] 
      [ text "Monster"
      ]
    , div [] 
      [ img [ src "images/orc.png", height 32, width 32] []
      ]
    ]