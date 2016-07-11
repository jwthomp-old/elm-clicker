module Player exposing (Model, Msg, Msg(..), init, update, serializer, deserializer)

import Json.Encode as JsonEnc
import Json.Decode as JsonDec exposing ((:=), Decoder)
import Json.Decode.Extra exposing ((|:))

-- MODEL
type alias Model =
  { level     : Int
  , xp        : Int
  , maxHP     : Int
  , currentHP : Int
  }

init : Model
init =
  { level     = 0
  , xp        = 0
  , maxHP     = 10
  , currentHP = 10
  }

-- UPDATE
type Msg
  = AddXP Int
  | TakeDamage Int
  | Heal Int

update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    AddXP xp       -> addXP xp model
    TakeDamage dmg -> takeDamage dmg model
    Heal hp        -> heal hp model

addXP : Int -> Model -> (Model, Cmd Msg)
addXP xp model =
  { model | xp = model.xp + xp } ! []

takeDamage : Int -> Model -> (Model, Cmd Msg)    
takeDamage dmg model =
  { model | currentHP = model.currentHP - dmg } ! []

heal : Int -> Model -> (Model, Cmd Msg)
heal hp model =
  { model | currentHP = model.currentHP + hp } ! []


-- SERIALIZATION

serializer : Model -> JsonEnc.Value
serializer model =
  JsonEnc.object
    [ ("level",     JsonEnc.int model.level)
    , ("xp",        JsonEnc.int model.xp)
    , ("maxHP",     JsonEnc.int model.maxHP)
    , ("currentHP", JsonEnc.int model.currentHP)
    ]

deserializer : Decoder Model
deserializer =
  JsonDec.succeed Model
    |: ("level"     := JsonDec.int)
    |: ("xp"        := JsonDec.int)
    |: ("maxHP"     := JsonDec.int)
    |: ("currentHP" := JsonDec.int)