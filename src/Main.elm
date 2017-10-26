module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Navigation
import Style as Style
import UrlParser as Url


main : Program Never Model Msg
main =
    Navigation.program UrlChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- model


type alias Model =
    { history : List (Maybe Route)
    , currentRoute : Maybe Route
    }


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    { history = [ Url.parseHash route location ]
    , currentRoute = Just Home
    }
        ! []


type Route
    = Home
    | Birds
    | Cats
    | Dogs


route : Url.Parser (Route -> a) a
route =
    Url.oneOf
        [ Url.map Home Url.top
        , Url.map Birds (Url.s "birds")
        , Url.map Cats (Url.s "cats")
        , Url.map Dogs (Url.s "dogs")
        ]



-- view


view : Model -> Html Msg
view model =
    div []
        [ Html.node "link" [ Html.Attributes.rel "stylesheet", Html.Attributes.href "../normalize.css" ] []
        , Html.node "link" [ Html.Attributes.rel "stylesheet", Html.Attributes.href "../style.css" ] []
        , header_ model
        , mainView model
        ]


header_ : Model -> Html msg
header_ model =
    header [ style Style.header ]
        [ a [ style Style.headerTitle, href "#" ] [ text "elm-sample-spa" ]
        , ul [ style Style.headerTabs ]
            (List.map viewLinkTab [ "birds", "cats", "dogs" ])
        ]


mainView : Model -> Html msg
mainView model =
    div [ style Style.boxed ]
        [ h1 [] [ text "Pages" ]
        , ul [] (List.map viewLink [ "birds", "cats", "dogs" ])
        , case model.currentRoute of
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


homeView : Model -> Html msg
homeView model =
    div []
        [ h1 [] [ text "History" ]
        , ul [] (List.map viewRoute (List.reverse model.history))
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



-- update


type Msg
    = UrlChange Navigation.Location


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlChange location ->
            let
                nextRoute =
                    Url.parseHash route location
            in
            { model
                | currentRoute = nextRoute
                , history = nextRoute :: model.history
            }
                ! []



-- subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
