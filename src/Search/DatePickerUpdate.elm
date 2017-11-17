module Search.DatePickerUpdate exposing (..)

import Date exposing (Date)
import Date.Extra.Create exposing (dateFromFields)
import Date.Extra.Duration as Duration


type Msg
    = Noop
    | NextMonth
    | PrevMonth


type alias Model =
    { date : Date
    , check : Check
    }


initDatePicker =
    { date = dateFromFields 2017 Date.Nov 9 0 0 0 0
    , check = CheckIn
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        Noop ->
            model

        NextMonth ->
            { model | date = Duration.add Duration.Month 1 model.date }

        PrevMonth ->
            { model | date = Duration.add Duration.Month -1 model.date }


type Check
    = CheckIn
    | CheckOut
