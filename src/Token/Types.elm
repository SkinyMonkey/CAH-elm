module Token.Types exposing (..)

type Token = String

type TokenMsg =
--      GenerateToken String
      GameToken String
    | LocalToken String
    | SubmitTokens (String, String)
