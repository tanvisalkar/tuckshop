module Views.Product.List exposing (view)

import Types.ProductTypes exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Http
import RemoteData
import Bootstrap.Button as Button
import Bootstrap.Table as Table

view : Model -> Html Msg
view model =
    div [ class "container" ]
        [   div [ class "row" , style [("padding-top","50px")] ]
            [ div [ class "col-md-6 col-md-offset-3" , style [("max-width", "450px"), ("padding", "15px 35px 45px"),("margin", "0 auto"),("background", "#eee") ] ]
                [ Button.button [ Button.primary,Button.attrs[ onClick GetProducts] ]
                    [ text "Refresh products" ]
                , br [] []
                , br [] []
                , a [ href "/products/new" ]
                    [ text "Create new product" ]
                , br [] []
                , br [] []
                , viewProductsOrError model
                ]
            ]
        ]


viewProductsOrError : Model -> Html Msg
viewProductsOrError model =
    case model.products of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            h3 [] [ text "Loading..." ]

        RemoteData.Success products ->
            viewProducts products

        RemoteData.Failure httpError ->
            viewError (createErrorMessage httpError)

viewError : String -> Html Msg
viewError errorMessage =
    let
        errorHeading =
            "Couldn't fetch data at this time."
    in
        div []
            [ h3 [] [ text errorHeading ]
            , text ("Error: " ++ errorMessage)
            ]

viewTableHeader: Table.THead Msg
viewTableHeader =
    Table.simpleThead
        [ Table.th [] [text "ID"]
        , Table.th [] [text "Name"]
        , Table.th [] [text "Price"]
        ]

viewProduct: Product -> Table.Row Msg
viewProduct product =
    let
        productPath = "/products/" ++ ( toString product.id)
    in
        Table.tr []
            [ Table.td [] [text (toString product.id)]
            , Table.td [] [text product.title]
            , Table.td [] [text (toString  product.price)]
            , Table.td [] [ a [ href productPath ] [ text "Edit" ] ]
            , Table.td [] [ Button.button [ Button.danger,Button.attrs[ onClick (DeleteProduct product.id)] ] [ text "Delete" ] ]
            ]

viewProducts: List Product -> Html Msg
viewProducts products =
    div []
        [ h3 [] [text "Products"]
        , Table.table
            { options = [ Table.striped, Table.hover, Table.bordered ]
            , thead =  viewTableHeader
            , tbody =
                Table.tbody []
                    (List.map viewProduct products)
            }
            -- ([viewTableHeader] ++ List.map viewProduct products)
        ]
        
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

            
