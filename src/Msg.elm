module Msg exposing (..)

import Json.Encode exposing (Value)
import Model exposing (Place)
import Navigation
import RemoteData exposing (WebData)


type Msg
    = UrlChange Navigation.Location
    | ToggleDrawer
    | SetLatLong Float Float
    | OnFetchPlaces (WebData (List Place))
