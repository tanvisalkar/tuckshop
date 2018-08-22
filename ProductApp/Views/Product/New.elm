module Views.Product.New exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Types.ProductTypes exposing (..)
import Misc exposing (..)
import Bootstrap.Button as Button
import Bootstrap.Form as Form
import Bootstrap.Form.Input as Input

view : Model -> Html Msg
view model =
    div [ class "container" ]
        [   div [ class "row" , style [("padding-top","50px")] ]
            [ div [ class "col-md-6 col-md-offset-3" , style [("max-width", "450px"), ("padding", "15px 35px 45px"),("margin", "0 auto"),("background", "#eee") ] ]
                [ a [ href "/products" ] [ text "Products List" ]
                , br [] []
                , br [] []
                , h3 [] [ text "Create New Product" ]
                , newProductForm model
                ]
            ]
        ]


newProductForm : Model -> Html Msg
newProductForm model=
    Form.form [ onSubmit CreateNewProduct ]
        [ Form.group []
            [ Form.label
                [ for "Title" ]
                [ text "Title" ]
            , Input.text
                [ Input.attrs
                    [ value model.newProduct.title
                    , onInput NewProductTitle
                    ]
                ]
            , viewFormErrors Title model.errors
            ]
        -- , br [] []
        , Form.group []
            [ Form.label
                [ for "Price" ]
                [ text "Price" ]
            , Input.number
                [ Input.attrs
                    [ value (toString model.newProduct.price)
                    , Html.Attributes.min "0"
                    , onInput NewProductPrice
                    ]
                ]
                
            , viewFormErrors Price model.errors
            ]
        -- , br [] []
        , div []
            [ Button.button [ Button.primary,Button.attrs[type_ "submit"] ] [ text "Submit" ]
                -- button [ type_ "submit" ]
                -- [ text "Submit" ]
            ]
        ]