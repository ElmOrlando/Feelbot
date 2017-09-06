module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


---- MODEL ----


type alias Model =
    { feels : List Feel
    , users : List User
    }


type alias User =
    { id : Int
    , avatar : String
    , displayName : String
    , feelCount : Int
    , feelsExperienced : List Feel
    , ideaCount : Int
    , ideasCreated : List Idea
    , username : String
    }


type alias Feel =
    { id : Int
    , emoji : String
    , feltCount : Int
    , ideas : List Idea
    , name : String
    }


type alias Idea =
    { id : Int
    , description : String
    , voteCount : Int
    }


initialModel : Model
initialModel =
    { feels = sampleFeelData
    , users = sampleUserData
    }


sampleFeelData : List Feel
sampleFeelData =
    [ { id = 1
      , emoji = feelEmoji Tired
      , feltCount = 0
      , ideas =
            [ { id = 1
              , description = "Take a walk."
              , voteCount = 1
              }
            ]
      , name = "Tired"
      }
    , { id = 100
      , emoji = feelEmoji Angry
      , feltCount = 10
      , ideas =
            [ { id = 1
              , description = "Delete all your code."
              , voteCount = 1
              }
            ]
      , name = "Angry"
      }
    , { id = 999
      , emoji = feelEmoji Unmotivated
      , feltCount = 999
      , ideas =
            [ { id = 1
              , description = "Read a book."
              , voteCount = 1
              }
            ]
      , name = "Unmotivated"
      }
    ]


sampleUserData : List User
sampleUserData =
    [ { id = 1
      , avatar = ""
      , displayName = "Bijan"
      , feelCount = 1
      , feelsExperienced = []
      , ideaCount = 1
      , ideasCreated = []
      , username = "bijanbwb"
      }
    ]


sampleIdeaData : List Idea
sampleIdeaData =
    [ { id = 1
      , description = "Take a walk."
      , voteCount = 1
      }
    , { id = 2
      , description = "Delete all your code."
      , voteCount = 10
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
    | ExperienceFeel Feel
    | RemoveFeelFromExperiencedness Feel


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ExperienceFeel feel ->
            let
                newFeels =
                    model.feels
                        |> List.map
                            (\currentFeel ->
                                if currentFeel.id == feel.id then
                                    { feel | feltCount = feel.feltCount + 1 }
                                else
                                    currentFeel
                            )
            in
                ( { model | feels = newFeels }, Cmd.none )

        RemoveFeelFromExperiencedness feel ->
            ( model, Cmd.none )

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

    Feelbot is like Stack Overflow for developer feelings. It's a simple list of
    common emotions that developers naturally tend to experience along with ideas
    and suggestions for constructively working with those emotions.

    Each "feel" has a set of user-generated "ideas" associated with it. These
    suggestions can be voted up or down so that particularly relevant or strong
    ideas appear at the top.
    """



---- FEELS ----


feelsSection : Model -> Html Msg
feelsSection model =
    div []
        [ h2 [] [ text "Feel Selector" ]
        , p [] [ text "Experiencing a feel?" ]
        , feelsList model
        , feelButton
        ]


feelsList : Model -> Html Msg
feelsList model =
    div []
        (List.map feelItem model.feels)


feelItem : Feel -> Html Msg
feelItem feel =
    div []
        [ span [] [ text (feel.emoji ++ " " ++ feel.name) ]
        , button [ onClick <| ExperienceFeel feel ]
            [ text "I have indeed experienced this feel." ]
        , span [] [ text <| toString feel.feltCount ]
        , feelIdeas feel.ideas
        ]


feelIdeas : List Idea -> Html Msg
feelIdeas ideas =
    ul [] (List.map feelIdeaItem ideas)


feelIdeaItem : Idea -> Html Msg
feelIdeaItem idea =
    p [] [ text idea.description ]


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
