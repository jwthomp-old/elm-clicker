module Login exposing (Model, Msg, init, update, view, Msg(..))

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Task
import Bootstrap.Html exposing (container_)
-- import Helper exposing(message)


-- MODEL
type alias Model = 
  { username : String
  , password : String
  , failedAuth : Bool
  }

init : Model
init = 
  { username = ""
  , password = ""
  , failedAuth = True
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
    FailedAuth -> { model | failedAuth = True } ! []
    Username username -> {model | username = username} ! []
    Password password -> {model | password = password} ! []
   

-- VIEW
view : Model -> Html Msg
view model =
  div []
    [ text "username"
    , input [ type' "text",     placeholder "Name",     onInput Username ] []
    , input [ type' "password", placeholder "Password", onInput Password ] []
    , button [ onClick LoginSubmit] [ text "login"]
    , displayAuthMessage model
    , bootstrap
    ]


-- HELPERS
authenticate : String -> String -> Cmd Msg
authenticate username password =
  Task.perform (always FailedAuth) (always Authenticated) (authTask username password)

authTask : String -> String -> Task.Task Bool Bool
authTask username password =
  if username == "jwthomp" && password == "abc" then
    Task.succeed True
  else
    Task.fail True

displayAuthMessage : Model -> Html Msg
displayAuthMessage model =
  div [] []

bootstrap : Html Msg
bootstrap =
  container_
    [ 
    ]