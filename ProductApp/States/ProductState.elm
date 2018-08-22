module States.ProductState exposing (..)

import RemoteData exposing (WebData)
import Types.ProductTypes exposing (..)
import Apis.ProductApi exposing (getProductsCommand,updateProductCommand,deleteProductCommand,createProductCommand)
import Navigation exposing (Location)
import Routing
import Misc exposing (..)
import Validate exposing (Validator)
import Types.UserTypes exposing (..)
import Apis.UserApi exposing (..)
import Ports exposing (..)
import Components.Navbar as Navbar
import Components.Types.NavbarTypes as NavbarTypes
import Toasty
import Toasty.Defaults

tempProductId =
    -1

emptyProduct : Product
emptyProduct =
    Product tempProductId "" 0

initialUserValues =
    { name = "", email = "", password = "", loggedIn = False, errorMsg="" , token ="" , errors = [] }
    
initialModel : User -> Route -> NavbarTypes.Model -> Model
initialModel user route navbarState =
    { products = RemoteData.Loading
    , currentRoute = route
    , newProduct = emptyProduct
    , errors = []
    , noView = 0
    , user = user
    , navbarModel = navbarState
    , toasties = Toasty.initialState
    }

initialUserStorage =
    { email = "", token = "" , loggedIn = False }

init : Maybe UserStorage -> Location -> ( Model, Cmd Msg )
init maybeUser location =
    let
        currentRoute =
            Routing.extractRoute location
        
        ( navbarState, navbarCmd ) =
            case maybeUser of
                Just userObj ->
                    Navbar.initialState userObj.loggedIn

                Nothing ->
                    Navbar.initialState False 
            

        user =
            case maybeUser of
                Just userObj ->
                    Debug.log "userobj case"
                    { name = "", email = userObj.email, password = "", loggedIn = userObj.loggedIn, errorMsg="" , token =userObj.token , errors = [] }

                Nothing ->
                    Debug.log "nothing case"
                    initialUserValues        
        
    in        
        let
            inModel =
                initialModel user currentRoute navbarState
        in
            ( inModel,  Cmd.batch [ Cmd.map NavbarMsg navbarCmd,getProductsCommand ] )


apiUrl: String
apiUrl =
    "http://localhost:5019/"

