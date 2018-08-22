module Components.Types.NavbarTypes exposing (..)
import Bootstrap.Navbar as Navbar

-- You need to keep track of the view state for the navbar in your model

type alias Model =
    { navbarState : Navbar.State, loggedIn : Bool  }

-- Define a message for the navbar

type Msg
    = NavbarMsg Navbar.State
    | LogOut