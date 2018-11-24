module Encode.Types exposing (..)

import Game.Types exposing (..)

type SendMsg
    = SendChangeStep GameStep
    | SendWhiteHandCard Card
    | SendWhiteJudgeCard Card
    | SendBlackCard Card
    | SendJudgeChoice Card
    | SendJudgeChoiceCard Card
    | WSSendError String
