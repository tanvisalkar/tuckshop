module Apis.UserApi exposing (..)
import Types.ProductTypes exposing (..)
import Types.UserTypes exposing (..)
import Http
import Json.Decode as Decode exposing (..)
import Json.Encode as Encode exposing (..)
import Json.Decode.Pipeline exposing (decode, required)
-- import Platform exposing (Task)
import Task exposing (..)

authUserCmd : User -> String -> Cmd Msg    
authUserCmd user apiUrl = 
    --Task.perform AuthError GetTokenSuccess <| authUser user apiUrl
    authUser user apiUrl
        |> Http.send GetTokenSuccess

loginUserCmd : User -> String -> Cmd Msg    
loginUserCmd user apiUrl = 
    --Task.perform AuthError GetTokenSuccess <| authUser user apiUrl
    loginUser user apiUrl
        |> Http.send GetTokenSuccess

-- POST register request
authUser : User -> String -> Http.Request String
authUser user apiUrl =
    Http.request
        { method = "POST"
        , headers = []
        , url = apiUrl
        , body = Http.jsonBody (userEncoder user)
        , expect = Http.expectJson tokenDecoder
        , timeout = Nothing
        , withCredentials = False
        }
        
-- GET login request
loginUser : User -> String -> Http.Request String
loginUser user apiUrl =
    Http.request
        { method = "GET"
        , headers = []
        , url = apiUrl++"?email="++user.email++"&password="++user.password
        , body = Http.jsonBody (userLoginEncoder user)
        , expect = Http.expectJson tokenDecoder
        , timeout = Nothing
        , withCredentials = False
        }

-- Encode user to construct POST request body (for Register and Log In)
userEncoder : User -> Encode.Value
userEncoder user = 
    Encode.object 
        [ ("name", Encode.string user.name)
        , ("email", Encode.string user.email) 
        , ("password", Encode.string user.password) 
        ]

userLoginEncoder : User -> Encode.Value
userLoginEncoder user = 
    Encode.object 
        [ ("email", Encode.string user.email) 
        , ("password", Encode.string user.password) 
        ]

-- Decode POST response to get token
tokenDecoder : Decoder String
tokenDecoder =
    Decode.at ["data", "token"] Decode.string