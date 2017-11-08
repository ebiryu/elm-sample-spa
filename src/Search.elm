module Search exposing (..)

import Model exposing (Place, Places)
import RemoteData


runFilter : String -> Places -> List String
runFilter string placesData =
    case placesData of
        RemoteData.NotAsked ->
            []

        RemoteData.Loading ->
            [ "Loading" ]

        RemoteData.Success places ->
            if string == "" then
                []
            else
                filtering string places

        RemoteData.Failure error ->
            [ toString error ]


filtering : String -> List Place -> List String
filtering string places =
    List.map .name places
        |> List.filter (String.contains string)
