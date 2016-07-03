module Monster exposing (update, init, Model, Msg, Msg(..))

import List
import Helper

-- import Random

-- MODEL
type alias Model =
    { name      : String
    , hitPoints : Int
    , image     : String
    }

init : Model
init =
  getMonster 0   

{- Need to move this into some kind of data file -}
orc : Model
orc = 
    { name      = "Orc"
    , hitPoints = 20
    , image     = "images/orc.png"
    }

goblin : Model
goblin =
    { name = "Goblin"
    , hitPoints = 10
    , image = "images/orc.png"
    }

monsters : List Model
monsters =
    [ orc
    , goblin
    ]



-- UPDATE
type Msg
    = Attacked
    | NewMonster Int

update : Msg -> Model -> (Model, Cmd Msg)
update action model =
    case action of
      Attacked ->
        monsterAttacked model
      NewMonster val ->
        newMonster val model


-- HELPERS
getMonster : Int -> Model
getMonster val =
    Maybe.withDefault orc <| List.head (List.drop val monsters)


monsterAttacked : Model -> (Model, Cmd Msg)
monsterAttacked model =
  let
    hp = model.hitPoints - 1
    model' = {model | hitPoints = hp}
  in
    if hp > 0 then
      model' ! []
    else
      model' ! [Helper.message <| NewMonster 0]

newMonster : Int -> Model -> (Model, Cmd Msg)
newMonster val model =
  getMonster val ! []