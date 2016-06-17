module Main exposing (main)

{-| The main module

# Definition
@docs main

-}

import Html exposing (..)
import Html.App as Html
import Model exposing (Model, Msg(..), UIState(..))
import Login
import Room

{-| The main function -}
main : Program Never
main =
  Html.program
    { init          = init
    , view          = view
    , update        = update
    , subscriptions = subscriptions
    }

init : (Model, Cmd Msg)
init =
  (Model.init, Cmd.none)

view : Model -> Html Msg
view model =
  case model.uiState of
    LoginUIState -> Login.view model
    RoomUIState  -> Room.view model

-- UPDATE
update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    None          -> (model, Cmd.none)
    LoginView cmd -> Login.update cmd model
    RoomView  cmd -> Room.update  cmd model
   
-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none
