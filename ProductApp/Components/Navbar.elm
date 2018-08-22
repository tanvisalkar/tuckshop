module Components.Navbar exposing (..)
import Bootstrap.Navbar as Navbar
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Ports exposing (..)
import Components.Types.NavbarTypes exposing (..)
-- import Types.ProductTypes exposing (..)

-- The navbar needs to know the initial window size, so the inital state for a navbar requires a command to be run by the Elm runtime

initialState : Bool -> String -> ( Model, Cmd Msg )
initialState loggedIn email =
    let
        ( navbarState, navbarCmd ) =
            Navbar.initialState NavbarMsg
    in
        ( { navbarState = navbarState, loggedIn = loggedIn, email = email }, navbarCmd )

setInitialState : Bool -> Model -> Model
setInitialState loggedIn model = 
    { model | loggedIn = loggedIn } |> Debug.log "token error"

-- You need to handle navbar messages in your update function to step the navbar state forward

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NavbarMsg state ->
            ( { model | navbarState = state }, Cmd.none )
        LogOut ->
             ( { model | loggedIn = False } , callUserLogout True )
        
addMenus : Model -> List (Navbar.Item Msg)
addMenus model =
    -- Debug.log "logged=="++(toString model.loggedIn)
    
    if model.loggedIn == True then
        [ Navbar.dropdown              -- Adding dropdowns is pretty simple
                { id = "mydropdown"
                , toggle = Navbar.dropdownToggle [] [ text "Products" ]
                , items =
                    [ Navbar.dropdownItem
                        [ href "/products" ]
                        [ text "List" ]
                    , Navbar.dropdownDivider
                    , Navbar.dropdownItem
                        [ href "/products/new" ]
                        [ text "Add" ]
                    ]
                }
        -- , Navbar.itemLink [ href "#" ] [ text "Item 2" ]
        ]
    else
        [ Navbar.itemLink [ href "/login" , style [("cursor","pointer")] ] [ text "Login" ]
        ,  Navbar.itemLink [ href "/signup" , style [("cursor","pointer")] ] [ text "Signup" ]
        ]

addLoginMenus : Model -> List (Navbar.CustomItem Msg)
addLoginMenus model =
    -- Debug.log "logged=="++(toString model.loggedIn)
    [ Navbar.textItem []  [ text ("Logged in as: "++model.email) ] 
    ,   Navbar.textItem [] [ a [ onClick LogOut, class "nav-link", style [("cursor","pointer"),("float","right")] ] [ text "Logout" ] ]
        -- Navbar.itemLink [ onClick LogOut, style [("cursor","pointer"),("float","right")] ] [ text "Logout" ]
    -- , Navbar.itemLink [ href "#" ] [ text "Item 2" ]
    ]


addMenu : Model -> (Navbar.Config Msg -> Navbar.Config Msg)
addMenu model =
    if model.loggedIn == True then
        Navbar.customItems
            (addLoginMenus model)
            
    else
        Navbar.items
            (addMenus model)

view : Model -> Html Msg
view model =
    if model.loggedIn == True then
        Navbar.config NavbarMsg
            |> Navbar.dark
            |> Navbar.withAnimation
            |> Navbar.brand [ href "#" ] [ text "Tuckshop" ]
            |> Navbar.items
                (addMenus model)
            |> Navbar.customItems
                (addLoginMenus model)
            |> Navbar.view model.navbarState
    else
        Navbar.config NavbarMsg
        |> Navbar.dark
        |> Navbar.withAnimation
        |> Navbar.brand [ href "#" ] [ text "Tuckshop" ]
        -- |> addMenu model
        |> Navbar.items
            (addMenus model)
        |> Navbar.view model.navbarState


-- If you use animations as above or you use dropdowns in your navbar you need to configure subscriptions too

subscriptions : Model -> Sub Msg
subscriptions model =
    Navbar.subscriptions model.navbarState NavbarMsg