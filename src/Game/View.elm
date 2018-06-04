module Game.View exposing (..)

import Html exposing (Html, div, text, program, a, button, input, h3, b, body, br)
import Html.Attributes exposing (placeholder, type_, class, style)
import Html.Events exposing (onClick, onInput)

import App.Style exposing (..)
import App.State exposing (..)
import App.Types exposing (..)

import Game.State exposing (deck, playedCard)
import Game.Types exposing (..)

viewCard index styleToApply marginTop card event =
    div [ style (styleToApply index marginTop), onClick event ]
        [ div [ class "container" ]
            [ h3 [] [ b [] [ text card ] ] ]
        ]


viewWhiteCard index selected card marginTop event =
    viewCard index (cardStyle selected) marginTop card event



-- viewWhiteCard_ index selected card event = viewWhiteCard index selected card "320px" event


viewWaitWhiteCard index card =
    viewWhiteCard index notSelected card "320px" NoOp


viewHandWhiteCard selectedIndex index card =
    viewWhiteCard index (selectedIndex == index) card "320px" (ClickHandWhiteCard index card)


viewJudgeWhiteCard selectedIndex index card =
    viewWhiteCard index (selectedIndex == index) card "320px" (ClickJudgeWhiteCard index card)


viewBlackCard card =
    viewCard 1 blackCardStyle "20px" card NoOp



-- viewBlackCard_ card = viewBlackCard card "20px"



viewDeck =
    viewCard 0 blackCardStyle "20px" deck NoOp

viewWaitCards model =
    let
        currentGame =
            model.currentGame

        blackCard =
            currentGame.blackCard
    in
        ([ viewDeck ] ++ [ viewBlackCard blackCard ] ++ (List.indexedMap viewWaitWhiteCard [ playedCard ]))

-- TODO : playedCard * playerNumber


viewHandCards model =
    let
        currentGame =
            model.currentGame

        blackCard =
            currentGame.blackCard

        selectedHandIndex =
            currentGame.selectedHandIndex

        judgeCards =
            currentGame.judgeCards
    in
        ([ viewDeck ] ++ [ viewBlackCard blackCard ] ++ (List.indexedMap (viewHandWhiteCard selectedHandIndex) judgeCards))


viewJudgeCards model =
    let
        currentGame =
            model.currentGame

        blackCard =
            currentGame.blackCard

        selectedJudgeIndex =
            currentGame.selectedJudgeIndex

        judgeCards =
            currentGame.judgeCards
    in
        ([ viewDeck ] ++ [ viewBlackCard blackCard ] ++ (List.indexedMap (viewJudgeWhiteCard selectedJudgeIndex) judgeCards))
