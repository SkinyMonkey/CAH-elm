module Game.Types exposing (..)

type alias Card =
    String

type alias Deck =
   List Card

-- Game definition
type GameStep
    = Judgement
    | PlayTime
--    | Setup


type PlayerStatus
    = Judge
    | Player

-- TODO : replace by a dict
type alias Game =
    { whiteCards : Deck
    , blackCards : Deck
    , selectedHandIndex : Int
    , selectedJudgeIndex : Int
    , selectedHandCard : Card
    , selectedJudgeCard : Card
    , handCards : List Card
    -- TODO List (Int, Card) -- (localToken, Card)
    , judgeCards : List Card
    , blackCard : Card
    -- TODO : move to another place
    , gameStep : GameStep
    , playerIndex : Int
--  , playersTokens : List String
    , playerStatus : PlayerStatus
    , playerPlayed : Bool
    , playerPoints : Int
    }

type GameMsg = String
    -- NewTurn Card
