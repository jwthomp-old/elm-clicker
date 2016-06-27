module Monster exposing (getMonster, Monster)

type alias Monster =
    { name      : String
    , hitPoints : Int
    , image     : String
    }

getMonster : Monster
getMonster =
    { name      = "Orc"
    , hitPoints = 20
    , image     = "images/orc.png"
    }