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
    , judgeCards : List Card -- cards sent to the judge
    , handCards : List Card -- cards in the player hand
    , blackCard : Card

    -- TODO : move to another place?
    , gameStep : GameStep
    , playerIndex : Int
    , playerStatus : PlayerStatus
    , playerPlayed : Bool
    , playerPoints : Int

    , players : List String
    }

type GameMsg = String
    -- NewTurn Card
