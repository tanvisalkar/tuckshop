port module App exposing (main)

import Html exposing (program)

import View exposing (view)
import Types.ProductTypes exposing (..)
import Types.UserTypes exposing (..)
import States.ProductState exposing (init, update)
import Navigation
import Ports exposing (..)
import Components.Navbar as Navbar
import Subscriptions exposing (..)

main : Program (Maybe UserStorage) Model Msg
main =
    Navigation.programWithFlags LocationChanged
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }