port module Ports exposing (ioc)

{-| Collect all ports and subscriptions into their own module.
This is mostly to avoid circular references between Main, Update and View,
but is also a nice abstraction
-}

import AnimationFrame
import Keyboard.Extra
import Model
import Mouse
import Window
import AnimationFrame
import Keyboard.Extra
import Model
import Mouse
import Task
import WebGL


{-| Provide the ability to request fullscreen mode. Click screen to request lock.
-}
port requestPointerLock : () -> Cmd msg


{-| Provide the ability to exit fullscreen mode. Press escape to give up the lock.
-}
port exitPointerLock : () -> Cmd msg


{-| The user is moving the mouse while in fullscreen mode
-}
port movement : (( Int, Int ) -> msg) -> Sub msg


{-| The user is entering/leaving fullscreen mode
-}
port isLocked : (Bool -> msg) -> Sub msg


{-| All ports are encapsulated here, mostly to enable mocking elsewhere
-}
ioc : Model.IoC Model.Msg
ioc =
    Model.IoC requestPointerLock exitPointerLock movement isLocked initCmds


{-| All subscriptions are defined here
-}
subscriptions : Model.IoC Model.Msg -> Model.Model -> Sub Model.Msg
subscriptions ioc model =
    [ AnimationFrame.diffs Model.Animate
    , Sub.map Model.KeyboardExtraMsg Keyboard.Extra.subscriptions
    , Window.resizes Model.Resize
    , ioc.isLocked Model.LockUpdate
    ]
        ++ (if model.pointerLock.isLocked then
                [ ioc.movement Model.MouseMove ]
            else
                [ Mouse.clicks (\_ -> Model.LockRequest True) ]
           )
        |> Sub.batch


initCmds : Cmd Keyboard.Extra.Msg -> List (Cmd Model.Msg)
initCmds keyboardCmd =
    [ WebGL.loadTexture "woodCrate.jpg"
        |> Task.perform Model.TextureError Model.TextureLoaded
    , Window.size
        |> Task.perform (always Model.Resize ( 0, 0 )) Model.Resize
    , Cmd.map Model.KeyboardExtraMsg keyboardCmd
    ]
