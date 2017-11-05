module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Decode
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
        , div [ style Style.headerTabs ]
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


mapboxWC : Model -> Html Msg
mapboxWC model =
    node "mapbox-gl"
        [ attribute "interactive" ""
        , attribute "map" "{{map}}"
        , attribute "script-src" "https://api.mapbox.com/mapbox-gl-js/v0.32.1/mapbox-gl.js"
        , attribute "access-token" mapboxToken
        , attribute "latitude" (toString model.coordinate.latitude)
        , attribute "longitude" (toString model.coordinate.longitude)
        , attribute "zoom" (toString 13)
        , latitudeChange model
        , longitudeChange model
        ]
        []


latitudeChange : Model -> Attribute Msg
latitudeChange model =
    on "latitude-changed" <|
        Decode.map SetLatitude (Decode.at [ "target", "latitude" ] Decode.float)


longitudeChange : Model -> Attribute Msg
longitudeChange model =
    on "longitude-changed" <|
        Decode.map SetLongitude (Decode.at [ "target", "longitude" ] Decode.float)


listPlaces : List Model.Place -> Html Msg
listPlaces places =
    div [ class "list p10" ] (List.map placeLi places)


placeLi : Model.Place -> Html Msg
placeLi place =
    div [ onClick (SetLatLng place.latitude place.longitude) ]
        [ article [ class "center mw5 mw6-ns br3 hidden ba b--black-10 mv4" ]
            [ div [ class "f4 bg-near-white br3 br--top black-60 mv0 pv2 ph3" ] [ text place.name ]
            , div [ class "pa3 bt b--black-10" ]
                [ pInList <| toString place.latitude
                , pInList <| toString place.longitude
                ]
            ]
        ]


pInList : String -> Html msg
pInList string =
    p [ class "f6 f5-ns lh-copy measure" ] [ text string ]


viewRoute : Maybe Route -> Html msg
viewRoute maybeRoute =
    case maybeRoute of
        Nothing ->
            li [] [ text "Invalid URL" ]

        Just route ->
            li [] [ text (toString route) ]


viewLinkTab : String -> Html msg
viewLinkTab name =
    span [ style Style.headerTab, class "headerTabA" ]
        [ a [ href ("#" ++ name), style Style.headerTabA, class "ba br3 bw1 b--white" ]
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
