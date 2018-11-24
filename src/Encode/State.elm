module Encode.State exposing (..)

import Json.Encode exposing (encode)

import Game.Types exposing (..)
import Encode.Types exposing (..)

encodeStep step =
  let
      nextStep = case step of
        Judgement -> "judgement"
        PlayTime -> "playtime" 
  in
    encode 0 (Json.Encode.object [ ( "action", Json.Encode.string "changeStep" )
                                 , ( "step", Json.Encode.string nextStep ) ])

encodeCard action card =
    encode 0 (Json.Encode.object [ ( "action", Json.Encode.string action )
                                 , ( "card", Json.Encode.string card ) ])

encodeMessage message =
    case message of
        SendChangeStep step ->
            encodeStep step

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

        WSSendError error ->
            error
