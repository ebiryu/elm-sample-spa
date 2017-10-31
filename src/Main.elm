module Main exposing (..)

import Json.Encode exposing (Value)
import Model exposing (Model, Route(..))
import Msg exposing (Msg(..))
import Navigation
import Task
import Time exposing (Time)
import UrlParser as Url
import View exposing (view)


main : Program Never Model Msg
main =
    Navigation.program UrlChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- model


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    { history = [ Url.parseHash route location ]
    , currentRoute = Just Home
    , drawerState = False
    , coordinate = Model.initLatLng
    }
        ! []


route : Url.Parser (Route -> a) a
route =
    Url.oneOf
        [ Url.map Home Url.top
        , Url.map Birds (Url.s "birds")
        , Url.map Cats (Url.s "cats")
        , Url.map Dogs (Url.s "dogs")
        ]



-- update


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

        ToggleDrawer ->
            { model | drawerState = not model.drawerState } ! []

        SetLatLong lat long ->
            { model
                | coordinate = { latitude = lat, longitude = long }
            }
                ! []



-- subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
