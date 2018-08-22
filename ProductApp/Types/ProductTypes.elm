module Types.ProductTypes exposing (..)

import RemoteData exposing (WebData)
import Navigation exposing (Location)
import Http
import Types.UserTypes exposing (..)
-- import Components.Navbar as Navbar
import Components.Types.NavbarTypes as NavbarTypes
import Toasty
import Toasty.Defaults

type alias Product =
    { id:Int
    , title:String
    , price:Float
    }

type alias ProductField =
    { title:String
    , price:String
    }

type Route
    = ProductsRoute
    | ProductRoute Int
    | NotFoundRoute
    | NewProductRoute
    | UserSignupRoute
    | UserDashboardRoute
    | UserLoginRoute

type alias Model =
    { products : WebData (List Product)
    , currentRoute : Route
    , newProduct : Product
    , errors : List Error
    , noView : Int
    , user : User
    , navbarModel : NavbarTypes.Model
    , toasties : Toasty.Stack Toasty.Defaults.Toast
    }

type Msg
    = GetProducts
    | DataReceived (WebData (List Product))
    | LocationChanged Location
    | UpdateTitle ProductId String
    | UpdatePrice ProductId String
    | SubmitUpdatedProduct ProductId
    | ProductUpdated (Result Http.Error Product)
    | DeleteProduct ProductId
    | ProductDeleted (Result Http.Error String)
    | NewProductTitle String
    | NewProductPrice String
    | CreateNewProduct
    | ProductCreated (Result Http.Error Product)
    | UpdateNoViewCount
    | SaveName String
    | SaveEmail String
    | SavePassword String
    | Signup
    | ClickRegisterUser
    | AuthError Http.Error
    | GetTokenSuccess (Result Http.Error String)
    | ClickLoginUser
    | NavbarMsg NavbarTypes.Msg
    | LogOut Bool
    | ToastyMsg (Toasty.Msg Toasty.Defaults.Toast)

type alias ProductId =
    Int

type FormField
    = Title
    | Price

type alias Error =
    ( FormField, String )

