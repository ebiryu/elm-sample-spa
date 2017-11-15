module Main exposing (..)

import Animation exposing (px)
import Commands exposing (fetchPlaces)
import Dom
import Ease
import Model exposing (Model, Route(..))
import Msg exposing (Msg(..))
import Navigation
import RemoteData
import Search
import Task
import Time
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
    , currentRoute = Url.parseHash route location
    , drawerState = False
    , coordinate = Model.initLatLng
    , places = RemoteData.Loading
    , toggleSearch = False
    , searchString = ""
    , searchResult = []
    , selectedCityId = ""
    , cities = []
    , errMsg = ""
    , numOfPeople = { adult = 1, child = 0 }
    , searchConditionNumber = 0
    , searchConditionStyle =
        Model.initStyleOfConditions
    }
        ! [ fetchPlaces, Commands.fetchCityList ]


route : Url.Parser (Route -> a) a
route =
    Url.oneOf
        [ Url.map Home Url.top
        , Url.map Birds (Url.s "birds")
        , Url.map Cats (Url.s "cats")
        , Url.map Dogs (Url.s "dogs")
        , Url.map Map (Url.s "map")
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

        SetLatLng lat long ->
            { model | coordinate = { latitude = lat, longitude = long } } ! []

        SetLatitude lat ->
            { model | coordinate = { latitude = lat, longitude = model.coordinate.longitude } } ! []

        SetLongitude long ->
            { model | coordinate = { latitude = model.coordinate.latitude, longitude = long } } ! []

        OnFetchPlaces response ->
            { model | places = response } ! []

        ToggleSearch ->
            { model | toggleSearch = not model.toggleSearch, searchConditionStyle = Model.initStyleOfConditions }
                ! [ Task.attempt FocusOnInput (Dom.focus "search-place") ]

        FocusOnInput id ->
            ( model, Cmd.none )

        StartSearching string ->
            { model | searchString = string, searchResult = Search.runFilter2 string model.cities } ! []

        SelectCityId id ->
            { model | selectedCityId = id } ! []

        GetCityList (Ok cities) ->
            { model | cities = Commands.runCsvDecoder cities } ! []

        GetCityList (Err err) ->
            ( { model | errMsg = toString err }, Cmd.none )

        SelectNumOfPeople adult child ->
            { model | numOfPeople = { adult = adult, child = child } } ! []

        SetNumOfAdult adult ->
            { model
                | numOfPeople =
                    { adult = Result.withDefault 0 (String.toInt adult)
                    , child = model.numOfPeople.child
                    }
            }
                ! []

        SetNumOfChild child ->
            { model
                | numOfPeople =
                    { adult = model.numOfPeople.adult
                    , child = Result.withDefault 0 (String.toInt child)
                    }
            }
                ! []

        NextCondition num ->
            ( { model
                | searchConditionStyle =
                    { searchFormView = fadeOutNext model.searchConditionStyle.searchFormView
                    , howManyPeopleView = fadeIn model.searchConditionStyle.howManyPeopleView
                    }
              }
            , Cmd.none
            )

        BeforeCondition ->
            ( { model
                | searchConditionStyle =
                    { searchFormView = fadeIn model.searchConditionStyle.searchFormView
                    , howManyPeopleView = fadeOutBefore model.searchConditionStyle.howManyPeopleView
                    }
              }
            , Cmd.none
            )

        Animate animMsg ->
            { model
                | searchConditionStyle =
                    { searchFormView = Animation.update animMsg model.searchConditionStyle.searchFormView
                    , howManyPeopleView = Animation.update animMsg model.searchConditionStyle.howManyPeopleView
                    }
            }
                ! []


easing =
    let
        params =
            { duration = 0.2 * Time.second
            , ease = Ease.outCubic
            }
    in
    Animation.easing params


fadeOutNext view =
    Animation.queue
        [ Animation.toWith easing
            [ Animation.left (px 0.0)
            , Animation.opacity 0.0
            , Animation.width (Animation.percent 95)
            , Animation.height (Animation.percent 95)
            ]
        ]
        view
        |> Animation.queue [ Animation.set [ Animation.display Animation.none ] ]


fadeOutBefore view =
    Animation.queue
        [ Animation.toWith easing
            [ Animation.left (px 30.0), Animation.opacity 0.0 ]
        ]
        view
        |> Animation.queue [ Animation.set [ Animation.display Animation.none ] ]


fadeIn view =
    Animation.queue [ Animation.wait (Time.second * 0.1) ] view
        |> Animation.queue [ Animation.set [ Animation.display Animation.block ] ]
        |> Animation.queue
            [ Animation.toWith easing
                [ Animation.left (px 0.0)
                , Animation.opacity 1.0
                , Animation.width (Animation.percent 100)
                , Animation.height (Animation.percent 100)
                ]
            ]



-- subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Animation.subscription Animate
        [ model.searchConditionStyle.searchFormView
        , model.searchConditionStyle.howManyPeopleView
        ]
