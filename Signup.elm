module Signup exposing (..)
import Html exposing (Html, div, h1, form, text, input, button, Attribute, label)
import Html.Attributes exposing (id, type_, name,style,class,for)
import Html.Events exposing (..)
-- import Css

-- model
type alias User =
    { name : String
    , email : String
    , password : String
    , loggedIn : Bool
    }


initialModel : User
initialModel =
    { name = ""
    , email = ""
    , password = ""
    , loggedIn = False
    }

-- view
headerStyle : Attribute msg
headerStyle =
    style
        [ ( "padding-left", "3cm" ) ]

view : User -> Html Msg
view user =
    div [ class "container" ]
        [ div [ class "row" ]
            [ div [ class "col-md-6 col-md-offset-3" ]
                [ h1 [ class "text-center" ] [ text "Sign up" ]
                , Html.form []
                    [ div [ class "form-group" ]
                        [ label
                            [ class "control-label"
                            , for "name"
                            ]
                            [ text "Name" ]
                        , input
                            [ class "form-control"
                            , id "name"
                            , type_ "text"
                            , onInput SaveName
                            ]
                            []
                        ]
                    , div [ class "form-group" ]
                        [ label
                            [ class "control-label"
                            , for "email"
                            ]
                            [ text "Email" ]
                        , input
                            [ class "form-control"
                            , id "email"
                            , type_ "email"
                            , onInput SaveEmail
                            ]
                            []
                        ]
                    , div [ class "form-group" ]
                        [ label
                            [ class "control-label"
                            , for "password"
                            ]
                            [ text "Password" ]
                        , input
                            [ class "form-control"
                            , id "password"
                            , type_ "password"
                            , onInput SavePassword
                            ]
                            []
                        ]
                    , div [ class "text-center" ]
                        [ button
                            [ class "btn btn-lg btn-primary"
                            , type_ "submit"
                            , onClick Signup
                            ]
                            [ text "Create my account" ]
                        ]
                    ]
                ]
            ]
        ]

-- update 
type Msg
    = SaveName String
    | SaveEmail String
    | SavePassword String
    | Signup
update : Msg -> User -> User
update message user =
    case message of
        SaveName name ->
            { user | name = name }

        SaveEmail email ->
            { user | email = email }

        SavePassword password ->
            { user | password = password }

        Signup ->
            { user | loggedIn = True }


main : Program Never User Msg
main =
    Html.beginnerProgram
        { model = initialModel
        , view = view
        , update = update
        }