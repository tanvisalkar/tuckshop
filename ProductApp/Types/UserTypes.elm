module Types.UserTypes exposing (..)

type alias User =
    { name : String
    , email : String
    , password : String
    , loggedIn : Bool
    , errorMsg : String
    , token : String
    , errors : List RegisterFormError
    }

type RegisterFormField
    = Name
    | Email
    | Password

type alias RegisterFormError =
    ( RegisterFormField, String )

type alias UserStorage =
    { email : String
    , token : String
    , loggedIn : Bool
    }