module App.View exposing (..)

import Html exposing (Html, div, text, program, a, button, input, h3, b, body, br)
import Html.Attributes exposing (placeholder, type_, class, style)
import Html.Events exposing (onClick, onInput)

import App.Style exposing (..)
import App.Types exposing (..)
import Game.View exposing (..)
import Game.Types exposing (..)

viewError model =
    let
        error =
            model.error
    in
        [ div [ errorStyle ]
            [ text
                (if error == "" then
                    ""
                 else
                    "Error: " ++ error
                )
            ]
        ]


viewPoints pointNumber =
    div [ pointsStyle ]
        [ text "Points number: "
        , text (toString pointNumber)
        ]


viewTurn turnNumber =
    div [ pointsStyle ]
        [ text "Turn number: ", text (toString turnNumber) ]

viewStep model =
    let
        game =
            model.currentGame
    in
        case game.gameStep of
          -- TODO : add Setup?
--            Setup -> viewTokenSetup model

            Judgement ->
                case game.playerStatus of
                    Judge ->
                        viewJudgeCards model

                    Player ->
                        viewWaitCards model

            PlayTime ->
                case game.playerStatus of
                    Judge ->
                        viewWaitCards model

                    Player ->
                        case game.playerPlayed of
                            False ->
                                viewHandCards model

                            True ->
                                viewWaitCards model

view : Model -> Html Msg
view model =
    body [ pageStyle ] ([ div [] ((viewStep model) ++ (viewError model)) ])



