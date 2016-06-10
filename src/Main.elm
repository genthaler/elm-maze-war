module Main exposing (main)

import Html.App
import Model
import IO
import Update
import View


{-| The Elm entrypoint
-}
main : Program Model.Args
main =
    Html.App.programWithFlags
        { init = Update.init IO.ioc
        , update = Update.update IO.ioc
        , subscriptions = IO.subscriptions
        , view = View.view
        }
