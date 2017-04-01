module App.State exposing (init, update)

import App.Types exposing (..)
import Token.State exposing (generateToken)
import Game.State exposing (updateGame, newGame)

-- import Token exposing (..)
-- import Messages exposing (..)
-- import Game exposing (..)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    updateGame msg model

init : ( Model, Cmd Msg )
init =
    ( { currentGame = newGame "Test", error = "", gameToken = "", localToken = "" }, generateToken )
