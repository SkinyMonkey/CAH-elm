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

deck =
    "Cards against humanity"

playedCard =
    deck

-- FIXME : debug, remove
handCards = 
    [ "Bullshit.", "Yeah", "Copain", "Test" ]

newGame blackCard =
    { whiteCards = Cards.State.whiteCards
    , blackCards = Cards.State.blackCards
    , selectedHandIndex = -1
    , selectedJudgeIndex = -1
    , selectedHandCard = ""
    , selectedJudgeCard = ""
    , judgeCards = [] -- []
    , handCards = handCards -- []
    , blackCard = blackCard
    , gameStep = PlayTime -- Setup
    , playerIndex = 0
    , playerStatus = Player
    , playerPlayed = False
    , playerPoints = 0
    , players = []
    }

update msg model =
    case msg of
--        WhiteCardsShuffled whiteCards -> ( { model | whiteCards = whiteCards }, Random.generate BlackCardsShuffled shuffle model.blackCards)
--        BlackCardsShuffled blackCards -> ( { model | blackCard = blackCards }, Cmd.none )
 -- Random.generate WhiteCardsShuffled shuffle model.whiteCards)

        -- as a player i click on a card in my hand
        ClickHandWhiteCard index card ->
            let
                currentGame =
                    model.currentGame

                updatedGame =
                    { currentGame | selectedHandIndex = index, selectedHandCard = card, playerPlayed = True }

                message = 
                    encodeMessage (SendWhiteHandCard card)
            in
                ( { model | currentGame = updatedGame }, sendMessage message )

        -- as a judge i select one of the white cards
        ClickJudgeWhiteCard index card ->
            let
                currentGame =
                    model.currentGame

                updatedGame =
                    { currentGame | selectedJudgeIndex = index, selectedJudgeCard = card }

                message = 
                    encodeMessage (SendWhiteJudgeCard card)
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

        _ -> (model, Cmd.none)
