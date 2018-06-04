module Token.Types exposing (..)

-- FIXME : why cant i use this?
--type Token = String
--type alias TokenPair = (Token, Token)

type TokenMsg =
--      GenerateToken String
      GameToken String -- current game host token
    | LocalToken String -- local host token
    | SubmitTokens (String, String)
