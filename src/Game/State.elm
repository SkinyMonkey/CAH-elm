module Game.State exposing (..)

import Random.List exposing (shuffle)

import App.Types exposing (..)
import App.Subscriptions exposing (sendMessage)

import Encode.Types exposing (..)
import Encode.State exposing (..)

import Decode.Types exposing (..)
import Decode.State exposing (..)

import Game.Types exposing (..)
import Cards.State exposing (..)
import Token.State exposing (..)

deck =
    "Cards against humanity"

playedCard =
    deck

judgeCards =
    [ "Bullshit.", "Yeah", "Copain", "Test" ]

newGame blackCard =
    { whiteCards = Cards.State.whiteCards
    , blackCards = Cards.State.blackCards
    , selectedJudgeIndex = -1
    , selectedHandIndex = -1
    , selectedJudgeCard = ""
    , selectedHandCard = ""
    , judgeCards = judgeCards -- []
    , handCards = []
    , blackCard = blackCard
    , gameStep = Judgement -- Setup
    , playerIndex = 0
    , playerStatus = Judge
    , playerPlayed = False
    , playerPoints = 0
    }

update msg model =
    case msg of
--        WhiteCardsShuffled whiteCards -> ( { model | whiteCards = whiteCards }, Random.generate BlackCardsShuffled shuffle model.blackCards)
--        BlackCardsShuffled blackCards -> ( { model | blackCard = blackCards }, Cmd.none )
 -- Random.generate WhiteCardsShuffled shuffle model.whiteCards)

        ClickHandWhiteCard index card ->
            let
                currentGame =
                    model.currentGame

                updatedGame =
                    { currentGame | selectedHandIndex = index, selectedHandCard = card, playerPlayed = True }

                message = 
                    encodeMessage (SendWhiteHandCard card) -- TODO : Send tokens along
            in
                ( { model | currentGame = updatedGame }, sendMessage message )

        ClickJudgeWhiteCard index card ->
            let
                currentGame =
                    model.currentGame

                updatedGame =
                    { currentGame | selectedJudgeIndex = index, selectedJudgeCard = card }

                message = 
                    encodeMessage (SendWhiteJudgeCard card) -- TODO : Send tokens along
            in
                ( { model | currentGame = updatedGame }, sendMessage message )

        NewTurn blackCard ->
            let
                game =
                    newGame blackCard

                message =
                    encodeMessage (SendBlackCard blackCard)
            in
                ( { model | currentGame = game }, sendMessage message )

        -- TODO : separate function, cleaner
        --        extract gameToken, don't act if gameToken different than current gametoken

        _ -> (model, Cmd.none)
       
