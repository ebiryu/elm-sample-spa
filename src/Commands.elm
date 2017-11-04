module Commands exposing (..)

import Http
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required)
import Json.Encode as Encode
import Model exposing (Place, PlaceId)
import Msg exposing (Msg)
import RemoteData


fetchPlaces : Cmd Msg
fetchPlaces =
    Http.get fetchPlaceUrl placesDecoder
        |> RemoteData.sendRequest
        |> Cmd.map Msg.OnFetchPlaces


fetchPlaceUrl : String
fetchPlaceUrl =
    "http://localhost:4000/places"


placesDecoder : Decode.Decoder (List Place)
placesDecoder =
    Decode.list placeDecoder


placeDecoder : Decode.Decoder Place
placeDecoder =
    decode Place
        |> required "id" Decode.string
        |> required "name" Decode.string
        |> required "latitude" Decode.float
        |> required "longitude" Decode.float
