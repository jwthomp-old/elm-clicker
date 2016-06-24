module Login exposing (Model, Msg, init, update, view, Msg(..))

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Task


-- MODEL
type alias Model = 
  { username : String
  , password : String
  }

init : Model
init = 
  { username = ""
  , password = ""
  }


-- UPDATE
type Msg
  = LoginSubmit
  | Authenticated
  | FailedAuth
  | Username String
  | Password String

update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    LoginSubmit   -> model ! [authenticate model.username model.password]
    Authenticated -> model ! [] -- Handler if not captured by parent
    Username username -> {model | username = username} ! []
    Password password -> {model | password = password} ! []
    FailedAuth -> model ! []


-- VIEW
view : Model -> Html Msg
view model =
  div []
    [ text "username"
    , input [ type' "text",     placeholder "Name",     onInput Username ] []
    , input [ type' "password", placeholder "Password", onInput Password ] []
    , button [ onClick LoginSubmit] [ text "login"]
    ]


-- HELPERS
message : Msg -> Cmd Msg
message msg =
  Task.perform identity identity <| Task.succeed msg

authenticate : String -> String -> Cmd Msg
authenticate username password =
  Task.perform (always FailedAuth) (always Authenticated) (authTask username password)

authTask : String -> String -> Task.Task Bool Bool
authTask username password =
  if username == "jwthomp" && password == "abc" then
    Task.succeed True
  else
    Task.fail True