module App.Types exposing (..)

import Game.Types exposing (..)
import Token.Types exposing (..)
import Decode.Types exposing (..)
import Encode.Types exposing (..)

import Cards.Types exposing (..)

type alias Model =
    { currentGame : Game
    , -- playerNames : List String -- comes from websockets
      error : String
    , localToken : String -- Token
    , gameToken : String -- Token
    }

type Msg
    = NoOp
    | NewMessage String
    | Game GameMsg
    | Send SendMsg
    | Token TokenMsg
    | GenerateToken String 
    | ClickHandWhiteCard Int Card -- TODO : move
    | ClickJudgeWhiteCard Int Card
    | NewTurn Card
--    | Card Cards.Types.CardsMsg
