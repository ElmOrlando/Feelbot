module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput, onSubmit)
import Navigation


---- MODEL ----


type alias Model =
    { currentPage : Page
    , errors : Errors
    , feels : List Feel
    , newFeelEmoji : String
    , newFeelName : String
    , users : List User
    }


type Page
    = Home
    | FeelsIndex
    | FeelsNew
    | FeelsShow Feel
    | UsersIndex
    | NotFound


type alias Errors =
    { newFeelEmojiError : String
    , newFeelNameError : String
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


initialModel : Page -> Model
initialModel page =
    { currentPage = Home
    , errors = initialErrors
    , feels = sampleFeelData
    , newFeelEmoji = ""
    , newFeelName = ""
    , users = sampleUserData
    }


initialErrors : Errors
initialErrors =
    { newFeelEmojiError = ""
    , newFeelNameError = ""
    }


sampleFeelData : List Feel
sampleFeelData =
    [ { id = 1
      , emoji = feelEmoji "Frustrated"
      , feltCount = 99
      , ideas =
            [ { id = 1
              , description = "Take a walk."
              , voteCount = 1
              }
            ]
      , name = "Frustrated"
      }
    , { id = 2
      , emoji = feelEmoji "Unmotivated"
      , feltCount = 88
      , ideas =
            [ { id = 2
              , description = "Read a book."
              , voteCount = 2
              }
            ]
      , name = "Unmotivated"
      }
    , { id = 3
      , emoji = feelEmoji "Tired"
      , feltCount = 77
      , ideas =
            [ { id = 3
              , description = "Take a break. Try the Headspace app."
              , voteCount = 3
              }
            ]
      , name = "Tired"
      }
    , { id = 4
      , emoji = feelEmoji "Unheard"
      , feltCount = 66
      , ideas =
            [ { id = 4
              , description = "Speak up!"
              , voteCount = 4
              }
            ]
      , name = "Unheard"
      }
    , { id = 5
      , emoji = feelEmoji "Worried"
      , feltCount = 55
      , ideas =
            [ { id = 5
              , description = "Don't worry, be happy."
              , voteCount = 5
              }
            ]
      , name = "Worried"
      }
    , { id = 6
      , emoji = feelEmoji "Overwhelmed"
      , feltCount = 44
      , ideas =
            [ { id = 6
              , description = "Decrease your workload. Prioritize and focus on what's important."
              , voteCount = 6
              }
            ]
      , name = "Overwhelmed"
      }
    , { id = 7
      , emoji = feelEmoji "Sad"
      , feltCount = 33
      , ideas =
            [ { id = 7
              , description = "See if your company offers reimbursement for therapy costs."
              , voteCount = 7
              }
            ]
      , name = "Sad"
      }
    , { id = 8
      , emoji = feelEmoji "Confused"
      , feltCount = 22
      , ideas =
            [ { id = 8
              , description = "This may be a good sign that you're pushing your boundaries."
              , voteCount = 8
              }
            ]
      , name = "Confused"
      }
    , { id = 9
      , emoji = feelEmoji "Reluctant"
      , feltCount = 11
      , ideas =
            [ { id = 9
              , description = "Some hesitation is naturals."
              , voteCount = 9
              }
            ]
      , name = "Reluctant"
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


feelEmoji : String -> String
feelEmoji feelName =
    case feelName of
        "Confused" ->
            "😕"

        "Frustrated" ->
            "😖"

        "Overwhelmed" ->
            "😣"

        "Reluctant" ->
            "😯"

        "Sad" ->
            "😢"

        "Tired" ->
            "😫"

        "Unheard" ->
            "😶"

        "Unmotivated" ->
            "😐"

        "Worried" ->
            "😟"

        _ ->
            ""


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
    | ExperienceFeel Feel
    | InputFeelName String
    | InputFeelEmoji String
    | SaveFeel Feel


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

        InputFeelEmoji emoji ->
            ( { model | newFeelEmoji = emoji }
            , Cmd.none
            )

        InputFeelName name ->
            ( { model | newFeelName = name }
            , Cmd.none
            )

        NoOp ->
            ( model
            , Cmd.none
            )

        SaveFeel feel ->
            if model.newFeelName == "" then
                ( { model | errors = { newFeelEmojiError = "", newFeelNameError = "The new feel name shouldn't be blank." } }
                , Cmd.none
                )
            else if model.newFeelEmoji == "" then
                ( { model | errors = { newFeelEmojiError = "The new feel emoji shouldn't be blank.", newFeelNameError = "" } }
                , Cmd.none
                )
            else if String.length model.newFeelEmoji /= 1 then
                ( { model | errors = { newFeelEmojiError = "The emoji should just be a single character. This field shouldn't have more than one character.", newFeelNameError = "" } }
                , Cmd.none
                )
            else
                ( { model | feels = feel :: model.feels }
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

        FeelsIndex ->
            viewFeelsIndex model

        FeelsNew ->
            viewFeelsNew model

        UsersIndex ->
            viewUsersIndex model

        _ ->
            viewHome model


viewHome : Model -> Html Msg
viewHome model =
    div
        [ class "col-xs-12" ]
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
        [ viewUsersIndex model
        ]



---- HEADER ----


header : Model -> Html Msg
header model =
    div
        [ class "header" ]
        [ a
            [ href "#/" ]
            [ img
                [ class "logo"
                , src "https://a.slack-edge.com/ae7f/plugins/hubot/assets/service_512.png"
                ]
                []
            ]
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


viewFeelsIndex : Model -> Html Msg
viewFeelsIndex model =
    div
        [ class "container" ]
        [ header model
        , feelsList model
        ]


feelsList : Model -> Html Msg
feelsList model =
    div
        []
        (List.map feelItem model.feels)


feelsSection : Model -> Html Msg
feelsSection model =
    div
        [ class "container" ]
        [ feelsListForFrontPage model
        ]


feelsListForFrontPage : Model -> Html Msg
feelsListForFrontPage model =
    div
        []
        (model.feels
            |> List.sortBy .feltCount
            |> List.reverse
            |> List.take 6
            |> List.map feelItem
        )


feelItem : Feel -> Html Msg
feelItem feel =
    div [ class "col-xs-4" ]
        [ a
            [ class "feel-link"
            , href <| "#/feels/" ++ (feel.name |> String.toLower)
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


viewFeelsShow : Model -> Feel -> Html Msg
viewFeelsShow model feel =
    div
        [ class "container" ]
        [ header model
        , text feel.name
        ]



---- FEELS NEW PAGE ----


viewFeelsNew : Model -> Html Msg
viewFeelsNew model =
    div
        [ class "new-feel container" ]
        [ header model
        , h1
            []
            [ text "Create a New Feel" ]
        , Html.form
            [ onSubmit <| SaveFeel (newFeel 0 model.newFeelEmoji model.newFeelName) ]
            [ div
                [ class "form-group" ]
                [ label
                    [ for "feel-name" ]
                    [ text "What feel do you want to add?" ]
                , input
                    [ autofocus True
                    , class "form-control"
                    , id "feel-name"
                    , onInput InputFeelName
                    , placeholder "Happy"
                    , type_ "text"
                    , value model.newFeelName
                    ]
                    []
                , div
                    [ class "alert alert-danger" ]
                    [ text model.errors.newFeelNameError ]
                ]
            , div
                [ class "form-group" ]
                [ label
                    [ for "feel-emoji" ]
                    [ text "Is there an emoji that properly conveys this feel?" ]
                , input
                    [ class "form-control"
                    , id "feel-emoji"
                    , onInput InputFeelEmoji
                    , placeholder "😎"
                    , type_ "text"
                    , value model.newFeelEmoji
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
            , href "#/feels/new"
            ]
            [ text "Create a Feel" ]
        ]


feelsIndexButton : Html Msg
feelsIndexButton =
    div
        [ class "feels-index-button" ]
        [ a
            [ class "btn btn-lg btn-info"
            , href "#/feels"
            ]
            [ text "List All Feels" ]
        ]


usersIndexButton : Html Msg
usersIndexButton =
    div
        [ class "users-index-button" ]
        [ a
            [ class "btn btn-lg btn-default"
            , href "#/users"
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


viewUsersIndex : Model -> Html Msg
viewUsersIndex model =
    div
        []
        [ header model
        , h2
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


viewUsersShow : User -> Html Msg
viewUsersShow user =
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
            FeelsIndex

        "#/feels/new" ->
            FeelsNew

        "#/users" ->
            UsersIndex

        _ ->
            NotFound


pageToHash : Page -> String
pageToHash page =
    case page of
        Home ->
            "#/"

        FeelsIndex ->
            "#/feels"

        FeelsNew ->
            "#/feels/new"

        FeelsShow feel ->
            "#/feels/" ++ feel.name

        UsersIndex ->
            "#/users"

        NotFound ->
            "#/notfound"


pageView : Model -> Html Msg
pageView model =
    case model.currentPage of
        Home ->
            viewHome model

        FeelsIndex ->
            viewFeelsIndex model

        FeelsNew ->
            viewFeelsNew model

        FeelsShow feel ->
            viewFeelsShow model feel

        UsersIndex ->
            viewUsersIndex model

        _ ->
            viewHome model
