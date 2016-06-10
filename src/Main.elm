module Main exposing (main)

import Html.App
import Model
import Ports
import Update
import View


{-| The Elm entrypoint
-}
main : Program Model.Args
main =
    Html.App.programWithFlags
        { init = Update.init
        , update = Update.update
        , subscriptions = Ports.subscriptions
        , view = View.view
        }
