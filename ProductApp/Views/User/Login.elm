module Views.User.Login exposing (..)
import Html exposing (Html, div, h1, form, text, input, button, Attribute, label)
import Html.Attributes exposing (id, type_, name,style,class,for)
import Html.Events exposing (..)
import Types.UserTypes exposing (..)
import Types.ProductTypes exposing (..)
import Bootstrap.Form as Form
import Bootstrap.Form.Input as Input

viewRegisterFormErrors : RegisterFormField -> List RegisterFormError -> Html msg
viewRegisterFormErrors field errors =
    errors
        |> List.filter (\( fieldError, _ ) -> fieldError == field)
        |> List.map (\( _, error ) -> div [ class "error", style [ ( "color", "red" ) ] ] [ text error ])
        |> div []

view : User -> Html Msg
view user =
    div [ class "container" ]
        [ div [ class "row", style [("padding-top","50px")] ]
            [ div [ class "col-md-6 col-md-offset-3", style [("max-width", "450px"), ("padding", "15px 35px 45px"),("margin", "0 auto"),("background", "#eee") ] ]
                [ h1 [ class "text-center" ] [ text "Login" ]
                , Form.form [ onSubmit ClickLoginUser ]
                    [ Form.group []
                        [ Form.label
                            [ for "email" ]
                            [ text "Email" ]
                        , Input.email
                            [ Input.id "email"
                            , Input.attrs [ onInput SaveEmail ]
                            ]
                        , viewRegisterFormErrors Email user.errors 
                        ]
                    , Form.group []
                        [ Form.label
                            [ for "password" ]
                            [ text "Password" ]
                        , Input.password
                            [ Input.id "password"
                            , Input.attrs [onInput SavePassword]
                            ]
                        , viewRegisterFormErrors Password user.errors 
                        ]
                    , div [ class "text-center" ]
                        [ button
                            [ class "btn btn-lg btn-primary"
                            , type_ "submit"
                            ]
                            [ text "Login" ]
                        ]
                    ]
                ]
            ]
        ]