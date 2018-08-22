module Misc exposing (..)

import Types.ProductTypes exposing (..)
import RemoteData exposing (WebData)
import Html exposing (..)
import Html.Attributes exposing (..)
import Bootstrap.Navbar as Navbar
import Html.Events exposing (..)
import Toasty
import Toasty.Defaults
import Http

findProductById : ProductId -> WebData (List Product) -> Maybe Product
findProductById productId products =
    case RemoteData.toMaybe products of
        Just products ->
            products
                |> List.filter (\product -> product.id == productId)
                |> List.head

        Nothing ->
            Debug.log (toString <| productId)
            Nothing


viewFormErrorsList : FormField -> List Error -> Html msg
viewFormErrorsList field errors =
    errors
        |> List.filter (\( fieldError, _ ) -> fieldError == field)
        |> List.map (\( _, error ) -> li [] [ text error ])
        |> ul [ class "formErrors" ]


viewFormErrors : FormField -> List Error -> Html msg
viewFormErrors field errors =
    errors
        |> List.filter (\( fieldError, _ ) -> fieldError == field)
        |> List.map (\( _, error ) -> div [ class "error", style [ ( "color", "red" ) ] ] [ text error ])
        |> div []

-- viewNavbarLogout : Navbar.Item Msg
-- viewNavbarLogout =
--     Navbar.itemLink [ onClick LogOut ] [ text "Logout" ]

toastyConfig : Toasty.Config Msg
toastyConfig =
    Toasty.Defaults.config
        |> Toasty.delay 5000


-- add Toast messages
addToast : Toasty.Defaults.Toast -> ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
addToast toast ( model, cmd ) =
    Toasty.addToast toastyConfig ToastyMsg toast ( model, cmd )

-- handle http error
createErrorMessage : Http.Error -> String
createErrorMessage httpError =
    case httpError of
        Http.BadUrl message ->
            message

        Http.Timeout ->
            "Server is taking too long to respond. Please try again later."

        Http.NetworkError ->
            "It appears you don't have an Internet connection right now."

        Http.BadStatus response ->
            response.status.message

        Http.BadPayload message response ->
            message
