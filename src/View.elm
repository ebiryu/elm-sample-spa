module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import MapboxAccessToken exposing (mapboxToken)
import Model exposing (Model, Route(..))
import Msg exposing (Msg(..))
import RemoteData
import Style as Style


view : Model -> Html Msg
view model =
    div
        (case model.drawerState of
            True ->
                [ onClick ToggleDrawer ]

            False ->
                []
        )
        [ Html.node "link"
            [ Html.Attributes.rel "stylesheet"
            , Html.Attributes.href "https://fonts.googleapis.com/icon?family=Material+Icons"
            ]
            []
        , Html.node "link" [ Html.Attributes.rel "stylesheet", Html.Attributes.href "./normalize.css" ] []
        , Html.node "link" [ Html.Attributes.rel "stylesheet", Html.Attributes.href "./style.css" ] []
        , header_ model
        , mainView model
        ]


header_ : Model -> Html Msg
header_ model =
    header [ style Style.header ]
        [ a
            (case model.drawerState of
                True ->
                    []

                False ->
                    [ onClick ToggleDrawer ]
            )
            [ i
                [ style Style.headerDrawerIcon
                , class "material-icons md-36"
                ]
                [ text "menu" ]
            ]
        , a [ style Style.headerTitle, href "#" ] [ text "elm-sample-spa" ]
        , ul [ style Style.headerTabs ]
            (List.map viewLinkTab [ "birds", "cats", "dogs" ])
        , case model.drawerState of
            True ->
                ul [ style Style.drawer ]
                    (List.map viewLink [ "birds", "cats", "dogs" ])

            False ->
                span [] []
        ]


mainView : Model -> Html Msg
mainView model =
    div [ style Style.boxed ]
        [ case model.currentRoute of
            Just Home ->
                homeView model

            Just Birds ->
                animalView "birds" "have wings and a beak"

            Just Cats ->
                animalView "cats" ""

            Just Dogs ->
                animalView "dogs" ""

            Nothing ->
                notFoundView
        ]


homeView : Model -> Html Msg
homeView model =
    div []
        [ h1 [] [ text "History" ]
        , ul [] (List.map viewRoute (List.reverse model.history))
        , mapboxWC model
        , div []
            [ text <| toString model.coordinate.latitude
            , text " "
            , text <| toString model.coordinate.longitude
            ]
        , case model.places of
            RemoteData.NotAsked ->
                text ""

            RemoteData.Loading ->
                text "Loading"

            RemoteData.Success places ->
                listPlaces places

            RemoteData.Failure error ->
                text (toString error)
        ]


mapboxWC : Model -> Html msg
mapboxWC model =
    node "mapbox-gl"
        [ attribute "interactive" ""
        , attribute "script-src" "https://api.mapbox.com/mapbox-gl-js/v0.32.1/mapbox-gl.js"
        , attribute "access-token" mapboxToken
        , attribute "latitude" (toString model.coordinate.latitude)
        , attribute "longitude" (toString model.coordinate.longitude)
        ]
        []


listPlaces : List Model.Place -> Html msg
listPlaces places =
    ul [] (List.map placeLi places)


placeLi : Model.Place -> Html msg
placeLi place =
    li []
        [ text place.name
        , text <| toString place.latitude
        , text <| toString place.longitude
        ]


viewRoute : Maybe Route -> Html msg
viewRoute maybeRoute =
    case maybeRoute of
        Nothing ->
            li [] [ text "Invalid URL" ]

        Just route ->
            li [] [ text (toString route) ]


viewLinkTab : String -> Html msg
viewLinkTab name =
    li [ style Style.headerTab, class "headerTabA" ]
        [ a [ href ("#" ++ name), style Style.headerTabA ]
            [ span [] [ text name ] ]
        ]


viewLink : String -> Html msg
viewLink name =
    li [] [ a [ href ("#" ++ name) ] [ text name ] ]


animalView : String -> String -> Html msg
animalView name description =
    let
        animalDescription =
            name ++ " " ++ description
    in
    div []
        [ p [] [ a [ href "#" ] [ text "Back to index" ] ]
        , h1 [] [ text animalDescription ]
        ]


notFoundView : Html msg
notFoundView =
    div []
        [ h1 [] [ text "Not found :(" ]
        ]
