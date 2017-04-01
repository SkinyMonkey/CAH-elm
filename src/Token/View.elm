module Token.View exposing (viewTokenSetup)

import Html exposing (Html, div, text, program, a, button, input, h3, b, body, br)
import Html.Attributes exposing (placeholder, type_, class, style)
import Html.Events exposing (onClick, onInput)

import Token.Types exposing (..)

viewGameTokenInput model = 
        [
         div [] [input [ placeholder "Game token", onInput GameToken] []
                ,button [  onClick (SubmitTokens (model.gameToken, model.localToken)) ] [ text "Send" ]
                ]
        ]


viewTokens model =
        [
         div [] [text model.localToken
                ,br [] []
                ,text model.gameToken]
        ]

viewTokenSetup model =
        [
         div [] ((viewTokens model) ++ (viewGameTokenInput model))
        ]
