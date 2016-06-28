module Room exposing (Model, Msg, init, update, view, Msg(..))

import Html exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (..)
import Helper exposing (message)
import Monster exposing (Monster)

-- MODEL
type alias Model =
  { clicks : Int
  , currentMonster : Monster
  }

init : Model
init = 
  { clicks = 0
  , currentMonster = Monster.getMonster
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
    MonsterClick -> monsterAttacked model ! []

-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ button [ onClick Logout ] [ text "logout" ]
    , viewMonster model
    , displayClicks model
    ]


-- HELPERS

viewMonster : Model ->  Html Msg
viewMonster model =
  div []
    [ div [] 
      [ text model.currentMonster.name
      ]
    , div [] 
      [ img [ src model.currentMonster.image, height 128, width 128, onClick MonsterClick] []
      ]
    ]

displayClicks : Model -> Html Msg
displayClicks model =
  div []
    [ text <| "Hitpoints: " ++ toString model.currentMonster.hitPoints]

monsterAttacked : Model -> Model
monsterAttacked model =
  let
    monster = model.currentMonster
    hp      = monster.hitPoints - 1
  in
    { model | currentMonster = { monster | hitPoints = hp }}
