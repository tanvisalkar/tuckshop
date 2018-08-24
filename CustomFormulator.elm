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

type alias TextAreaField =
     { slug : String
    ,   displayLabel : String
    ,   placeHolderText : String
    ,   helpText : String
    ,   isOptional : Bool
    ,   isHidden : Bool
    ,   displayOrder : Int
    ,   optionalAttrib : AttributeType
    }

type alias CombinationField = 
    {
        inputfields : List InputField
    ,   textareafields : List TextAreaField

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
    { formElem : List SubElement
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

formEmailVal : SubElement
formEmailVal = 
    { displayLabel = "Email"
        ,   helpText = ""
        ,   isOptional = False
        ,   isHidden = False
        ,   displayOrder = 1
        ,   optionalAttrib = Text
        ,   subElements =  [{ slug = "email"
                ,   displayLabel = ""
                ,   placeHolderText = "Enter email"
                ,   helpText = ""
                ,   isOptional = False
                ,   isHidden = False
                ,   displayOrder = 1
                ,   optionalAttrib = Email
            }]
        }

init : ( Model, Cmd msg )
init =
    ( { formElem = [ formval, formEmailVal ]
      }
    , Cmd.none
    )

update : msg -> Model -> ( Model, Cmd msg )
update msg model =
    (model,Cmd.none)


generateField : InputField -> Html msg
generateField element =
    case element.optionalAttrib of
        Text ->
            input [ class "form-control"
                            , id element.slug
                            , type_ "text"
                            ]
                            [] 
        Email  ->
            input [ class "form-control"
                            , id element.slug
                            , type_ "email"
                            ]
                            [] 
        Tel ->
            input [ class "form-control"
                            , id element.slug
                            , type_ "tel"
                            ]
                            [] 
        Number ->
            input [ class "form-control"
                            , id element.slug
                            , type_ "number"
                            ]
                            [] 

generateFields : List InputField -> List  (Html msg) -> List (Html msg)
generateFields lstField lst =
    case lstField of
        [] ->   lst
        (x::xs) -> 
            List.append lst [(generateField x)]

-- takes each form input and returns list of html
generateRoot : SubElement -> Html msg  
generateRoot field = 
    let 
        labelComp = [ label [  for field.displayLabel ]
                    [ text field.displayLabel ]
                    ]
    in 
        let
            formComp = 
                if List.length field.subElements > 0 then
                    List.append labelComp (generateFields field.subElements [])
                else 
                    labelComp
        in
            div []
                formComp
    

-- takes each form input and returns list of html
generateForm : List SubElement -> List (Html msg) -> Html msg  
generateForm lst1 lst2 = 
    case lst1 of
        [] ->   div [] lst2
        (x::xs) -> 
            -- div [] [text "test"]
            generateForm  xs (List.append lst2 [generateRoot x])




view : Model -> Html msg
view model =
    div []
        [
            generateForm model.formElem []
        ]


main : Program Never Model msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }