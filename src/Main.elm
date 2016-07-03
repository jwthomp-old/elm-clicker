port module Main exposing (main)

{-| The main module

# Definition
@docs main

-}

import Html exposing (..)
import Html.App as App
import Login
import Room
import Json.Encode as JsonEnc
import Json.Decode as JsonDec

{-| The main function -}
main : Program (Maybe String)
main =
  App.programWithFlags
    { init          = init
    , view          = view
    , update        = updateWithStorage
    , subscriptions = subscriptions
    }


-- MODEL
type alias Page = String
  
type alias Model =
  { loginModel    : Login.Model
  , roomModel     : Room.Model
  , currentPage  : Page
  , authenticated : Bool
  }

initialModel : Model
initialModel =
  { loginModel    = Login.init
  , roomModel     = Room.init
  , currentPage   = "LoginPage"
  , authenticated = False
  }

init : Maybe String -> (Model, Cmd Msg)
init model =
  Maybe.withDefault initialModel (deserialize model) ! []


-- UPDATE
type Msg
  = MnLogin Login.Msg
  | MnRoom  Room.Msg

updateWithStorage : Msg -> Model -> (Model, Cmd Msg)
updateWithStorage action model =
  let
    (newModel, cmds) = update action model
  in
    newModel ! [ setStorage <| serialize newModel, cmds ]


update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    -- Capture the Authenticated message and handle it here. 
    MnLogin Login.Authenticated -> 
      (model
        |> setCurrentPage "GamePage"
        |> setAuthenticated True) ! []
    MnRoom Room.Deauthenticated -> 
      (model 
        |> setCurrentPage "LoginPage") ! []
    MnLogin cmd -> 
      let
        (data, command) = Login.update cmd model.loginModel
      in 
        ({model | loginModel = data}, Cmd.map MnLogin command)
    MnRoom cmd -> 
      let
        (data, command) = Room.update cmd model.roomModel
      in 
        ({model | roomModel = data}, Cmd.map MnRoom command)


-- VIEW
view : Model -> Html Msg
view model =
  case model.currentPage of
    "LoginPage" -> div [] [ App.map MnLogin (Login.view model.loginModel)]
    "GamePage"  -> div [] [ App.map MnRoom  (Room.view  model.roomModel)]
    _ -> div [] [ text "You are on an UNKNOWN page" ]


   
-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none


-- HELPERS
setCurrentPage : Page -> Model -> Model 
setCurrentPage page model =
  { model | currentPage = page }

setAuthenticated : Bool -> Model -> Model
setAuthenticated authenticated model =
  { model | authenticated = authenticated }

serialize : Model -> String
serialize model =
  JsonEnc.encode 0 <| serializer model

serializer : Model -> JsonEnc.Value
serializer model =
  JsonEnc.object 
    [ ("login", Login.serializer model.loginModel)
    , ("authenticated", JsonEnc.bool model.authenticated)
    ]


deserialize : Maybe String -> Maybe Model
deserialize model =
  Just initialModel



port setStorage : String -> Cmd msg