registerUrl : String
registerUrl =
    apiUrl ++ "users"

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetProducts ->
            ({ model | products = RemoteData.Loading}, getProductsCommand )

        DataReceived response ->
            ( { model
                | products = response
              }
            , Cmd.none
            )
        
        LocationChanged location ->
            ( { model
                | currentRoute = Routing.extractRoute location
              }
            , Cmd.none
            )
        UpdateTitle productId newTitle ->
            updateField productId newTitle setTitle model

        UpdatePrice productId newPrice ->
            updateField productId newPrice setPrice model

        SubmitUpdatedProduct productId ->
            case findProductById productId model.products of
                Just product ->
                    let
                        errorList =
                            validateEditInput product
                    in
                        if errorList == [] then
                            ( { model |  errors = [] }, updateProductCommand product )
                        else
                            ( { model |  errors = errorList }, Cmd.none )

                Nothing ->
                    ( { model |  errors = [] }, Cmd.none )
                                

        ProductUpdated (Ok product) ->
            ( model, Cmd.none )
                |> addToast (Toasty.Defaults.Success (Just "Success") ("Product "++product.title++" updated successfully!!") )
        
        ProductUpdated (Err httpError) ->
            ( model, Cmd.none )
                |> addToast (Toasty.Defaults.Error (Just "Error") (createErrorMessage httpError) )

        DeleteProduct productId ->
            case findProductById productId model.products of
                Just product ->
                    ( model, deleteProductCommand product )
                        |> addToast (Toasty.Defaults.Error (Just "Delete Product") ("Product "++product.title++" deleted successfully!!") )

                Nothing ->
                    ( model, Cmd.none )

        ProductDeleted _ ->
            ( model, getProductsCommand )

        NewProductTitle newTitle ->
            updateNewProduct newTitle setTitle model

        NewProductPrice newPrice ->
            updateNewProduct newPrice setPrice model

        CreateNewProduct ->
            let
                errorList =
                    validateInput model
            in
                if errorList == [] then
                    ( { model |  errors = [] }, createProductCommand model.newProduct )
                else
                    ( { model |  errors = errorList }, Cmd.none )

        ProductCreated (Ok product) ->
            ( { model
                | products = addNewProduct product model.products
                , newProduct = emptyProduct
              }
            , Cmd.none
            )
                |> addToast (Toasty.Defaults.Success (Just "Success") ("Product "++product.title++" created successfully!!") )

        ProductCreated (Err httpError) ->
            ( model, Cmd.none )
                |> addToast (Toasty.Defaults.Error (Just "Error") (createErrorMessage httpError) )

        UpdateNoViewCount ->
            ( { model | noView = model.noView + 1 }, Cmd.none )
        
        SaveName name ->
            updateNewUser name setUserName model

        SaveEmail email ->
            updateNewUser email setUserEmail model

        SavePassword password ->
            updateNewUser password setUserPassword model

        Signup ->
            let
                loggedIn = True
            in    
                let
                    updatedNewUser =
                        setUserLoggedIn loggedIn model.user
                in
                    ( { model | user = updatedNewUser }, Cmd.none )
        
        ClickRegisterUser ->
            let
                errorList =
                    validateRegisterFormInput model
            in
                if errorList == [] then
                    let
                        updatedNewUser =
                            setUserErrors errorList model.user
                    in
                        ( { model | user = updatedNewUser }, authUserCmd model.user registerUrl )
                else
                    let
                        updatedNewUser =
                            setUserErrors errorList model.user
                    in
                        ( { model | user = updatedNewUser }, Cmd.none )
        
        AuthError error ->
            updateNewUser (toString error) setUserErrorMsg model
        
        GetTokenSuccess (Ok newToken) ->
            let
                errorMsg = ""
                token = newToken
                loggedIn = True
            in    
                let
                    newUser =
                        setUserErrorMsg errorMsg model.user

                in
                    let
                        updatedNewUser =
                            setUserToken token newUser
                    in
                        let
                            updatedUserOb = setUserLoggedIn loggedIn updatedNewUser 
                            command =
                                storeUserDetails ({ initialUserStorage | email=model.user.email , token=token, loggedIn=loggedIn })                            
                        in
                            
                            ( { model | user = updatedUserOb } |> Debug.log "got new token", Cmd.batch [ command , Navigation.load "dashboard" ] )

        GetTokenSuccess (Err _) ->
            ( model |> Debug.log "token error", Cmd.none )

        ClickLoginUser ->
            let
                errorList =
                    validateLoginFormInput model
            in
                if errorList == [] then
                    let
                        updatedNewUser =
                            setUserErrors errorList model.user
                    in
                        ( { model | user = updatedNewUser }, loginUserCmd model.user registerUrl )
                else
                    let
                        updatedNewUser =
                            setUserErrors errorList model.user
                    in
                        ( { model | user = updatedNewUser }, Cmd.none )

        NavbarMsg navbarmsg ->
            let
                ( newNavModel, newCmd ) =
                    Navbar.update navbarmsg model.navbarModel
            in
                { model | navbarModel = newNavModel } ! [ Cmd.map NavbarMsg newCmd ]

        LogOut loggedOut->
            if loggedOut == True then
                let
                    updatedNewUser =
                        setUserObject "" "" "" False "" "" [] model.user
                in
                    ({ model | user = updatedNewUser },Cmd.batch[removeUserDetails ({ initialUserStorage | email="" , token="", loggedIn=False }), Navigation.newUrl "/login" ])
            else
                ( model, Cmd.none )

        ToastyMsg subMsg ->
            Toasty.update toastyConfig ToastyMsg subMsg model





--updateField :
--     ProductId
--     -> String
--     -> (String -> Product -> Product)
--     -> Model
--     -> WebData (List Product)

updateField productId newValue updateFunction model =
    let
        updateProduct product =
            if product.id == productId then
                updateFunction newValue product
            else
                product

        updateProducts products =
            List.map updateProduct products

        updatedProducts =
            RemoteData.map updateProducts model.products
    in
        ( { model | products = updatedProducts }, Cmd.none )


setTitle : String -> Product -> Product
setTitle newTitle product =
    { product | title = Debug.log "newTitle: " newTitle }

setPrice : String -> Product -> Product
setPrice newPrice product =
    { product | price = String.toFloat newPrice |> Result.withDefault 0 }


updateNewProduct :
    String
    -> (String -> Product -> Product)
    -> Model
    -> ( Model, Cmd Msg )
