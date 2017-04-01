module Decode.Types exposing (..)

import Game.Types exposing (..)

type alias WSMessageHeader =
    { action : String }


type alias InitGameDecoder =
    { action : String }


type alias CardDecoder =
    { card : String }


type alias JudgeChoiceDecoder =
    { playerIndex : Int }


type alias TokensDecoder =
    { gameToken : String, localToken : String }

type ReceiveMsg
    = ReceiveWhiteJudgeCard Card -- When you receive a white card as a judge
    | ReceiveWhiteHandCard Card -- When you receive a white card as a player
    | ReceiveBlackCard Card -- When you receive a black card
    | ReceiveJudgeChoice String -- When you receive the judge choice index
    | ReceiveJudgeChoiceCard Card -- When you receive the judege choice card
    | ReceiveTokens String -- When someone sends a token
    | WSReceiveError String -- Error on message receive
