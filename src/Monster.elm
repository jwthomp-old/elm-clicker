module Monster exposing (getMonster, Monster)

import List
import Random

type alias Monster =
    { name      : String
    , hitPoints : Int
    , image     : String
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

getMonster : Monster
getMonster =
    Maybe.withDefault orc <| List.head (List.drop 0 monsters)
