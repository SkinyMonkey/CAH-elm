module App.Subscriptions exposing (sendMessage, subscriptions)

import WebSocket

import App.Types exposing (..)

wsurl =
    "ws://localhost:3000"

sendMessage message = WebSocket.send wsurl message

subscriptions : Model -> Sub Msg
subscriptions model =
    WebSocket.listen wsurl NewMessage
