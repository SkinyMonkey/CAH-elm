module Token.Types exposing (..)

type Token = String

type TokenMsg =
      GameToken String
    | LocalToken String
    | SubmitTokens (String, String)
