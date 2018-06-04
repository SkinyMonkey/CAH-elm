module App.Subscriptions exposing (sendMessage, sendGameMessage, subscriptions)

import WebSocket

import App.Types exposing (..)

wsurl =
    "ws://localhost:3000"

sendMessage message = WebSocket.send wsurl message

-- FIXME : wrap the message into a javascript object with tokens?
sendGameMessage (gameToken, _) message =
  WebSocket.send (wsurl ++ "/" ++ gameToken) message

subscriptions : Model -> Sub Msg
subscriptions model =
    WebSocket.listen wsurl NewMessage
