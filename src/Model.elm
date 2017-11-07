module Model exposing (..)

import Json.Encode exposing (Value)
import RemoteData exposing (WebData)


type alias Model =
    { history : List (Maybe Route)
    , currentRoute : Maybe Route
    , drawerState : Bool
    , coordinate : LatLng
    , places : WebData (List Place)
    , toggleSearch : Bool
    }


type alias LatLng =
    { latitude : Float
    , longitude : Float
    }


initLatLng : LatLng
initLatLng =
    { latitude = 48.2082, longitude = 16.3738 }


type alias PlaceId =
    String


type alias Place =
    { id : PlaceId
    , name : String
    , latitude : Float
    , longitude : Float
    }


type Route
    = Home
    | Birds
    | Cats
    | Dogs
    | Map
