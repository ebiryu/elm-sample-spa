module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Material
import Material.Color as Color
import Material.Layout as Layout
import Material.Scheme as Scheme
import Navigation
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
    , mdl : Material.Model -- Boilerplate
    }


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    ( { history = [ Url.parseHash route location ]
      , currentRoute = Just Home
      , mdl = Layout.setTabsWidth 2124 Material.model
      }
    , Material.init Mdl
      -- Boilerplate
    )


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
    Layout.render Mdl
        model.mdl
        []
        { header = header model
        , drawer = []
        , tabs = ( [], [] )
        , main = mainView model
        }
        |> (\contents ->
                div []
                    [ Scheme.topWithScheme Color.Blue Color.Amber contents ]
           )


header : Model -> List (Html msg)
header model =
    [ Layout.title [] [ text "elm-sample-spa" ] ]


mainView : Model -> List (Html msg)
mainView model =
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
        , ul [] (List.map viewRoute model.history)
        ]


viewRoute : Maybe Route -> Html msg
viewRoute maybeRoute =
    case maybeRoute of
        Nothing ->
            li [] [ text "Invalid URL" ]

        Just route ->
            li [] [ text (toString route) ]


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
    | Mdl (Material.Msg Msg) -- Boilerplate


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

        Mdl message_ ->
            Material.update Mdl message_ model



-- subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ Material.subscriptions Mdl model ]
