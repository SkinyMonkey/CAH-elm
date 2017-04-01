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
