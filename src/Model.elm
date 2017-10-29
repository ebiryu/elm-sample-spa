module Model exposing (..)


type alias Model =
    { history : List (Maybe Route)
    , currentRoute : Maybe Route
    , drawerState : Bool
    }


type Route
    = Home
    | Birds
    | Cats
    | Dogs
