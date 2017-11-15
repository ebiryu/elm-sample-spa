module Model exposing (..)

import Animation exposing (px)
import Json.Encode exposing (Value)
import RemoteData exposing (WebData)


type alias Model =
    { history : List (Maybe Route)
    , currentRoute : Maybe Route
    , drawerState : Bool
    , coordinate : LatLng
    , places : Places
    , toggleSearch : Bool
    , searchString : String
    , searchResult : List ( CityId, String )
    , selectedCityId : CityId
    , cities : List City
    , errMsg : String
    , numOfPeople : NumOfPeople
    , searchConditionNumber : Int
    , searchConditionStyle : StyleOfConditions
    }


type alias LatLng =
    { latitude : Float
    , longitude : Float
    }


initLatLng : LatLng
initLatLng =
    { latitude = 48.2082, longitude = 16.3738 }


type alias PlaceId =
    String


type alias Place =
    { id : PlaceId
    , name : String
    , latitude : Float
    , longitude : Float
    }


type alias Places =
    WebData (List Place)


type Route
    = Home
    | Birds
    | Cats
    | Dogs
    | Map


type alias City =
    { name : String
    , country : String
    , subcountry : String
    , geonameid : CityId
    }


type alias CityId =
    String


type alias NumOfPeople =
    { adult : Int
    , child : Int
    }


type alias StyleOfConditions =
    { searchFormView : Animation.State
    , howManyPeopleView : Animation.State
    }


initStyleOfConditions =
    { searchFormView =
        Animation.style
            [ Animation.left (px 0.0)
            , Animation.opacity 1.0
            , Animation.width (Animation.percent 100)
            , Animation.height (Animation.percent 100)
            ]
    , howManyPeopleView =
        Animation.style
            [ Animation.left (px 30.0)
            , Animation.opacity 0.0
            , Animation.display Animation.none
            , Animation.width (Animation.percent 100)
            , Animation.height (Animation.percent 100)
            ]
    }
