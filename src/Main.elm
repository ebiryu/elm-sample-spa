module Main exposing (..)

import Animation
import Commands exposing (fetchPlaces)
import Model exposing (Model, Route(..))
import Msg exposing (Msg(..))
import Navigation
import RemoteData
import Update exposing (update)
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
    { history = [ Url.parseHash Update.route location ]
    , currentRoute = Url.parseHash Update.route location
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



-- subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Animation.subscription Animate
        [ model.searchConditionStyle.searchFormView
        , model.searchConditionStyle.howManyPeopleView
        ]
