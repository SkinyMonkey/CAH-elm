module App.State exposing (init, update)


import App.Types exposing (..)
import App.Subscriptions exposing (..)
import Game.State exposing (update, newGame)

import Decode.State exposing (update)
import Encode.State exposing (..)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
      NoOp -> ( model, Cmd.none )

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
    ( { currentGame = newGame "Test", error = "" }, Cmd.none )
