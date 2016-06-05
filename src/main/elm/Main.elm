module Main exposing (main)

import Model
import Update
import View
import Ports
import AnimationFrame
import Keyboard.Extra
import Window
import Html.App as Html
import Mouse


{-| The Elm entrypoint
-}
main : Program Model.Args
main =
    Html.programWithFlags
        { init = Model.init
        , update = Update.update
        , subscriptions = subscriptions
        , view = View.view
        }


subscriptions : Model.Model -> Sub Model.Msg
subscriptions model =
    [ AnimationFrame.diffs Model.Animate
    , Sub.map Model.KeyboardExtraMsg Keyboard.Extra.subscriptions
    , Window.resizes Model.Resize
    , Ports.isLocked Model.LockUpdate
    ]
        ++ (if model.pointerLock.isLocked then
                [ Ports.movement Model.MouseMove ]
            else
                [ Mouse.clicks (\_ -> Model.LockRequest True) ]
           )
        |> Sub.batch
