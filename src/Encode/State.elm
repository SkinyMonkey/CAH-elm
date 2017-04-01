module Encode.State exposing (..)

import Json.Encode exposing (encode)

import Encode.Types exposing (..)

-- TODO : move to Token.Encode module?
encodeTokens (gameToken, localToken) = 
    encode 0 (Json.Encode.object [ ( "action", Json.Encode.string "tokens" )
                                 , ( "game_token", Json.Encode.string gameToken )
                                 , ( "local_token", Json.Encode.string localToken) ])

encodeCard action card =
    encode 0 (Json.Encode.object [ ( "action", Json.Encode.string action ), ( "card", Json.Encode.string card ) ])

-- TODO : add gameToken to every Sends
encodeMessage message =
    case message of
        SendWhiteHandCard card ->
            encodeCard "whiteHandCard" card

        SendWhiteJudgeCard card ->
            encodeCard "whiteJudgeCard" card

        SendBlackCard card ->
            encodeCard "blackCard" card

        SendJudgeChoice card ->
            encodeCard "judgeChoice" card

        SendJudgeChoiceCard card ->
            encodeCard "judgeChoiceCard" card

        SendTokens tokens ->
            encodeTokens tokens

        WSSendError error ->
            error
