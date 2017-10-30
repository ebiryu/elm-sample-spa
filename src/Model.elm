module Model exposing (..)


type alias Model =
    { history : List (Maybe Route)
    , currentRoute : Maybe Route
    , drawerState : Bool
    , coordinate : LatLong
    }


type alias LatLong =
    { latitude : Float
    , longitude : Float
    }


initLatLong : LatLong
initLatLong =
    { latitude = 48.2082, longitude = 16.3738 }


type Route
    = Home
    | Birds
    | Cats
    | Dogs
