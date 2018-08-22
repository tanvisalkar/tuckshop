module CustomFormulator exposing (..)
import Html exposing (..)
import Html.Attributes exposing (id, type_, name,style,class,for)

type alias InputField =
    { slug : String
    ,   displayLabel : String
    ,   placeHolderText : String
    ,   helpText : String
    ,   isOptional : Bool
    ,   isHidden : Bool
    ,   displayOrder : Int
    ,   optionalAttrib : AttributeType
    }

type AttributeType = Text 
    | Email 
    | Tel 
    | Number

type alias SubElement =
    { displayLabel : String
    ,   helpText : String
    ,   isOptional : Bool
    ,   isHidden : Bool
    ,   displayOrder : Int
    ,   optionalAttrib : AttributeType
    ,   subElements :  List InputField 
    }


type alias Form = 
    {
        name: SubElement
    -- ,   price: SubElement
    }

type alias Model =
    { nicknames : List String
    , errorMessage : Maybe String
    , name : SubElement
    }

formval : SubElement
formval = 
    { displayLabel = "Name"
        ,   helpText = ""
        ,   isOptional = False
        ,   isHidden = False
        ,   displayOrder = 1
        ,   optionalAttrib = Text
        ,   subElements =  [{ slug = "name"
                ,   displayLabel = ""
                ,   placeHolderText = "Enter name"
                ,   helpText = ""
                ,   isOptional = False
                ,   isHidden = False
                ,   displayOrder = 1
                ,   optionalAttrib = Text
            }]
        }

init : ( Model, Cmd msg )
init =
    ( { nicknames = []
      , errorMessage = Nothing
      , name = formval
      }
    , Cmd.none
    )

update : msg -> Model -> ( Model, Cmd msg )
update msg model =
    (model,Cmd.none)


generateFields: SubElement -> Html msg
generateFields subElement=
    case subElement.optionalAttrib of
        Text ->
            input [ class "form-control"
                            , id "name"
                            , type_ "text"
                            ]
                            [] 
        Email  ->
            input [ class "form-control"
                            , id "name"
                            , type_ "email"
                            ]
                            [] 
        Tel ->
            input [ class "form-control"
                            , id "name"
                            , type_ "tel"
                            ]
                            [] 
        Number ->
            input [ class "form-control"
                            , id "name"
                            , type_ "number"
                            ]
                            [] 


-- takes each form input and returns list of html
--  generateForm : List InputField -> List (Html msg)  



view : Model -> Html msg
view model =
    div []
        [text "Hello!!"]


main : Program Never Model msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }