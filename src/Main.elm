port module Main exposing (Model, Msg(..), init, main, toFirebase, update, view)

import Browser
import Html exposing (Html, button, div, h1, h2, img, text)
import Html.Attributes exposing (src)
import Html.Events exposing (onClick)
import Json.Encode as Encode



---- MODEL ----


type alias Model =
    { counter : Int }


init : ( Model, Cmd Msg )
init =
    ( { counter = 0 }, Cmd.none )


type Msg
    = NoOp
    | Inc
    | Dec
    | FromFirebase (Maybe Int)



---- UPDATE ----


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Inc ->
            ( model
            , toFirebase (model.counter + 1)
            )

        Dec ->
            ( model
            , toFirebase (model.counter - 1)
            )

        FromFirebase maybeCount ->
            ( { model | counter = Maybe.withDefault 0 maybeCount }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ img [ src "/logo.svg" ] []
        , h1 [] [ text "Your Elm App is working!" ]
        , h2 [] [ text ("Counter = " ++ String.fromInt model.counter) ]
        , button [ onClick Dec ] [ text "-" ]
        , button [ onClick Inc ] [ text "+" ]
        ]



---- SUBSCRIPTIONS ----


subscriptions : Model -> Sub Msg
subscriptions model =
    fromFirebase FromFirebase



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = subscriptions
        }


port toFirebase : Int -> Cmd msg


port fromFirebase : (Maybe Int -> msg) -> Sub msg
