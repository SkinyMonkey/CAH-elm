module Game.State exposing (..)

import Random.List exposing (shuffle)

import App.Types exposing (..)
import App.Subscriptions exposing (sendGameMessage)

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
    , selectedHandIndex = -1
    , selectedJudgeIndex = -1
    , selectedHandCard = ""
    , selectedJudgeCard = ""
    , judgeCards = judgeCards -- []
    , handCards = []
    , blackCard = blackCard
    , tokenPair = ("", "") -- TODO : tokens
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
                    encodeMessage (SendWhiteHandCard currentGame.tokenPair card) -- TODO : Send tokens along
            in
                ( { model | currentGame = updatedGame }, sendGameMessage currentGame.tokenPair message )

        ClickJudgeWhiteCard index card ->
            let
                currentGame =
                    model.currentGame

                updatedGame =
                    { currentGame | selectedJudgeIndex = index, selectedJudgeCard = card }

                message = 
                    encodeMessage (SendWhiteJudgeCard currentGame.tokenPair card) -- TODO : Send tokens along
            in
                ( { model | currentGame = updatedGame }, sendGameMessage currentGame.tokenPair message )

        NewTurn blackCard ->
            let
                game =
                    newGame blackCard

                tokenPair = ("abc", "def")

                message =
                    encodeMessage (SendBlackCard tokenPair blackCard) -- FIXME : tokenPair from game, not currentGame
            in
                ( { model | currentGame = game }, sendGameMessage tokenPair message )

        -- TODO : separate function, cleaner
        --        extract gameToken, don't act if gameToken different than current gametoken
        --        -> actually no, the server should forward tokens to a room based on the gametoken

        _ -> (model, Cmd.none)
