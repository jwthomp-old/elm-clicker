module Monster exposing (update, init, Model, Msg, Msg(..))

import List
import Helper
import Random


-- MODEL
type alias Monster =
  { name      : String
  , hitPoints : Int
  , image     : String
  }

type alias Model =
  { seed : Random.Seed
  , monster : Monster
  }

init : Model
init =
  { seed = Random.initialSeed 0
  , monster = getMonster 0
  }

{- Need to move this into some kind of data file -}
orc : Monster
orc = 
  { name      = "Orc"
  , hitPoints = 20
  , image     = "images/orc.png"
  }

goblin : Monster
goblin =
  { name = "Goblin"
  , hitPoints = 10
  , image = "images/orc.png"
  }

monsters : List Monster
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
getMonster : Int -> Monster
getMonster val =
  Maybe.withDefault orc <| List.head (List.drop val monsters)


monsterAttacked : Model -> (Model, Cmd Msg)
monsterAttacked model =
  let
    monster = model.monster
    hp = monster.hitPoints - 1
    monster' = {monster | hitPoints = hp}
    model' = {model | monster = monster'}
  in
    if hp > 0 then
      model' ! []
    else
      model' ! [Helper.message <| NewMonster 0]

newMonster : Int -> Model -> (Model, Cmd Msg)
newMonster val model =
  { seed    = model.seed
  , monster = getMonster val
  } ! []