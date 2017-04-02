module App.State exposing (init, update)


import App.Types exposing (..)
import App.Subscriptions exposing (..)
import Token.State exposing (generateToken)
import Game.State exposing (update, newGame)

import Decode.State exposing (update)
import Encode.State exposing (..)

-- import Token exposing (..)
-- import Messages exposing (..)
-- import Game exposing (..)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
      NoOp -> ( model, Cmd.none )

      GenerateToken token -> ( {model | localToken = token, gameToken = token}, Cmd.none)

      Token tokenmsg -> Token.State.update tokenmsg model
 
      -- Game gameMsg -> Game.State.update gameMsg model

      NewMessage message -> Decode.State.update message model

      Send toSend ->
          let
              message =
                  Encode.State.encodeMessage toSend
          in
              ( model, App.Subscriptions.sendMessage message )

      _ -> Game.State.update msg model

init : ( Model, Cmd Msg )
init =
    ( { currentGame = newGame "Test", error = "", gameToken = "", localToken = "" }, generateToken )
