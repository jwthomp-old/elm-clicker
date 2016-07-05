module Monster exposing (update, init, Model, Msg, Msg(..), serializer, deserializer)

import List
-- import Helper
import Random
import Json.Encode as JsonEnc
import Json.Decode as JsonDec exposing ((:=), Decoder, andThen)
import Json.Decode.Extra exposing ((|:))


-- MODEL
type alias MonsterInstance =
  { monsterBase : MonsterBase
  , hitPoints   : Int
  }

type alias MonsterBase =
  { name      : String
  , hitPoints : Int
  , image     : String
  }

type alias Model =
  { seed    : Random.Seed
  , monster : MonsterInstance
  }

init : Model
init =
  { seed    = createInitialSeed
  , monster = getMonster 0
  }

{- Need to move this into some kind of data file -}
orc : MonsterBase
orc = 
  { name      = "Orc"
  , hitPoints = 20
  , image     = "images/orc.png"
  }

goblin : MonsterBase
goblin =
  { name      = "Goblin"
  , hitPoints = 10
  , image     = "images/troll-155646_640.png"
  }

sheep : MonsterBase
sheep =
  { name      = "Sheep Warrior"
  , hitPoints = 8
  , image     = "images/sheep-158272_640.png"
  }

monsters : List MonsterBase
monsters =
  [ orc
  , goblin
  , sheep
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
getMonster : Int -> MonsterInstance
getMonster val =
  let
    monsterBase : MonsterBase
    monsterBase = Maybe.withDefault orc <| List.head (List.drop val monsters)
  in
    { monsterBase   = monsterBase
    , hitPoints     = monsterBase.hitPoints
    }


monsterAttacked : Model -> (Model, Cmd Msg)
monsterAttacked model =
  let
    monster  = model.monster
    hp       = monster.hitPoints - 1
    monster' = {monster | hitPoints = hp}
    model'   = {model | monster = monster'}
  in
    if hp > 0 then
      model' ! []
    else
      model' ! [Random.generate NewMonster (Random.int 0 (List.length monsters))] -- [Helper.message <| NewMonster 0]

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

monsterSerializer : MonsterInstance -> JsonEnc.Value
monsterSerializer monster =
  JsonEnc.object
    [ ("monsterBase",   JsonEnc.string monster.monsterBase.name)
    , ("hitPoints", JsonEnc.int    monster.hitPoints)
    ]

deserializer : Decoder Model
deserializer =
  JsonDec.succeed Model
    |: JsonDec.succeed createInitialSeed
    |: ("monster" := monsterDeserializer)

monsterDeserializer : Decoder MonsterInstance
monsterDeserializer =
  JsonDec.succeed MonsterInstance
    |: (("monsterBase" := JsonDec.string) `andThen` decodeMonsterBase)
    |: ("hitPoints"   := JsonDec.int)

decodeMonsterBase : String -> Decoder MonsterBase
decodeMonsterBase name = 
  case name of
    "Orc"           -> JsonDec.succeed orc
    "Goblin"        -> JsonDec.succeed goblin
    "Sheep Warrior" -> JsonDec.succeed sheep
    _               -> JsonDec.succeed goblin