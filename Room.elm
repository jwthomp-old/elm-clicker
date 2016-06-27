module Room exposing (Model, Msg, init, update, view, Msg(..))

import Html exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (..)
import Helper exposing (message)

-- MODEL
type alias Model =
  { clicks : Int
  }

init : Model
init = 
  { clicks = 0
  }

-- UPDATE
type Msg
  = Logout
  | Deauthenticated
  | MonsterClick

update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    Logout ->          model ! [message Deauthenticated]
    Deauthenticated -> model ! [] -- Handler if not captured by parent
    MonsterClick -> {model | clicks = model.clicks + 1} ! []

-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ button [ onClick Logout ] [ text "logout" ]
    , displayMonster model
    , displayClicks model
    ]


-- HELPERS

displayMonster : model ->  Html Msg
displayMonster model =
  div []
    [ div [] 
      [ text "Monster"
      ]
    , div [] 
      [ img [ src "images/orc.png", height 128, width 128, onClick MonsterClick] []
      ]
    ]

displayClicks : Model -> Html Msg
displayClicks model =
  div []
    [ text <| "Clicks: " ++ toString model.clicks ]