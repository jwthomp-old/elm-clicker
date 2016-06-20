module Main exposing (main)

{-| The main module

# Definition
@docs main

-}

import Html exposing (..)
import Html.App as App
import Debug
import Login
import Room

{-| The main function -}
main : Program Never
main =
  App.program
    { init          = init
    , view          = view
    , update        = update
    , subscriptions = subscriptions
    }


-- MODEL
type UIState
  = UIStateLogin
  | UIStateRoom
  
type alias Model =
  { login: Login.Model
  , room: Room.Model
  , uiState: UIState
  }



init : (Model, Cmd Msg)
init =
  (
    { login = Login.init False
    , room  = Room.init
    , uiState = UIStateLogin
    }
  , Cmd.none
  )


-- UPDATE
type Msg
  = MnLogin Login.Msg
  | MnRoom  Room.Msg



update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    MnLogin Login.Authenticated ->
      ({model | uiState = UIStateRoom}, Cmd.none)
    MnRoom Room.Logout ->
      ({model | uiState = UIStateLogin}, Cmd.none)
    MnLogin cmd -> 
      let
        (a, b) = Login.update cmd model.login
      in 
        ({model | login = a}, Cmd.map MnLogin b)
        {-
    MnRoom cmd -> 
      let
        (a, b) = Room.update cmd model.room
      in 
        ({model | room = a}, Cmd.map MnRoom b)
-}

-- VIEW
view : Model -> Html Msg
view model =
  case model.uiState of
    UIStateLogin -> div [] [ App.map MnLogin (Login.view model.login)]
    UIStateRoom  -> div [] [ App.map MnRoom  (Room.view  model.room)]


   
-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none
