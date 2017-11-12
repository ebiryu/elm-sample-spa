module Search.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model exposing (Model, Route(..))
import Msg exposing (Msg(..))


view : Model -> Html Msg
view model =
    div [ class "bg-blue w-100 h-100 absolute top-0 left-0 fixed" ]
        [ i [ class "material-icons md-48 ml3 ml5-ns mt5 white pointer", onClick ToggleSearch ] [ text "clear" ]
        , div [ class "mh-3 mh5-ns w-75" ]
            [ searchFormView model
            , howManyPeopleView model
            ]
        ]


searchFormView : Model -> Html Msg
searchFormView model =
    div [ class "w-100 inline-block" ]
        [ div [ class "f3 pv2 white" ] [ text "検索" ]
        , input
            [ id "search-place"
            , type_ "search"
            , class "f6 f5-l input-reset bn pa3 br2 w-100 w-75-m w-80-l"
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
        [ class "b--white bb bw1 br2 ma1 ph2 pv3 white f3 hover-bg-white-20 pointer"
        , onClick (SelectCityId id)
        ]
        [ text string ]


howManyPeopleView : Model -> Html Msg
howManyPeopleView model =
    div [] []
