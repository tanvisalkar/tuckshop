module Views.User.Dashboard exposing (..)
import Html exposing (Html, div, h1, form, text, input, button, Attribute, label, span)
import Html.Attributes exposing (id, type_, name,style,class,for)
import Html.Events exposing (..)
import Types.UserTypes exposing (..)
import Types.ProductTypes exposing (..)
import Bootstrap.Form as Form
import Bootstrap.Form.Input as Input



view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ div [ class "row" ]
            [ div [ class "col-md-6 col-md-offset-3" ]
                [ h1 [ class "text-center" ] [ text "Dashboard" ]
                , span [] [text ("Welcome "++model.user.name)]
                ]
            ]
        ]