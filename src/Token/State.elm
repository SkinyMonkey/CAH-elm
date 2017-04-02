module Token.State exposing (..)

import Char   exposing (fromCode)
import String exposing (fromList)
import Random exposing (Generator)

import App.Types exposing (..)
import Token.Types exposing (..)

-- Random token generation

char : Int -> Int -> Generator Char
char start end =
    Random.map fromCode (Random.int start end)

lowerCaseLatin : Generator Char
lowerCaseLatin =
    char 97 122

englishWord : Int -> Generator String
englishWord wordLength =
    Random.map fromList (Random.list wordLength lowerCaseLatin)

generateToken = Random.generate GenerateToken (englishWord 31)

update msg model = (model, Cmd.none )
--        case msg of
--        GameToken token -> ({model | gameToken = token}, Cmd.none)
--
--        SubmitTokens tokens -> -- TODO : avoid repetition, do the same for clicks?
--            let 
--                message = encodeMessage (SendTokens tokens)
--            in
--                (model,  sendMessage message)
