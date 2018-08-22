module Subscriptions exposing (..)
import Types.ProductTypes exposing (..)
import Components.Navbar as Navbar
import Ports exposing (..)

subscriptions : Model -> Sub Msg
subscriptions model =
    let
        navSubscription =
            Sub.map NavbarMsg <| Navbar.subscriptions model.navbarModel

    in
        Sub.batch
            [ navSubscription
            , receiveLogoutData LogOut
            ]
