module Search.DatePicker exposing (..)

import Date
import Date.Extra.Config.Config_ja_jp exposing (config)
import Date.Extra.Core exposing (daysInMonth, intToMonth, isoDayOfWeek, toFirstOfMonth)
import Date.Extra.Duration as Duration
import Date.Extra.Field as Field
import Date.Extra.Format as DateFormat
import Html exposing (..)
import Html.Attributes exposing (..)


view model =
    div [ class "w-100 h-75 center" ]
        [ div [ class "tc" ]
            [ div [ class "dib w5 f6 f5-l white pa2 ba br2 b--white ma1 hover-bg-white-20 pointer" ]
                [ text "チェックイン: "
                , text model.dateCheckIn
                ]
            , div [ class "dib w5 f6 f5-l white pa2 ba br2 b--white ma1 hover-bg-white-20 pointer" ]
                [ text "チェックアウト: "
                , text model.dateCheckOut
                ]
            , datePicker model
            ]
        ]


datePicker model =
    div [ class "absolute absolute--fill bg-black-10 z2" ]
        [ div [ class "absolute absolute--fill ma-auto mw6 h5 bg-white-10" ]
            [ header
            , picker
            ]
        ]


header =
    div [ class "db bg-light-blue w-100 h-25" ]
        [ text <|
            Result.withDefault "Failed to get a date." <|
                Result.map
                    (DateFormat.format config config.format.dateTime)
                    (Date.fromString "2015-06-01 12:45:14.211Z")
        ]


picker =
    div [ class "db bg-near-white w-100 h-75" ]
        [ div [ class "flex justify-between" ]
            [ button [ class "pointer outline-0" ]
                [ i [ class "material-icons md-24 near-black" ] [ text "navigate_before" ] ]
            , button [ class "pointer outline-0" ]
                [ i [ class "material-icons md-24 near-black" ] [ text "navigate_next" ] ]
            ]
        ]
