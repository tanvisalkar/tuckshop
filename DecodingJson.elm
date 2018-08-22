module DecodingJson exposing (..)
import Http
import Html exposing (..)
import Json.Decode exposing (string, int, float, list, Decoder)
import Json.Decode.Pipeline exposing (decode, required)
import Html.Events exposing (onClick)
import RemoteData exposing (WebData)

type alias Product =
    { id:Int
    , title:String
    , price:Float
    }

type alias Model =
    { products : WebData (List Product)
    }

type Msg
    = GetProducts
    | DataReceived (WebData (List Product))

view : Model -> Html Msg
view model =
    div []
        [ button [ onClick GetProducts ]
            [ text "Refresh products" ]
        , viewProductsOrError model
        ]


viewProductsOrError : Model -> Html Msg
viewProductsOrError model =
    case model.products of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            h3 [] [ text "Loading..." ]

        RemoteData.Success products ->
            viewProducts products

        RemoteData.Failure httpError ->
            viewError (createErrorMessage httpError)

viewError : String -> Html Msg
viewError errorMessage =
    let
        errorHeading =
            "Couldn't fetch data at this time."
    in
        div []
            [ h3 [] [ text errorHeading ]
            , text ("Error: " ++ errorMessage)
            ]

viewTableHeader: Html Msg
viewTableHeader =
    tr []
        [ th [] [text "ID"]
        , th [] [text "Name"]
        , th [] [text "Price"]
        ]

viewProduct: Product -> Html Msg
viewProduct product =
    tr []
        [ td [] [text (toString product.id)]
        , td [] [text product.title]
        , td [] [text (toString  product.price)]
        ]

viewProducts: List Product -> Html Msg
viewProducts products =
    div []
        [ h3 [] [text "Products"]
        , table[]
            ([viewTableHeader] ++ List.map viewProduct products)
        ]

productDecoder : Decoder Product
productDecoder =
    decode Product
        |> required "id" int
        |> required "title" string
        |> required "price" float


getProductsCommand : Cmd Msg
getProductsCommand =
    list productDecoder
        |> Http.get "http://localhost:5019/products"
        |> RemoteData.sendRequest
        |> Cmd.map DataReceived


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


createErrorMessage : Http.Error -> String
createErrorMessage httpError =
    case httpError of
        Http.BadUrl message ->
            message

        Http.Timeout ->
            "Server is taking too long to respond. Please try again later."

        Http.NetworkError ->
            "It appears you don't have an Internet connection right now."

        Http.BadStatus response ->
            response.status.message

        Http.BadPayload message response ->
            message

init : ( Model, Cmd Msg )
init =
    ( { products = RemoteData.Loading
      }
    , getProductsCommand
    )

main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }

