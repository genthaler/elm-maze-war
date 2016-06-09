module Main exposing (main)

import Model
import Update
import View
import Ports
import Html.App


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
