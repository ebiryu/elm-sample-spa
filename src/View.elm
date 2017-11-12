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
    if model.toggleSearch then
        searchView model
    else
        div
            (case model.drawerState of
                True ->
                    [ onClick ToggleDrawer ]

                False ->
                    []
            )
            [ Html.node "link" [ Html.Attributes.rel "stylesheet", Html.Attributes.href "./normalize.css" ] []
            , Html.node "link" [ Html.Attributes.rel "stylesheet", Html.Attributes.href "./style.css" ] []
            , header_ model
            , mainView model
            ]


header_ : Model -> Html Msg
header_ model =
    -- header [ style Style.header ]
    header [ class "flex items-center bg-blue h3 shadow-2" ]
        [ a
            (case model.drawerState of
                True ->
                    []

                False ->
                    [ onClick ToggleDrawer ]
            )
            [ i
                [ class "white ma2 material-icons md-36 pointer"
                ]
                [ text "menu" ]
            ]
        , a [ class "link white f2", href "#" ] [ text "elm-sample-spa" ]
        , div [ class "ml-auto mr2 flex" ]
            (List.map viewLinkTab [ "birds", "cats", "dogs", "map" ])
        , case model.drawerState of
            True ->
                ul [ style Style.drawer ]
                    (List.map viewLink [ "birds", "cats", "dogs", "map" ])

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

            Just Map ->
                mapView model

            Nothing ->
                notFoundView
        ]


homeView : Model -> Html Msg
homeView model =
    div []
        [ h1 [] [ text "History" ]
        , ul [] (List.map viewRoute (List.reverse model.history))
        , h1 [] [ text "Search" ]
        , a
            [ class "no-underline near-white bg-animate bg-near-black hover-bg-gray inline-flex items-center ma2 tc br2 pa2 pointer"
            , onClick ToggleSearch
            ]
            [ i [ class "material-icons dib h2 w2 md-36" ] [ text "search" ]
            , span [ class "f6 ml3 pr2" ] [ text "Search" ]
            ]
        ]


searchView : Model -> Html Msg
searchView model =
    div [ class "bg-blue w-100 h-100 absolute top-0 left-0 fixed" ]
        [ i [ class "material-icons md-48 ml3 ml5-ns mt5 white pointer", onClick ToggleSearch ] [ text "clear" ]
        , div [ class "mh-3 mh5-ns w-75" ]
            [ searchFormView model
            ]
        ]


searchFormView : Model -> Html Msg
searchFormView model =
    div [ class "w-100" ]
        [ div [ class "f3 pv2 white" ] [ text "検索" ]
        , input
            [ id "search-place"
            , type_ "search"
            , class "f6 f5-l input-reset bn pa3 br2 w-100 w-75-m w-80-l"
            , placeholder "場所を入力"
            , onInput StartSearching
            ]
            []
        , ul [ class "list pa1 overflow-auto vh-50 bt bb b--white-50" ]
            (List.map searchResultList model.searchResult)
        ]


searchResultList : ( Model.PlaceId, String ) -> Html Msg
searchResultList ( id, string ) =
    li
        [ class "b--white bb bw1 br2 ma1 ph2 pv3 white f3 hover-bg-white-20 pointer"
        , onClick (SelectCityId id)
        ]
        [ text string ]


mapView : Model -> Html Msg
mapView model =
    div []
        [ mapboxWC model
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
        [ attribute "map" "{{map}}"
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
    div []
        [ article
            [ class "center mw5 mw6-ns br3 hidden ba b--black-10 mv4"
            , onMouseOver (SetLatLng place.latitude place.longitude)
            ]
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
    span [ class "dim h2 w3 dn dib-l" ]
        [ a [ href ("#" ++ name), class "link flex justify-center items-center h2 mr1 ml1 white ba br3 bw1 b--white" ]
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
