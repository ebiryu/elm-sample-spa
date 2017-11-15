module Update exposing (..)

import Animation exposing (px)
import Commands
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

        NextCondition1 ->
            ( { model
                | searchConditionStyle =
                    { searchFormView = fadeOutNext model.searchConditionStyle.searchFormView
                    , howManyPeopleView = fadeIn model.searchConditionStyle.howManyPeopleView
                    , datePickerView = model.searchConditionStyle.datePickerView
                    }
              }
            , Cmd.none
            )

        BeforeCondition1 ->
            ( { model
                | searchConditionStyle =
                    { searchFormView = fadeIn model.searchConditionStyle.searchFormView
                    , howManyPeopleView = fadeOutBefore model.searchConditionStyle.howManyPeopleView
                    , datePickerView = model.searchConditionStyle.datePickerView
                    }
              }
            , Cmd.none
            )

        NextCondition2 ->
            ( { model
                | searchConditionStyle =
                    { searchFormView = model.searchConditionStyle.searchFormView
                    , howManyPeopleView = fadeOutNext model.searchConditionStyle.howManyPeopleView
                    , datePickerView = fadeIn model.searchConditionStyle.datePickerView
                    }
              }
            , Cmd.none
            )

        BeforeCondition2 ->
            ( { model
                | searchConditionStyle =
                    { searchFormView = model.searchConditionStyle.searchFormView
                    , howManyPeopleView = fadeIn model.searchConditionStyle.howManyPeopleView
                    , datePickerView = fadeOutBefore model.searchConditionStyle.datePickerView
                    }
              }
            , Cmd.none
            )

        Animate animMsg ->
            { model
                | searchConditionStyle =
                    { searchFormView = Animation.update animMsg model.searchConditionStyle.searchFormView
                    , howManyPeopleView = Animation.update animMsg model.searchConditionStyle.howManyPeopleView
                    , datePickerView = Animation.update animMsg model.searchConditionStyle.datePickerView
                    }
            }
                ! []


easing =
    let
        params =
            { duration = 0.2 * Time.second
            , ease = Ease.outQuart
            }
    in
    Animation.easing params


fadeOutNext view =
    Animation.queue
        [ Animation.toWith easing
            [ Animation.translate (px 0.0) (px 0.0), Animation.opacity 0.0 ]
        ]
        view
        |> Animation.queue [ Animation.set [ Animation.display Animation.none ] ]


fadeOutBefore view =
    Animation.queue [ Animation.set [ Animation.display Animation.none ] ] view
        |> Animation.queue
            [ Animation.toWith easing
                [ Animation.translate (px 30.0) (px 0.0), Animation.opacity 0.0 ]
            ]


fadeIn view =
    Animation.queue [ Animation.wait (Time.second * 0.1) ] view
        |> Animation.queue [ Animation.set [ Animation.display Animation.block ] ]
        |> Animation.queue
            [ Animation.toWith easing
                [ Animation.translate (px 0.0) (px 0.0)
                , Animation.opacity 1.0
                ]
            ]
