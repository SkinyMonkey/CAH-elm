module Decode.State exposing (..)

import Json.Decode exposing (int, string, float, nullable, Decoder, field)
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)

import Decode.Types exposing (..)

headerDecoder : Decoder WSMessageHeader
headerDecoder =
    decode WSMessageHeader
        |> required "action" string


cardDecoder : Decoder CardDecoder
cardDecoder =
    decode CardDecoder
        |> required "card" string


winnerIsDecoder : Decoder JudgeChoiceDecoder
winnerIsDecoder =
    decode JudgeChoiceDecoder
        |> required "playerIndex" int

tokensDecoder : Decoder TokensDecoder
tokensDecoder =
    decode TokensDecoder
        |> required "gameToken" string
        |> required "localToken" string


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


decodeJudgeChoice message = -- TODO : decode localToken instead
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

                    "tokens" ->
                        ReceiveTokens (decodeTokens message)

                    _ ->
                        WSReceiveError ("Unknown action received " ++ action)

            Err _ ->
                WSReceiveError "Error while decoding json"

-- TODO : move to Token.?
decodeTokens message =
    let
        result =
            Json.Decode.decodeString tokensDecoder message
    in
        case result of
            Ok { gameToken, localToken } -> gameToken ++ "," ++ localToken

            Err _ ->
                "Error while decoding tokens"

update msg model =
  let
      result =
          decodeMessage msg

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
