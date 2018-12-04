port module Main exposing (Model, Msg(..), init, main, toFirebase, toFirestore, update, view)

import Browser
import Dict exposing (Dict)
import Html exposing (Html, button, div, form, h1, h2, img, input, li, text, ul)
import Html.Attributes exposing (placeholder, src, type_, value)
import Html.Events exposing (onClick, onInput, onSubmit)
import Json.Decode exposing (Decoder)



---- MODEL ----


type alias Model =
    { messages : Dict String String
    , currentMessage : String
    }


init : ( Model, Cmd Msg )
init =
    ( { messages = Dict.empty, currentMessage = "" }
    , Cmd.none
    )


type Msg
    = NoOp
    | SendMessage
    | SendToFirestore
    | ReceiveMessages ( String, Json.Decode.Value )
    | ReceiveFromFirestore ( String, Json.Decode.Value )
    | UpdateCurrentMessage String



---- UPDATE ----


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ReceiveFromFirestore ( key, value ) ->
            case decodeReceivedMessages ( key, value ) of
                Ok decodedMessages ->
                    ( { model | messages = decodedMessages }, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )

        ReceiveMessages ( key, value ) ->
            -- case decodeReceivedMessages ( key, value ) of
            --     Ok decodedMessages ->
            --         ( { model | messages = decodedMessages }, Cmd.none )
            --     Err _ ->
            ( model, Cmd.none )

        SendMessage ->
            ( { model | currentMessage = "" }, toFirebase ( "messages", model.currentMessage ) )

        SendToFirestore ->
            ( { model | currentMessage = "" }, toFirestore ( "messages", model.currentMessage ) )

        UpdateCurrentMessage message ->
            ( { model | currentMessage = message }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )


decodeReceivedMessages ( _, value ) =
    Json.Decode.decodeValue messagesDecoder value



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ img [ src "/logo.svg" ] []
        , h1 [] [ text "Your Elm App is working!" ]
        , h2 [] [ text "Messages" ]
        , ul [] (List.map viewMessage (model.messages |> Dict.toList |> List.map Tuple.second))
        , form [ onSubmit SendToFirestore ]
            [ input [ type_ "text", placeholder "Message", value model.currentMessage, onInput UpdateCurrentMessage ] []
            , button [] [ text "Send" ]
            ]
        ]


viewMessage message =
    li [] [ text message ]


messagesDecoder : Decoder (Dict String String)
messagesDecoder =
    Json.Decode.dict Json.Decode.string



---- SUBSCRIPTIONS ----


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ fromFirebase ReceiveMessages
        , fromFirestore ReceiveFromFirestore
        ]



---- PORTS ----


port fromFirestore : (( String, Json.Decode.Value ) -> msg) -> Sub msg


port toFirestore : ( String, String ) -> Cmd msg


port fromFirebase : (( String, Json.Decode.Value ) -> msg) -> Sub msg


port toFirebase : ( String, String ) -> Cmd msg



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = subscriptions
        }
