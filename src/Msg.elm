module Msg exposing (..)

import Json.Encode exposing (Value)
import Model exposing (Place)
import Navigation
import RemoteData exposing (WebData)


type Msg
    = UrlChange Navigation.Location
    | ToggleDrawer
    | SetLatLng Float Float
    | SetLatitude Float
    | SetLongitude Float
    | OnFetchPlaces (WebData (List Place))
    | ToggleSearch
