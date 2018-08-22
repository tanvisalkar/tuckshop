module Apis.ProductApi exposing (getProductsCommand,updateProductCommand,deleteProductCommand,createProductCommand)

import Http
import RemoteData
import Types.ProductTypes exposing (..)
import Json.Decode exposing (string, int, float, list, Decoder)
import Json.Decode.Pipeline exposing (decode, required)
import Json.Encode as Encode

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


productEncoder : Product -> Encode.Value
productEncoder product =
    Encode.object
        [ ( "id", Encode.int product.id )
        , ( "title", Encode.string product.title )
        , ( "price", Encode.float product.price )
        ]

updateProductRequest : Product -> Http.Request Product
updateProductRequest product =
    Http.request
        { method = "PATCH"
        , headers = []
        , url = "http://localhost:5019/products/" ++ (toString product.id)
        , body = Http.jsonBody (productEncoder product)
        , expect = Http.expectJson productDecoder
        , timeout = Nothing
        , withCredentials = False
        }

updateProductCommand : Product -> Cmd Msg
updateProductCommand product =
    updateProductRequest product
        |> Http.send ProductUpdated


deletePoroductRequest : Product -> Http.Request String
deletePoroductRequest product =
    Http.request
        { method = "DELETE"
        , headers = []
        , url = "http://localhost:5019/products/" ++ (toString product.id)
        , body = Http.emptyBody
        , expect = Http.expectString
        , timeout = Nothing
        , withCredentials = False
        }

deleteProductCommand : Product -> Cmd Msg
deleteProductCommand product =
    deletePoroductRequest product
        |> Http.send ProductDeleted

createProductCommand : Product -> Cmd Msg
createProductCommand product =
    createProductRequest product
        |> Http.send ProductCreated


createProductRequest : Product -> Http.Request Product
createProductRequest product =
    Http.request
        { method = "POST"
        , headers = []
        , url = "http://localhost:5019/products"
        , body = Http.jsonBody (newProductEncoder product)
        , expect = Http.expectJson productDecoder
        , timeout = Nothing
        , withCredentials = False
        }


newProductEncoder : Product -> Encode.Value
newProductEncoder product =
    Encode.object
        [ ( "title", Encode.string product.title )
        , ( "price", Encode.float product.price )
        ]