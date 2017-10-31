module Model exposing (..)

import Json.Encode exposing (Value)


type alias Model =
    { history : List (Maybe Route)
    , currentRoute : Maybe Route
    , drawerState : Bool
    , coordinate : LatLng
    }


type alias LatLng =
    { latitude : Float
    , longitude : Float
    }


initLatLng : LatLng
initLatLng =
    { latitude = 48.2082, longitude = 16.3738 }


type Route
    = Home
    | Birds
    | Cats
    | Dogs
