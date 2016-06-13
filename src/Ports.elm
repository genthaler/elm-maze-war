port module Ports exposing (ioc)

{-| Collect all ports and subscriptions into their own module.
This is mostly to avoid circular references between Main, Update and View,
but is also a nice abstraction
-}

import Model


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


ioc : Model.IoC msg
ioc =
    Model.IoC requestPointerLock exitPointerLock movement isLocked
