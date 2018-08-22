module Routing exposing (..)

import Navigation exposing (Location)
import UrlParser exposing (..)
import Types.ProductTypes exposing (..)


extractRoute : Location -> Route
extractRoute location =
    case (parsePath matchRoute location) of
        Just route ->
            Debug.log "Route"
            route

        Nothing ->
            NotFoundRoute


matchRoute : Parser (Route -> a) a
matchRoute =
    oneOf
        [ map UserLoginRoute top
        , map ProductsRoute (s "products")
        , map ProductRoute (s "products" </> int)
        , map NewProductRoute (s "products" </> s "new")
        , map UserSignupRoute (s "signup")
        , map UserDashboardRoute (s "dashboard")
        , map UserLoginRoute (s "login")
        ]