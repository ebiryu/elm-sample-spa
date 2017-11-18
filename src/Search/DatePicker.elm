module Search.DatePicker exposing (..)

import Date exposing (Date)
import Date.Extra.Config.Config_ja_jp exposing (config)
import Date.Extra.Core exposing (daysInMonth, intToMonth, isoDayOfWeek, toFirstOfMonth)
import Date.Extra.Duration as Duration
import Date.Extra.Format as DateFormat
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Msg exposing (Msg(..))
import Search.DatePickerUpdate exposing (Check, Model, Msg(..))


view model =
    div [ class "absolute absolute--fill bg-black-50 z2" ]
        [ div [ class "absolute absolute--fill", onClick (ToggleDatePicker model.check) ] []
        , div
            [ class "absolute absolute--fill ma-auto bg-white-10 shadow-2"
            , style
                [ ( "height", "27rem" )
                , ( "width", "21rem" )
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
        , style [ ( "height", "21rem" ) ]
        ]
        [ div [ class "flex justify-between mh3 pa1" ]
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
                |> (\n -> (n + 1) % 7)

        rightPadding =
            42 - leftPadding - daysCount

        weeks =
            chunks 7 (List.repeat leftPadding 0 ++ List.range 1 daysCount ++ List.repeat rightPadding 0)

        rows =
            List.map (\week -> weekRow model.check (Date.day model.date) week) weeks
    in
    div [] rows


chunks : Int -> List Int -> List (List Int)
chunks a xs =
    if List.length xs > a then
        List.take a xs :: chunks a (List.drop a xs)
    else
        [ xs ]


weekRow : Check -> Int -> List Int -> Html Msg.Msg
weekRow check currentDay days =
    div [ class "flex justify-between tc mb1 mh2" ] (List.map (dayCell check currentDay) days)


dayCell : Check -> Int -> Int -> Html Msg.Msg
dayCell check currentDay day =
    if day > 0 then
        div
            [ class "f6 pointer flex justify-center items-center hover-bg-black-10"
            , style [ ( "width", "40px" ), ( "height", "40px" ), ( "border-radius", "100%" ) ]
            , classList [ ( "bg-navy hover-bg-navy white", currentDay == day ) ]
            , onClick (DatePickerMsg (ClickDay day) check)
            ]
            [ div [ class "flex justify-center items-center" ] [ text (toString day) ] ]
    else
        div [ class "pv2", style [ ( "width", "40px" ) ] ]
            [ div [] [ text "" ] ]
