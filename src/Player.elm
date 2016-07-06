module Player exposing (Model, init, serializer, deserializer)

import Json.Encode as JsonEnc
import Json.Decode as JsonDec exposing((:=), Decoder)
import Json.Decode.Extra exposing((|:))

-- MODEL

type alias Model =
    { xp    : Int
    , level : Int}

init : Model
init =
    { xp    = 0
    , level = 1}


-- SERIALIZATION

serializer : Model -> JsonEnc.Value
serializer model =
  JsonEnc.object
    [ ("xp",    JsonEnc.int model.xp)
    , ("level", JsonEnc.int model.level)
    ]

deserializer : Decoder Model
deserializer =
  JsonDec.succeed Model
    |: ("xp"    := JsonDec.int)
    |: ("level" := JsonDec.int)