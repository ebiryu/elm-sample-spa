module Msg exposing (..)

import Json.Encode exposing (Value)
import Navigation


type Msg
    = UrlChange Navigation.Location
    | ToggleDrawer
    | SetLatLong Float Float
