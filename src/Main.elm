module App exposing (main)

import Html exposing (program)

import App.Types exposing (..)
import App.State exposing (init, update)
import App.View exposing (..)
import App.Subscriptions exposing (..)

--import Tmp exposing (..)
--import Model exposing (..)
--import View exposing (..)
--import Messages exposing (..)

main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
