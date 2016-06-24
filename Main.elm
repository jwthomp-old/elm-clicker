module Main exposing (main)

{-| The main module

# Definition
@docs main

-}

import Html exposing (..)
import Html.App as App
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
  { loginModel    : Login.Model
  , roomModel     : Room.Model
  , uiState       : UIState
  , authenticated : Bool
  }



init : (Model, Cmd Msg)
init =
  (
    { loginModel    = Login.init
    , roomModel     = Room.init
    , uiState       = UIStateLogin
    , authenticated = False
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
      { model 
        | uiState = UIStateRoom
        , authenticated = True
        } ! []
    MnRoom Room.Logout -> {model | uiState = UIStateLogin} ! []
    MnLogin cmd -> 
      let
        (a, b) = Login.update cmd model.loginModel
      in 
        ({model | loginModel = a}, Cmd.map MnLogin b)
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
    UIStateLogin -> div [] [ App.map MnLogin (Login.view model.loginModel)]
    UIStateRoom  -> div [] [ App.map MnRoom  (Room.view  model.roomModel)]


   
-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none
