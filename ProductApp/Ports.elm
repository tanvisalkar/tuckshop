port module Ports exposing (..)

import Types.UserTypes exposing (..)

port storeUserDetails : UserStorage -> Cmd msg

port removeUserDetails : UserStorage -> Cmd msg

port callUserLogout : Bool -> Cmd msg

port receiveLogoutData : (Bool -> msg) -> Sub msg