module Msg exposing (..)

import Json.Encode exposing (Value)
import Navigation
import Time exposing (Time)


type Msg
    = UrlChange Navigation.Location
    | ToggleDrawer
    | SetLatLong Float Float
    | JSMap Value
    | Tick Time
