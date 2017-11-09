module Search exposing (..)

import Model exposing (Place, Places)
import RemoteData


runFilter : String -> Places -> List ( Model.PlaceId, String )
runFilter string placesData =
    case placesData of
        RemoteData.NotAsked ->
            []

        RemoteData.Loading ->
            [ ( "", "Loading" ) ]

        RemoteData.Success places ->
            if string == "" then
                []
            else
                filtering string places

        RemoteData.Failure error ->
            [ ( "", toString error ) ]


filtering : String -> List Place -> List ( Model.PlaceId, String )
filtering string places =
    List.map (\p -> ( p.id, p.name )) places
        |> List.filter (\( _, p ) -> String.contains string p)
