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
type Page
  = LoginPage
  | GamePage
  
type alias Model =
  { loginModel    : Login.Model
  , roomModel     : Room.Model
  , currentPage  : Page
  , authenticated : Bool
  }



init : (Model, Cmd Msg)
init =
  (
    { loginModel    = Login.init
    , roomModel     = Room.init
    , currentPage   = LoginPage
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
    -- Capture the Authenticated message and handle it here. 
    MnLogin Login.Authenticated -> 
      (model
        |> setCurrentPage GamePage
        |> setAuthenticated True) ! []
    MnRoom Room.Deauthenticated -> 
      (model 
        |> setCurrentPage LoginPage) ! []
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
    LoginPage -> div [] [ App.map MnLogin (Login.view model.loginModel)]
    GamePage  -> div [] [ App.map MnRoom  (Room.view  model.roomModel)]


   
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