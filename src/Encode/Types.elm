module Encode.Types exposing (..)

import Game.Types exposing (..)

type SendMsg
    = SendWhiteHandCard Card -- TODO Send localToken too
    | SendWhiteJudgeCard Card -- idem
    | SendBlackCard Card
    | SendJudgeChoice Card
    | SendJudgeChoiceCard Card
    | SendTokens (String, String)
    | WSSendError String
