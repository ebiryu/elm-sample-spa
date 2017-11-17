module Search.DatePicker exposing (..)

import Date exposing (Date)
import Date.Extra.Config.Config_ja_jp exposing (config)
import Date.Extra.Core exposing (daysInMonth, intToMonth, isoDayOfWeek, toFirstOfMonth)
import Date.Extra.Duration as Duration
import Date.Extra.Field as Field
import Date.Extra.Format as DateFormat
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Msg exposing (Msg(..))
import Search.DatePickerUpdate exposing (Model, Msg(..))


view model =
    div [ class "absolute absolute--fill bg-black-50 z2" ]
        [ div [ class "absolute absolute--fill ma-auto mw6 h5 bg-white-10" ]
            [ header model
            , picker model
            ]
        ]


header model =
    div [ class "db bg-light-blue w-100 h-25" ]
        [ text <|
            Result.withDefault "Failed to get a date." <|
                Result.map
                    (DateFormat.format config config.format.dateTime)
                    (Date.fromString <| toString model.date)
        ]


picker : Model -> Html Msg.Msg
picker model =
    let
        date =
            model.date

        check =
            model.check
    in
    div [ class "db bg-near-white w-100 h-75" ]
        [ div [ class "flex justify-between" ]
            [ button [ class "pointer outline-0", onClick (DatePickerMsg PrevMonth check) ]
                [ i [ class "material-icons md-24 near-black" ] [ text "navigate_before" ] ]
            , div [ class "flex items-center" ]
                [ Date.year date
                    |> toString
                    |> (\n -> n ++ "年")
                    |> text
                , Date.month date
                    |> config.i18n.monthName
                    |> text
                ]
            , button [ class "pointer outline-0", onClick (DatePickerMsg NextMonth check) ]
                [ i [ class "material-icons md-24 near-black" ] [ text "navigate_next" ] ]
            ]
        ]
