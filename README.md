# Feelbot

Feelbot is here to help.

![Feels Index Page](https://github.com/ElmOrlando/Feelbot/blob/master/assets/static/images/feels-index-page.png?raw=true)

## What Is Feelbot?

Feelbot is like Stack Overflow for developer feelings. It's a simple list of
common emotions that developers naturally tend to experience along with ideas
and suggestions for constructively working with those emotions.

Each "feel" has a set of user-generated "ideas" associated with it. These
suggestions can be voted up or down so that particularly relevant or strong
ideas appear at the top.

![Feels Show Page](https://github.com/ElmOrlando/Feelbot/blob/master/assets/static/images/feels-show-page.png?raw=true)

## Why?

The intention is that we'd have somewhere to point people when they inevitably
experience some difficulties in their development. Admittedly, this isn't going
to "solve" everyone's problems and it's not intended to lessen the emotions we
experience, it's just meant to provide _somewhere_ to go and get some tangible
help when it's needed.

## Want to Contribute?

- **Ideas:** Have ideas for how this should work? Create a
  [GitHub Issue](https://github.com/ElmOrlando/Feelbot/issues)!
- **Front-end:** To help with the Elm front-end, check out the `Main.elm` file
  in the `assets/elm` folder. This file is automatically compiled and rendered
  as the home page.
- **Back-end:** The back-end is currently built with the
  [Phoenix](http://www.phoenixframework.org/) framework.
- **Styles:** Feel free to add CSS to the `assets/css/app.css` file to help out
  with styling.

## What Can I Help With?

- **Authentication:** Consider using
  [Auth0](https://auth0.com/blog/creating-your-first-elm-app-part-1/) to build
  the authentication features? Or use Phoenix Guardian and Ueberauth?
- **Data Store:** Want to use RethinkDB? Firebase? PostgreSQL and Phoenix?
- **Routing:** Consider checking out the elm
  [Navigation](https://github.com/elm-lang/navigation) package so we could have
  direct URLs for feels.
- **Styles:** Phoenix comes with Bootstrap by default, but feel free to try out
  [`elm-mdl`](https://github.com/debois/elm-mdl) or toss some custom CSS.

## Ideas

- **Slack Integration:** Use slash commands in Slack to hook in Feelbot
  suggestions.
