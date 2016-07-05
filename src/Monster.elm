module Monster exposing (update, init, Model, Msg, Msg(..), serializer, deserializer)

import List
import Helper
import Random
import Json.Encode as JsonEnc
import Json.Decode as JsonDec exposing ((:=), Decoder)
import Json.Decode.Extra exposing ((|:))


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
  { seed = createInitialSeed
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

createInitialSeed : Random.Seed
createInitialSeed =
  Random.initialSeed 0


-- SERIALIZATION

serializer : Model -> JsonEnc.Value
serializer model =
  JsonEnc.object
    [ ("monster", monsterSerializer model.monster)
    ]

monsterSerializer : Monster -> JsonEnc.Value
monsterSerializer monster =
  JsonEnc.object
    [ ("name", JsonEnc.string monster.name)
    , ("hitpoints", JsonEnc.int monster.hitPoints)
    ]

deserializer : Decoder Model
deserializer =
  JsonDec.succeed Model
    |: ("seed" := JsonDec.succeed createInitialSeed)
    |: ("monster" := monsterDeserializer)

monsterDeserializer : Decoder Monster
monsterDeserializer =
  -- Need to modify this to restore the monster
  JsonDec.succeed <| getMonster 0