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
        { init = Update.init Ports.ioc
        , update = Update.update Ports.ioc
        , subscriptions = Ports.subscriptions Ports.ioc
        , view = View.view
        }
