module Model exposing (Msg(..), Model, Person, MouseMovement, Args, Keys)

import Math.Vector3 as Vector3
import Window
import Time
import Keyboard.Extra
import WebGL


{-| Every half a second there's an event coming through;
these are all the valid actions we could receive.
# Move - the user is trying to jump using the space key, move using the arrow keys,
or the window is being resized
# TextureLoaded - a texture has been loaded across the wire
-}
type Msg
    = TextureError WebGL.Error
    | TextureLoaded WebGL.Texture
    | KeyboardExtraMsg Keyboard.Extra.Msg
    | MouseMove MouseMovement
    | LockRequest Bool
    | LockUpdate Bool
    | Animate Time.Time
    | Resize Window.Size


{-| Holds information about a player relative to the world
-}
type alias Person =
    { position : Vector3.Vec3
    , velocity : Vector3.Vec3
    , horizontalAngle : Float
    , verticalAngle : Float
    , direction : Vector3.Vec3
    }


type alias Keys =
    { keyboardModel : Keyboard.Extra.Model
    , spaceKey : Bool
    , wasd : { x : Int, y : Int }
    , keyList : List Keyboard.Extra.Key
    }


{-| This type is used to store intention and status of fullscreen pointerlock
functionality.
-}
type alias PointerLock =
    { wantToBeLocked : Bool
    , isLocked : Bool
    }


{-| This type is returned by the fullscreen JS api in PointerLock.js
for mouse movement.
-}
type alias MouseMovement =
    ( Int, Int )


{-| This is the applications's Model data structure.
-}
type alias Model =
    { person : Person
    , keys : Keys
    , pointerLock : PointerLock
    , maybeTexture : Maybe WebGL.Texture
    , maybeWindowSize : Maybe Window.Size
    , message : String
    }


{-| This is a data structure representing the arguments to Html.programWithFlags.
-}
type alias Args =
    { movement : MouseMovement
    , isLocked : Bool
    }
