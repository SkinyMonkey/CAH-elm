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

updateGame : Msg -> Model -> ( Model, Cmd Msg )
updateGame msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

--        WhiteCardsShuffled whiteCards -> ( { model | whiteCards = whiteCards }, Random.generate BlackCardsShuffled shuffle model.blackCards)
--        BlackCardsShuffled blackCards -> ( { model | blackCard = blackCards }, Cmd.none )

-- TODO : not the best place to put it?
        GenerateToken token -> ( {model | localToken = token, gameToken = token}, Cmd.none) -- Random.generate WhiteCardsShuffled shuffle model.whiteCards)
--
--        GameToken token -> ({model | gameToken = token}, Cmd.none)
--
--        SubmitTokens tokens -> -- TODO : avoid repetition, do the same for clicks?
--            let 
--                message = encodeMessage (SendTokens tokens)
--            in
--                (model,  sendMessage message)

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
        NewMessage message ->
            let
                result =
                    decodeMessage message

                game =
                    model.currentGame
            in
                case result of
                    ReceiveWhiteHandCard card ->
                        let
                            updatedHandCards =
                                game.handCards ++ [ card ]

                            updatedGame =
                                { game | handCards = updatedHandCards }
                        in
                            ( { model | currentGame = updatedGame }, Cmd.none )

                    ReceiveWhiteJudgeCard card ->
                        let
                            updatedJudgeCards =
                                game.judgeCards ++ [ card ]

                            updatedGame =
                                { game | judgeCards = updatedJudgeCards }
                        in
                         -- TODO : if game.handCards.length == playersTokens.length, gameStep = Judgement
                            ( { model | currentGame = updatedGame }, Cmd.none )

                    ReceiveBlackCard card ->
                        let
                            updatedGame =
                                { game | blackCard = card }
                        in
                            ( { model | currentGame = updatedGame }, Cmd.none )

                    ReceiveJudgeChoiceCard winner ->
                        -- TODO
                        ( model, Cmd.none )

                    ReceiveJudgeChoice winner -> -- TODO : decide based on localToken instead?
                        let
                            maybeWinnerIndex =
                                String.toInt winner
                        in
                            case maybeWinnerIndex of
                                Ok winnerIndex ->
                                    let
                                        updatedPlayerPoints =
                                            if winnerIndex == game.playerIndex then
                                                game.playerPoints + 1
                                            else
                                                game.playerPoints

                                        -- selectedJudgeCard
                                        updatedGame =
                                            { game | playerPoints = updatedPlayerPoints }
                                    in
                                        ( { model | currentGame = updatedGame }, Cmd.none )

                                Err error ->
                                    ( { model | error = error }, Cmd.none )

                    ReceiveTokens tokens -> -- TODO : redo after receiving localToken too
                      let tokenList = String.split "," tokens
                          maybeGameToken = List.head tokenList
                          maybeLocalToken = List.tail tokenList
                      in
                         case maybeGameToken of
                           Just gameToken ->
                         -- TODO if not in playersTokens, players whatever
                         --      add it
                                case maybeLocalToken of
                                  Just localToken -> (model, Cmd.none)
                                  Nothing -> (model, Cmd.none)

                           Nothing -> ( model, Cmd.none)

                    WSReceiveError error ->
                        ( { model | error = error }, Cmd.none )

        Send toSend ->
            let
                message =
                    encodeMessage toSend
            in
                ( model, sendMessage message )
