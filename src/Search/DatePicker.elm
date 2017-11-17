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
        [ div
            [ class "absolute absolute--fill ma-auto bg-white-10 shadow-2"
            , style
                [ ( "height", "26rem" )
                , ( "width", "20rem" )
                ]
            ]
            [ header model
            , picker model
            ]
        ]


header model =
    div
        [ class "db bg-navy w-100"
        , style [ ( "height", "6rem" ) ]
        ]
        [ div [ class "db pt3 ml3 gray" ]
            [ text <| toString <| Date.year model.date ]
        , div [ class "db ml3 f2 near-white" ] [ text (DateFormat.format config "%b/%-d (%a)" model.date) ]
        ]


picker : Model -> Html Msg.Msg
picker model =
    let
        date =
            model.date

        check =
            model.check
    in
    div
        [ class "db bg-near-white w-100"
        , style [ ( "height", "20rem" ) ]
        ]
        [ div [ class "flex justify-between mh3 pa3" ]
            [ button [ class "pointer outline-0 bg-near-white", onClick (DatePickerMsg PrevMonth check) ]
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
            , button [ class "pointer outline-0 bg-near-white", onClick (DatePickerMsg NextMonth check) ]
                [ i [ class "material-icons md-24 near-black" ] [ text "navigate_next" ] ]
            ]
        , weekDays
        , monthDays model
        ]


weekDays : Html Msg.Msg
weekDays =
    let
        days =
            List.map (\day -> span [ style [ ( "width", "14%" ) ] ] [ text day ]) [ "日", "月", "火", "水", "木", "金", "土" ]
    in
    div [ class "f6 flex justify-between tc mh2 pb2 gray" ] days


monthDays : Model -> Html Msg.Msg
monthDays model =
    let
        daysCount =
            daysInMonth (Date.year model.date) (Date.month model.date)

        leftPadding =
            model.date
                |> toFirstOfMonth
                |> Date.dayOfWeek
                |> isoDayOfWeek
                |> (%) 7

        rightPadding =
            42 - leftPadding - daysCount

        weeks =
            chunks 7 (List.repeat leftPadding 0 ++ List.range 1 daysCount ++ List.repeat rightPadding 0)

        rows =
            List.map (\week -> weekRow (Date.day model.date) week) weeks
    in
    div [] rows


chunks : Int -> List Int -> List (List Int)
chunks a xs =
    if List.length xs > a then
        List.take a xs :: chunks a (List.drop a xs)
    else
        [ xs ]


weekRow : Int -> List Int -> Html Msg.Msg
weekRow currentDay days =
    div [ class "flex justify-between tc mh2" ] (List.map (dayCell currentDay) days)


dayCell : Int -> Int -> Html Msg.Msg
dayCell currentDay day =
    if day > 0 then
        div [ class "f6 pv2 navy", style [ ( "width", "14%" ) ] ] [ div [] [ text (toString day) ] ]
    else
        div [ class "pv2", style [ ( "width", "14%" ) ] ] [ div [] [ text "" ] ]
