
module View exposing (..)

import Html exposing (Html, h3, text,div)
import Types.ProductTypes exposing (..)
import RemoteData exposing (WebData)
import Views.Product.List
import Views.Product.Edit
import Views.Product.New
import Views.User.Signup
import Views.User.Dashboard
import Views.User.Login
import Misc exposing (..)
import Html exposing (Html, div, h1, form, text, input, button, Attribute, label)
import Html.Attributes exposing (id, type_, name,style,class,for)
import Bootstrap.CDN as CDN
import Components.Navbar as Navbar
import Toasty
import Toasty.Defaults

selectPageView : Model -> Html Msg
selectPageView model =
    case model.currentRoute of
        ProductsRoute ->
            if model.user.loggedIn == False then
                Views.User.Login.view model.user
            else
                Views.Product.List.view model

        ProductRoute id ->
            if model.user.loggedIn == False then
                Views.User.Login.view model.user
            else
                case findProductById id model.products of
                    Just product ->
                        Debug.log "found prod"
                        Views.Product.Edit.view product model.errors

                    Nothing ->
                        -- { model | noView = model.noView + 1 }
                        
                        -- Debug.log "in nothing case"
                        -- Debug.log (toString <| model.noView)
                        -- UpdateNoViewCount
                        div [ ] []
                        -- notFoundView

        NotFoundRoute ->
            notFoundView

        NewProductRoute ->
            if model.user.loggedIn == False then
                Views.User.Login.view model.user
            else
                Views.Product.New.view model       
        
        UserSignupRoute ->
            if model.user.loggedIn == False then
                Views.User.Signup.view model.user
            else
                Views.User.Dashboard.view model
            
        UserDashboardRoute ->
            if model.user.loggedIn == False then
                Views.User.Login.view model.user
            else
                Views.User.Dashboard.view model           

        UserLoginRoute ->
            if model.user.loggedIn == False then
                Views.User.Login.view model.user
            else
                Views.User.Dashboard.view model

view : Model -> Html Msg
view model =
    div [ class  "main-container"]
        [ CDN.stylesheet
        , Html.map NavbarMsg <|
            Navbar.view model.navbarModel
        , selectPageView model
        , Toasty.view toastyConfig Toasty.Defaults.view ToastyMsg model.toasties
        ]

 
notFoundView : Html msg
notFoundView =
    h3 [] [ text "Oops! The page you requested was not found!" ]