port module Ports exposing (..)

{-| Collect all ports and subscriptions into their own module.
This is mostly to avoid circular references between Main, Update and View,
but is also a nice abstraction
-}

import Model
import AnimationFrame
import Keyboard.Extra
import Window
import Mouse


{-| Provide the ability to request fullscreen mode. Click screen to request lock.
-}
port requestPointerLock : () -> Cmd msg


{-| Provide the ability to request and exit fullscreen mode.
Click screen to request lock. Press escape to give up the lock.
-}
port exitPointerLock : () -> Cmd msg


{-| The user is moving the mouse while in fullscreen mode
-}
port movement : (( Int, Int ) -> msg) -> Sub msg


{-| The user is entering/leaving fullscreen mode
-}
port isLocked : (Bool -> msg) -> Sub msg


{-| All subscriptions are defined here
-}
subscriptions : Model.Model -> Sub Model.Msg
subscriptions model =
    [ AnimationFrame.diffs Model.Animate
    , Sub.map Model.KeyboardExtraMsg Keyboard.Extra.subscriptions
    , Window.resizes Model.Resize
    , isLocked Model.LockUpdate
    ]
        ++ (if model.pointerLock.isLocked then
                [ movement Model.MouseMove ]
            else
                [ Mouse.clicks (\_ -> Model.LockRequest True) ]
           )
        |> Sub.batch
