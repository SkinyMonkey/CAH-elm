module Encode.State exposing (..)

import Json.Encode exposing (encode)

import Encode.Types exposing (..)

-- TODO : move to Token.Encode module?
encodeTokens (gameToken, localToken) = 
    encode 0 (Json.Encode.object [ ( "action", Json.Encode.string "tokens" )
                                 , ( "game_token", Json.Encode.string gameToken )
                                 , ( "local_token", Json.Encode.string localToken) ])

encodeCard action (gameToken, localToken) card =
    encode 0 (Json.Encode.object [ ( "action", Json.Encode.string action )
                                 , ( "card", Json.Encode.string card )
                                 , ( "game_token", Json.Encode.string gameToken )
                                 , ( "local_token", Json.Encode.string localToken ) ])

-- TODO : add gameToken and localToken to each message
encodeMessage message =
    case message of
        SendWhiteHandCard tokens card ->
            encodeCard "whiteHandCard" tokens card

        SendWhiteJudgeCard tokens card ->
            encodeCard "whiteJudgeCard" tokens card

        SendBlackCard tokens card ->
            encodeCard "blackCard" tokens card

        SendJudgeChoice tokens card ->
            encodeCard "judgeChoice" tokens card

        SendJudgeChoiceCard tokens card ->
            encodeCard "judgeChoiceCard" tokens card

        SendTokenPairs tokens ->
            encodeTokens tokens

        WSSendError error ->
            error
