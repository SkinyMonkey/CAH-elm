module Decode.Types exposing (..)

import Game.Types exposing (..)

type alias WSMessageHeader =
    { action : String }

type alias NewPlayerDecoder =
    { name : String }

type alias ChangeStepDecoder =
    { step : String }

type alias RoleDecoder =
    { role : String }

type alias InitGameDecoder =
    { action : String }


type alias CardDecoder =
    { card : String }


-- FIXME : replace by token later
type alias JudgeChoiceDecoder =
    { playerIndex : Int }


type ReceiveMsg
    = ReceiveRole String
    | ReceiveChangeStep String
    | ReceiveNewPlayer String
    | ReceiveWhiteJudgeCard Card -- When you receive a white card as a judge
    | ReceiveWhiteHandCard Card -- When you receive a white card as a player
    | ReceiveBlackCard Card -- When you receive a black card
    | ReceiveJudgeChoice String -- When you receive the judge choice index
    | ReceiveJudgeChoiceCard Card -- When you receive the judege choice card
    | WSReceiveError String -- Error on message receive
