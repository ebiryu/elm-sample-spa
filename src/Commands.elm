module Commands exposing (..)

import CsvDecode as Csv exposing ((|=))
import Http
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required)
import Json.Encode as Encode
import Model exposing (City, Place, PlaceId)
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


fetchCityList : Cmd Msg
fetchCityList =
    Http.send Msg.GetCityList <|
        Http.getString "http://localhost:3000/cities-in-japan.csv"


runCsvDecoder : String -> List City
runCsvDecoder string =
    Csv.run csvDecoder string
        |> Result.withDefault []


csvDecoder : Csv.Decoder City
csvDecoder =
    Csv.succeed City
        |= Csv.field "name"
        |= Csv.field "country"
        |= Csv.field "subcountry"
        |= Csv.field "geonameid"
