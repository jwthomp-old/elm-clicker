module Model exposing 
  ( Model
  , Mobile
  , init
  , Msg(..)
  , UIState(..)
  , LoginCmds(..)
  , RoomCmds(..)
  )

{-| This library exposes the model for elm_clicker. 

# Definition
@docs Model

# Methods
@docs init

# Types
@docs UIState, Mobile, Msg, LoginCmds, RoomCmds

-}

-- MODEL
{-| The list of UI States for the app. Used to determine the current view -}
type UIState
  = LoginUIState
  | RoomUIState

{-| A mobile is a term from mud's used to indicate an character in the game that can take actions.
    This can be a player or a monster
-}
type alias Mobile =
  { name   : String
  , health : Int
  }

{-| The model is a user's data plus their current UI state -}
type alias Model =
  { user    : Maybe Mobile
  , uiState : UIState
  }

{-| LoginView sub commands -}
type LoginCmds
  = Click Int
  | Login

{-| RoomAction sub commands -}
type RoomCmds
  = Logout

{-| All possible Cmd messages that can be used to update the model. -}
type Msg
  = None
  | LoginView LoginCmds
  | RoomView  RoomCmds

{-| Creates the initial model. -}
init : Model
init = 
  { user = Nothing
  , uiState = LoginUIState
  }
