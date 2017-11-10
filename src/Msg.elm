module Msg exposing (..)

import Dom
import Http
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
    | StartSearching String
    | FocusOnInput (Result Dom.Error ())
    | SelectPlaceId String
    | GetCityList (Result Http.Error String)
