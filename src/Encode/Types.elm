module Encode.Types exposing (..)

import Game.Types exposing (..)
import Token.Types exposing (..)

type SendMsg
    = SendWhiteHandCard (String, String) Card
    | SendWhiteJudgeCard (String, String) Card
    | SendBlackCard (String, String) Card
    | SendJudgeChoice (String, String) Card
    | SendJudgeChoiceCard (String, String) Card
    | SendTokenPairs (String, String)
    | WSSendError String
