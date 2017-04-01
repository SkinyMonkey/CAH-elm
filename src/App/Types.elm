module App.Types exposing (..)

import Game.Types exposing (..)
import Token.Types exposing (..)
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
    | ClickHandWhiteCard Int Card
    | ClickJudgeWhiteCard Int Card
    | NewTurn Card
    | NewMessage String
    | Send SendMsg
    | GenerateToken String -- TODO : TODO sub update
--    | Card Cards.Types.CardsMsg
