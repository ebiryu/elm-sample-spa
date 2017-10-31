module Msg exposing (..)

import Navigation


type Msg
    = UrlChange Navigation.Location
    | ToggleDrawer
    | SetLatLong Float Float