module Search.DatePicker exposing (..)

import Date
import Html exposing (..)
import Html.Attributes exposing (..)


view model =
    div [ class "w-100 h-75 center relative" ]
        [ div [ class "tc" ]
            [ div [ class "dib w5 f6 f5-l white pa2 ba br2 b--white ma1 hover-bg-white-20 pointer" ]
                [ text "チェックイン: "
                , text model.dateCheckIn
                ]
            , div [ class "dib w5 f6 f5-l white pa2 ba br2 b--white ma1 hover-bg-white-20 pointer" ]
                [ text "チェックアウト: "
                , text model.dateCheckOut
                ]
            ]
        , div [ class "absolute absolute--fill ma-auto mw6 h5 bg-white-10" ]
            [ text <| toString <| Date.fromString model.dateNow ]
        ]
