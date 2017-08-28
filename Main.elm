module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


---- MODEL ----


type alias Model =
    { feels : List Feel
    , users : List User
    }


type alias User =
    { displayName : String
    , feelCount : Int
    , feelsExperienced : List Feel
    , ideaCount : Int
    , ideasCreated : List Idea
    , username : String
    }


type alias Feel =
    { emoji : String
    , ideas : List Idea
    , name : String
    }


type alias Idea =
    { description : String
    , votes : Int
    }


initialModel : Model
initialModel =
    { feels = sampleFeelData
    , users = sampleUserData
    }


sampleUserData : List User
sampleUserData =
    [ { displayName = "Bijan"
      , feelCount = 1
      , feelsExperienced = []
      , ideaCount = 1
      , ideasCreated = []
      , username = "bijanbwb"
      }
    ]


sampleFeelData : List Feel
sampleFeelData =
    [ { emoji = feelEmoji Tired
      , ideas = []
      , name = "Tired"
      }
    , { emoji = feelEmoji Worried
      , ideas = []
      , name = "Worried"
      }
    , { emoji = feelEmoji Unmotivated
      , ideas = []
      , name = "Unmotivated"
      }
    ]


type Feels
    = Angry
    | Confused
    | Fearful
    | Frustrated
    | Overwhelmed
    | Reluctant
    | Sad
    | Tired
    | Unheard
    | Unmotivated
    | Worried


feelEmoji : Feels -> String
feelEmoji feel =
    case feel of
        Angry ->
            "😠"

        Confused ->
            "😕"

        Fearful ->
            "😨"

        Frustrated ->
            "😖"

        Overwhelmed ->
            "😣"

        Reluctant ->
            "😯"

        Sad ->
            "😢"

        Tired ->
            "😫"

        Unheard ->
            "😶"

        Unmotivated ->
            "😐"

        Worried ->
            "😟"


init : ( Model, Cmd Msg )
init =
    ( initialModel
    , Cmd.none
    )



---- UPDATE ----


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )



---- SUBSCRIPTIONS ----


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ header model
        , feelsSection model
        , usersSection model
        ]



---- HEADER ----


header : Model -> Html Msg
header model =
    div []
        [ img [ src "https://a.slack-edge.com/ae7f/plugins/hubot/assets/service_512.png", height 60 ] []
        , h1 [] [ text "Feelbot" ]
        , p [] [ text introText ]
        ]


introText : String
introText =
    """
    Feelbot is here to help.

    Feelbot is like Stack Overflow for developer feelings. It's a list of
    common emotions that developers naturally tend to experience while engaging
    in the practice of programming.

    Each "feel" has a set of user-generated "ideas" associated with it. These
    ideas could be voted up so that particularly relevant or strong ideas
    appear at the top.

    Example: A developer clicks the "Overwhelmed" feel, and the top ideas might
    be something along the lines of "Take a walk", "Drink some water", or
    "Review your calendar and reduce commitments."
    """



---- FEELS ----


feelsSection : Model -> Html Msg
feelsSection model =
    div []
        [ h2 [] [ text "Feel Selector" ]
        , p [] [ text "Experiencing a feel?" ]
        , feelsList model.feels
        , feelButton
        ]


feelsList : List Feel -> Html Msg
feelsList feels =
    div []
        (List.map feelItem feels)


feelItem : Feel -> Html Msg
feelItem feel =
    div []
        [ span [] [ text (feel.emoji ++ " " ++ feel.name) ]
        ]


feelButton : Html Msg
feelButton =
    div []
        [ p [] [ text "Want to add a feel that's not listed?" ]
        , button [] [ text "Create a Feel" ]
        ]



---- USERS ----


usersSection : Model -> Html Msg
usersSection model =
    div []
        [ h2 [] [ text "Users" ]
        , p [] [ text "Proudly experiencing emotions since 2017." ]
        , usersList model.users
        , userButton
        ]


usersList : List User -> Html Msg
usersList users =
    div []
        (List.map userItem users)


userItem : User -> Html Msg
userItem user =
    div []
        [ p [] [ text user.displayName ]
        , p [] [ text <| "Ideas Contributed: " ++ (toString user.ideaCount) ]
        ]


userButton : Html Msg
userButton =
    div []
        [ p [] [ text "Want to contribute?" ]
        , button [] [ text "Create an Account" ]
        ]



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