updateNewProduct newValue updateFunction model =
    let
        updatedNewProduct =
            updateFunction newValue model.newProduct
    in
        ( { model | newProduct = updatedNewProduct }, Cmd.none )


addNewProduct : Product -> WebData (List Product) -> WebData (List Product)
addNewProduct newProduct products =
    let
        appendProduct : List Product -> List Product
        appendProduct listOfProducts =
            List.append listOfProducts [ newProduct ]
    in
        RemoteData.map appendProduct products


-- validate : Validator ( FormField, String ) Product
-- validate =
--     Validate.all
--         [ Validate.ifBlank .title ( Title, "Title can't be blank." )
--         , Validate.ifBlank .price ( Price, "Price can't be blank." )
--         ]

validateInput : Model -> List ( FormField, String )
validateInput model =
    validateProductTitle model.newProduct []
        |> validateProductPrice model.newProduct

validateEditInput : Product -> List ( FormField, String )
validateEditInput product =
    validateProductTitle product []
        |> validateProductPrice product
        
validateProductTitle : Product -> List ( FormField, String ) -> List ( FormField, String )
validateProductTitle product errorList =
    if product.title == "" then
       (Title,"Title required") :: errorList
    else
        errorList

validateProductPrice : Product -> List ( FormField, String ) -> List ( FormField, String )
validateProductPrice product errorList =
    if toString product.price == "" || product.price == -1 then
        (Price,"Price required") :: errorList
    else
        errorList

updateNewUser :
    String
    -> (String -> User -> User)
    -> Model
    -> ( Model, Cmd Msg )
updateNewUser newValue updateFunction model =
    let
        updatedNewUser =
            updateFunction newValue model.user
    in
        ( { model | user = updatedNewUser }, Cmd.none )


setUserName : String -> User -> User
setUserName newUserName user =
    { user | name = Debug.log "newUserName: " newUserName }

setUserEmail : String -> User -> User
setUserEmail newUserEmail user =
    { user | email = Debug.log "newUserEmail: " newUserEmail }

setUserPassword : String -> User -> User
setUserPassword newUserPassword user =
    { user | password = Debug.log "newUserPassword: " newUserPassword }

setUserLoggedIn : Bool -> User -> User
setUserLoggedIn newUserLoggedIn user =
    { user | loggedIn = Debug.log "newUserPassword: " newUserLoggedIn }   

setUserErrorMsg : String -> User -> User
setUserErrorMsg newUserErrorMsg user =
    { user | errorMsg = Debug.log "newUserErrorMsg: " newUserErrorMsg }

setUserToken : String -> User -> User
setUserToken newUserToken user =
    { user | token = Debug.log "newUserToken: " newUserToken }

validateRegisterFormInput : Model -> List ( RegisterFormField, String )
validateRegisterFormInput model =
    validateUserName model.user []
        |> validateUserEmail model.user
        |> validateUserPassword model.user

validateLoginFormInput : Model -> List ( RegisterFormField, String )
validateLoginFormInput model =
    validateUserEmail model.user []
        |> validateUserPassword model.user

validateUserName : User -> List ( RegisterFormField, String ) -> List ( RegisterFormField, String )
validateUserName user errorList =
    if user.name == "" then
       (Name,"Name required") :: errorList
    else
        errorList

validateUserEmail : User -> List ( RegisterFormField, String ) -> List ( RegisterFormField, String )
validateUserEmail user errorList =
    if user.email == "" then
       (Email,"Email required") :: errorList
    else
        errorList

validateUserPassword : User -> List ( RegisterFormField, String ) -> List ( RegisterFormField, String )
validateUserPassword user errorList =
    if user.password == "" then
       (Password,"Password required") :: errorList
    else
        errorList

setUserErrors : List ( RegisterFormField, String )  -> User -> User
setUserErrors newErrors user =
    { user | errors = newErrors } 

setUserObject : String -> String -> String -> Bool -> String -> String -> (List RegisterFormError) -> User -> User
setUserObject newUserName  newUserEmail newUserPassword newUserLoggedIn newUserErrorMsg newUserToken newUserErrors user =
    { user | name = newUserName, email = newUserEmail, password = newUserPassword, loggedIn = newUserLoggedIn, errorMsg= newUserErrorMsg, token = newUserToken , errors = newUserErrors }