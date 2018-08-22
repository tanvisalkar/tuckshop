module Views.Product.Edit exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Types.ProductTypes exposing (..)
import Html.Events exposing (..)
import Misc exposing (..)
import Bootstrap.Button as Button
import Bootstrap.Form as Form
import Bootstrap.Form.Input as Input


view : Product -> List Error -> Html Msg
view product errors =
    div [ class "container" ]
        [   div [ class "row" , style [("padding-top","50px")] ]
            [ div [ class "col-md-6 col-md-offset-3" , style [("max-width", "450px"), ("padding", "15px 35px 45px"),("margin", "0 auto"),("background", "#eee") ] ]
                [ a [ href "/products" ] [ text "Back" ]
                , br [] []
                , br [] []
                , h3 [] [ text "Edit Product" ]
                , editForm product errors
                ]
            ]
        ]


editForm : Product -> List Error -> Html Msg
editForm product errors =
    Form.form [ onSubmit (SubmitUpdatedProduct product.id) ]
        [ Form.group []
            [ Form.label
                [ for "Title" ]
                [ text "Title" ]
            , Input.text
                [ Input.attrs
                    [ value product.title
                    , onInput (UpdateTitle product.id)
                    ]
                ]
            , viewFormErrors Title errors
            ]
        , Form.group []
            [ Form.label
                [ for "Price" ]
                [ text "Price" ]
            , Input.number
                [ Input.attrs
                    [ value (toString product.price)
                    , onInput (UpdatePrice product.id)
                    ]
                ]
            , viewFormErrors Price errors
            ]
        , div []
            [ Button.button [ Button.primary,Button.attrs[type_ "submit"] ] [ text "Submit" ]
            ]
        ]