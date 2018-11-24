module Decode.State exposing (..)

import Json.Decode exposing (int, string, float, nullable, Decoder, field)
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)

import App.Types exposing (..)
import Decode.Types exposing (..)

import Encode.Types exposing (..)
import Encode.State exposing (..)
import App.Subscriptions exposing (..)

import Game.Types exposing (..)
import Debug

headerDecoder : Decoder WSMessageHeader
headerDecoder =
    decode WSMessageHeader
        |> required "action" string

changeStepDecoder : Decoder ChangeStepDecoder
changeStepDecoder =
    decode ChangeStepDecoder
        |> required "step" string

roleDecoder : Decoder RoleDecoder
roleDecoder =
    decode RoleDecoder
        |> required "role" string

newPlayerDecoder : Decoder NewPlayerDecoder
newPlayerDecoder =
    decode NewPlayerDecoder
        |> required "name" string

cardDecoder : Decoder CardDecoder
cardDecoder =
    decode CardDecoder
        |> required "card" string


winnerIsDecoder : Decoder JudgeChoiceDecoder
winnerIsDecoder =
    decode JudgeChoiceDecoder
        |> required "playerIndex" int


decodeChangeStep message =
    let
        result =
            Json.Decode.decodeString changeStepDecoder message
    in
        case result of
            Ok { step } ->
               step

            Err _ ->
                "Error while decoding next step"

decodeRole message =
    let
        result =
            Json.Decode.decodeString roleDecoder message
    in
        case result of
            Ok { role } ->
                role

            Err _ ->
                "Error while decoding role"

decodeCard message =
    let
        result =
            Json.Decode.decodeString cardDecoder message
    in
        case result of
            Ok { card } ->
                card

            Err _ ->
                "Error while decoding card"

decodeNewPlayer message =
    let
        result =
            Json.Decode.decodeString newPlayerDecoder message
    in
        case result of
            Ok { name } ->
                name

            Err _ ->
                "Error while decoding new player name"

decodeJudgeChoice message =
    let
        result =
            Json.Decode.decodeString winnerIsDecoder message
    in
        case result of
            Ok { playerIndex } ->
                (toString playerIndex)

            Err _ ->
                "Error while decoding winnerIs"

decodeMessage message =
    let
        result =
            Json.Decode.decodeString headerDecoder message
    in
        case result of
            Ok { action } ->
                case action of
                    -- FIXME : temporary, might be removed when p2p ok
                    "setup" ->
                        ReceiveRole (decodeRole message)

                    "changeStep" ->
                        ReceiveChangeStep (decodeChangeStep message)

                    "newPlayer" ->
                        ReceiveNewPlayer (decodeNewPlayer message)

                    "whiteJudgeCard" ->
                        ReceiveWhiteJudgeCard (decodeCard message)

                    "whiteHandCard" ->
                        ReceiveWhiteHandCard (decodeCard message)

                    "blackCard" ->
                        ReceiveBlackCard (decodeCard message)

                    "judgeChoice" ->
                        ReceiveJudgeChoice (decodeCard message)

                    "judgeChoiceCard" ->
                        ReceiveJudgeChoiceCard (decodeCard message)

                    _ ->
                        WSReceiveError ("Unknown action received " ++ action)

            Err _ ->
                WSReceiveError "Error while decoding json"



update msg model =
    let
        result =
            decodeMessage msg

        game =
            model.currentGame
    in
        case result of
            ReceiveRole role ->
                let 
                    test = Debug.log "Role: " role

                    newPlayerStatus = case role of
                      "judge" -> Judge
                      "player" -> Player
                      _ -> Player

                    updatedGame = { game | playerStatus = newPlayerStatus }
                in
                   ( { model | currentGame = updatedGame}, Cmd.none )

            ReceiveChangeStep step ->
                let
                    nextStep = case step of
                        "judgement" -> Judgement
                        "playtime"  -> PlayTime
                        _ -> PlayTime

                    updatedGame = { game | gameStep = nextStep }
                in
                   ( { model | currentGame = updatedGame}, Cmd.none )

            ReceiveNewPlayer name ->
                let
                    test = Debug.log "New player: " name

                    updatedGame = { game | players = game.players ++ [ name ] }
                 in
                    ( { model | currentGame = updatedGame}, Cmd.none )

            -- as a judge i receive a new card
            ReceiveWhiteHandCard card ->
                let
                    test = Debug.log "Card nbr" (List.length updatedJudgeCards)
                    test2 = Debug.log "Player nbr" (List.length game.players)

                    game = model.currentGame

                    updatedJudgeCards =
                        game.judgeCards ++ [ card ]

                    updatedGame =
                        { game | judgeCards = updatedJudgeCards }

                    updatedModel = { model | currentGame = updatedGame }

                in if List.length updatedJudgeCards == List.length game.players
                 -- FIXME : use another update function to avoid all the imports
                 -- and keep the game logic elsewhere
                   then ( updatedModel, sendMessage (encodeMessage (SendChangeStep Judgement)) )
                   else ( updatedModel, Cmd.none )

            -- as a player i receive a new card
            ReceiveWhiteJudgeCard card ->
                let
                    test = Debug.log "Player received card: " card

                    updatedHandCards =
                        game.handCards ++ [ card ]

                    updatedGame =
                        { game | handCards = updatedHandCards }
                in
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

            ReceiveJudgeChoice winner ->
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

            WSReceiveError error ->
                ( { model | error = error }, Cmd.none )
