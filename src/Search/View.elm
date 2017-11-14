module Search.View exposing (view)

import Animation
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model exposing (Model, Route(..))
import Msg exposing (Msg(..))


view : Model -> Html Msg
view model =
    div [ class "bg-blue w-100 vh-100 absolute top-0 left-0 fixed" ]
        [ i [ class "material-icons md-48 ml3 ml5-ns mt5 white pointer", onClick ToggleSearch ] [ text "clear" ]
        , div
            [ class "db relative w-80 h-70-l center"
            ]
            [ searchFormView model
            , howManyPeopleView model
            ]
        , div
            [ class "absolute bottom-2 db br4 bg-white-10 shadow-1 pointer center"
            , style [ ( "width", "3rem" ), ( "height", "3rem" ) ]
            , onClick (NextCondition <| model.searchConditionNumber + 1)
            ]
            [ i [ class "material-icons md-48 white" ] [ text "navigate_next" ]
            ]
        ]


inlineClass =
    "w-100 h-70-l dib v-top center mv2 pa3 br3 ba bw2 b--white shadow-2 absolute"


searchFormView : Model -> Html Msg
searchFormView model =
    div
        (List.concat
            [ Animation.render model.searchConditionStyle.searchFormView
            , [ class inlineClass ]
            ]
        )
        [ div [ class "f3 mb2 white" ] [ text "検索" ]
        , input
            [ id "search-place"
            , type_ "search"
            , class "f6 f5-l input-reset bn pa3 br2 w-100"
            , placeholder "場所を入力"
            , onInput StartSearching
            ]
            []
        , ul [ class "list pa1 overflow-auto vh-50 bt bb b--white-50" ]
            (List.map searchResultList model.searchResult)
        ]


searchResultList : ( Model.PlaceId, String ) -> Html Msg
searchResultList ( id, string ) =
    li
        [ class "b--white bb bw1 br2 br--top ma1 ph2 pv3 white f3 hover-bg-white-20 pointer"
        , onClick (SelectCityId id)
        ]
        [ text string ]


howManyPeopleView : Model -> Html Msg
howManyPeopleView model =
    div
        (List.concat
            [ Animation.render model.searchConditionStyle.howManyPeopleView
            , [ class inlineClass ]
            ]
        )
        [ div [ class "f3 mb2 white" ] [ text "人数" ]
        , div [ class "w-90-m w-70-l center ws-normal flex-auto" ]
            [ div
                [ class numOfPeopleButtonClass
                , onClick (SelectNumOfPeople 1 0)
                , classList [ ( "bg-white-20", (model.numOfPeople.adult == 1) && (model.numOfPeople.child == 0) ) ]
                ]
                [ span [ class "h-75 db" ]
                    [ i [ class "material-icons md-66 white mt3 mb1 dib v-btm" ] [ text "person" ]
                    ]
                , span [ class "f5 white pb1" ] [ text "大人: 1" ]
                ]
            , div
                [ class numOfPeopleButtonClass
                , onClick (SelectNumOfPeople 0 1)
                , classList [ ( "bg-white-20", (model.numOfPeople.adult == 0) && (model.numOfPeople.child == 1) ) ]
                ]
                [ span [ class "h-75 db" ]
                    [ i [ class "material-icons md-40 white mt4 mb2 dib v-btm" ] [ text "person" ]
                    ]
                , span [ class "f5 white pb1" ] [ text "子供: 1" ]
                ]
            , div
                [ class numOfPeopleButtonClass
                , onClick (SelectNumOfPeople 2 0)
                , classList [ ( "bg-white-20", (model.numOfPeople.adult == 2) && (model.numOfPeople.child == 0) ) ]
                ]
                [ span [ class "h-75 db" ]
                    [ i [ class "material-icons md-66 white mt3 mb1 dib v-btm" ] [ text "people" ]
                    ]
                , span [ class "f5 white pb1" ] [ text "大人: 2" ]
                ]
            , div
                [ class numOfPeopleButtonClass
                , onClick (SelectNumOfPeople 2 1)
                , classList [ ( "bg-white-20", (model.numOfPeople.adult == 2) && (model.numOfPeople.child == 1) ) ]
                ]
                [ span [ class "h-75 db" ]
                    [ i [ class "material-icons md-72 white mt3 mb2 dib v-btm" ] [ text "people" ]
                    , i [ class "material-icons md-40 white mt3 mb3 dib v-btm" ] [ text "person" ]
                    ]
                , span [ class "f5 white pb1" ] [ text "大人: 2, 子供: 1" ]
                ]
            , div
                [ class numOfPeopleButtonClass
                , onClick (SelectNumOfPeople 2 2)
                , classList [ ( "bg-white-20", (model.numOfPeople.adult == 2) && (model.numOfPeople.child == 2) ) ]
                ]
                [ span [ class "h-75 db" ]
                    [ i [ class "material-icons md-72 white mt3 mb2 dib v-btm" ] [ text "people" ]
                    , i [ class "material-icons md-40 white mt3 mb3 dib v-btm" ] [ text "people" ]
                    ]
                , span [ class "f5 white pb1" ] [ text "大人: 2, 子供: 2" ]
                ]
            , div [ class "dib w-100 h4 ba br2 b--white tc ma2" ]
                [ span [ class "h-75 db" ]
                    [ i [ class "material-icons md-72 white mt3 mb3 dib v-btm" ] [ text "person" ]
                    , i [ class "material-icons md-40 white mt3 mb4 dib v-btm" ] [ text "..." ]
                    ]
                , span [ class "f5 white pb1" ] [ text "大人: " ]
                , input
                    [ class "f6 f5-l input-reset bn w2 pa1 br2"
                    , onInput SetNumOfAdult
                    , value (toString model.numOfPeople.adult)
                    ]
                    []
                , span [ class "f5 white pb1" ] [ text " , 子供: " ]
                , input
                    [ class "f6 f5-l input-reset bn w2 pa1 br2"
                    , onInput SetNumOfChild
                    , value (toString model.numOfPeople.child)
                    ]
                    []
                ]
            ]
        ]


numOfPeopleButtonClass =
    "dib w4 h4 ba br2 b--white tc ma2 hover-bg-white-20 pointer"
