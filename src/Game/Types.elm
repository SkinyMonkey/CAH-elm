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

-- TODO : replace by a dict?
-- nop, would mean a maybe on each lookup, no way
type alias Game =
    { whiteCards : Deck
    , blackCards : Deck
    , selectedHandIndex : Int
    , selectedJudgeIndex : Int
    , selectedHandCard : Card
    , selectedJudgeCard : Card
    -- TODO List (String, Card) -- (localToken, Card)
    -- , judgeCards : List (String, Card)
    , judgeCards : List Card
    , handCards : List Card
    , blackCard : Card

    , tokenPair : (String, String)

    -- TODO : move to another place?
    , gameStep : GameStep
    , playerIndex : Int
--  , playersTokens : List String
    , playerStatus : PlayerStatus
    , playerPlayed : Bool
    , playerPoints : Int
    }

type GameMsg = String
    -- NewTurn Card
