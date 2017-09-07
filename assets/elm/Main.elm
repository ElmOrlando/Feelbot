module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, keyCode)
import Json.Decode as Decode
import Navigation


---- MODEL ----


type alias Model =
    { currentPage : Page
    , feels : List Feel
    , users : List User
    }


type Page
    = Home
    | Feels
    | FeelsNew
    | Users
    | NotFound


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


initialModel : Page -> Model
initialModel page =
    { currentPage = Home
    , feels = sampleFeelData
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
      , feelsExperienced = sampleFeelData
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


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    ( location
        |> initPage
        |> initialModel
    , Cmd.none
    )



---- UPDATE ----


type Msg
    = NoOp
    | Navigate Page
    | ChangePage Page
    | CreateFeel Feel
    | ExperienceFeel Feel
    | RemoveFeelFromExperiencedness Feel


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Navigate page ->
            ( { model | currentPage = page }
            , pageToHash page
                |> Navigation.newUrl
            )

        ChangePage page ->
            ( { model | currentPage = page }
            , Cmd.none
            )

        CreateFeel feel ->
            ( { model | feels = feel :: model.feels }
            , Cmd.none
            )

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
                ( { model | feels = newFeels }
                , Cmd.none
                )

        RemoveFeelFromExperiencedness feel ->
            ( model
            , Cmd.none
            )

        NoOp ->
            ( model
            , Cmd.none
            )



---- SUBSCRIPTIONS ----


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



---- VIEW ----


view : Model -> Html Msg
view model =
    case model.currentPage of
        Home ->
            viewHome model

        Feels ->
            viewFeels model

        FeelsNew ->
            viewFeelsNew model

        Users ->
            viewUsers model

        _ ->
            viewHome model


viewHome : Model -> Html Msg
viewHome model =
    div
        []
        [ header model
        , introSection model
        , feelsSection model
        , feelButton
        , feelsIndexButton
        , usersIndexButton
        ]


viewFeels : Model -> Html Msg
viewFeels model =
    div
        []
        [ feelsSection model
        ]


viewUsers : Model -> Html Msg
viewUsers model =
    div
        []
        [ usersSection model
        ]



---- HEADER ----


header : Model -> Html Msg
header model =
    div
        [ class "header" ]
        [ img
            [ class "logo"
            , src "https://a.slack-edge.com/ae7f/plugins/hubot/assets/service_512.png"
            ]
            []
        , p
            [ class "tagline" ]
            [ text tagLine ]
        ]


tagLine : String
tagLine =
    "Feelbot is here to help."



---- INTRO ----


introSection : Model -> Html Msg
introSection model =
    div
        [ class "intro" ]
        [ div
            [ class "alert alert-info" ]
            [ text alertText ]
        , p
            []
            [ text introText ]
        ]


introText : String
introText =
    """
    Feelbot is like Stack Overflow for developer feelings. It's a simple list of
    common emotions that developers naturally tend to experience along with ideas
    and suggestions for constructively working with those emotions.

    Each "feel" has a set of user-generated "ideas" associated with it. These
    suggestions can be voted up or down so that particularly relevant or strong
    ideas appear at the top.
    """


alertText : String
alertText =
    """
    Feelbot is currently in an early stage of development. The data from the
    front-end isn't currently saved anywhere yet.
    """



---- FEELS INDEX PAGE ----


feelsSection : Model -> Html Msg
feelsSection model =
    div
        [ class "container" ]
        [ feelsList model
        ]


feelsList : Model -> Html Msg
feelsList model =
    div
        []
        (List.map feelItem model.feels)


feelItem : Feel -> Html Msg
feelItem feel =
    a
        [ class "feel-link"
        , href "#"
        ]
        [ div
            [ class "feel-item" ]
            [ p
                [ class "feel-emoji" ]
                [ text feel.emoji ]
            , p
                [ class "feel-name" ]
                [ text feel.name ]
            ]
        ]


feelIdeas : List Idea -> Html Msg
feelIdeas ideas =
    ul []
        (List.map feelIdeaItem ideas)


feelIdeaItem : Idea -> Html Msg
feelIdeaItem idea =
    p []
        [ text idea.description ]



---- FEELS SHOW PAGE ----


feelShow : Feel -> Html Msg
feelShow feel =
    div
        []
        []



---- FEELS NEW PAGE ----


viewFeelsNew : Model -> Html Msg
viewFeelsNew model =
    div
        [ class "new-feel container" ]
        [ h1
            []
            [ text "Create a New Feel" ]
        , Html.form
            []
            [ div
                [ class "form-group" ]
                [ label
                    [ for "feel-name" ]
                    [ text "What feel do you want to add?" ]
                , input
                    [ id "feel-name"
                    , class "form-control"
                    , placeholder "Scrumtralescent"
                    , type_ "text"
                    , autofocus True
                    ]
                    []
                ]
            , div
                [ class "form-group" ]
                [ label
                    [ for "feel-emoji" ]
                    [ text "Is there an emoji that properly conveys this feel?" ]
                , input
                    [ id "feel-emoji"
                    , class "form-control"
                    , placeholder "😎"
                    , type_ "text"
                    ]
                    []
                ]
            , button
                [ class "btn btn-success"
                , type_ "submit"
                ]
                [ text "Save" ]
            , button
                [ class "btn btn-default" ]
                [ text "Cancel" ]
            ]
        ]


newFeel : Int -> String -> String -> Feel
newFeel id emoji name =
    { id = id
    , emoji = emoji
    , feltCount = 0
    , ideas = []
    , name = name
    }


onEnter : Msg -> Attribute Msg
onEnter msg =
    -- on "keydown" (Decode.succeed (CreateFeel mockFeel))
    let
        isEnter code =
            if code == 13 then
                Decode.succeed msg
            else
                Decode.fail "not the right keycode"
    in
        on "keydown" (Decode.andThen isEnter keyCode)



---- BUTTONS ----


feelButton : Html Msg
feelButton =
    div
        [ class "feel-button" ]
        [ p
            []
            [ text "Noticed a feel that's missing?" ]
        , a
            [ class "btn btn-lg btn-success"
            , href <| "#/feels/new"
            ]
            [ text "Create a Feel" ]
        ]


feelsIndexButton : Html Msg
feelsIndexButton =
    div
        [ class "feels-index-button" ]
        [ a
            [ class "btn btn-lg btn-info"
            , href <| "#/feels"
            ]
            [ text "List All Feels" ]
        ]


usersIndexButton : Html Msg
usersIndexButton =
    div
        [ class "users-index-button" ]
        [ a
            [ class "btn btn-lg btn-default"
            , href <| "#/users"
            ]
            [ text "List Users" ]
        ]


userButton : Html Msg
userButton =
    div
        []
        [ p
            []
            [ text "Want to contribute?" ]
        , button
            []
            [ text "Create an Account" ]
        ]



---- USERS ----


usersSection : Model -> Html Msg
usersSection model =
    div
        []
        [ h2
            []
            [ text "Feelbot Users" ]
        , p
            []
            [ text "Proudly experiencing emotions since 2017." ]
        , usersList model.users
        , userButton
        ]


usersList : List User -> Html Msg
usersList users =
    div
        []
        (List.map userItem users)


userItem : User -> Html Msg
userItem user =
    a
        [ href <| "#/users/" ++ (toString user.id) ]
        [ div
            []
            [ p
                []
                [ text user.displayName ]
            , p
                []
                [ text <| "Ideas Contributed: " ++ (toString user.ideaCount) ]
            ]
        ]



---- USER SHOW ----


userShow : User -> Html Msg
userShow user =
    div
        []
        []



---- PROGRAM ----


main : Program Never Model Msg
main =
    Navigation.program locationToMessage
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }



---- ROUTING ----


locationToMessage : Navigation.Location -> Msg
locationToMessage location =
    location.hash
        |> hashToPage
        |> ChangePage


initPage : Navigation.Location -> Page
initPage location =
    hashToPage location.hash


hashToPage : String -> Page
hashToPage hash =
    case hash of
        "#/" ->
            Home

        "#/feels" ->
            Feels

        "#/feels/new" ->
            FeelsNew

        "#/users" ->
            Users

        _ ->
            NotFound


pageToHash : Page -> String
pageToHash page =
    case page of
        Home ->
            "#/"

        Feels ->
            "#/feels"

        FeelsNew ->
            "#/feels/new"

        Users ->
            "#/users"

        NotFound ->
            "#/notfound"


pageView : Model -> Html Msg
pageView model =
    case model.currentPage of
        Home ->
            viewHome model

        Feels ->
            viewFeels model

        FeelsNew ->
            viewFeelsNew model

        Users ->
            viewUsers model

        _ ->
            viewHome model
