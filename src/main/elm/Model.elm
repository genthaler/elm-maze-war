module Model exposing (Msg(..), Model, Person, MouseMovement, Args, init, direction, eyeLevel, toKeys)

import Math.Vector3 exposing (Vec3, vec3)
import WebGL exposing (..)
import Window
import Time exposing (..)
import Task exposing (Task)
import Keyboard.Extra


{-| Every half a second there's an event coming through;
these are all the valid actions we could receive.
# Move - the user is trying to jump using the space key, move using the arrow keys,
or the window is being resized
# TextureLoaded - a texture has been loaded across the wire
-}
type Msg
    = TextureError Error
    | TextureLoaded Texture
    | KeyboardExtraMsg Keyboard.Extra.Msg
    | MouseMove MouseMovement
    | LockRequest Bool
    | LockUpdate Bool
    | Animate Time
    | Resize Window.Size


type alias Person =
    { position : Vec3
    , velocity : Vec3
    , horizontalAngle : Float
    , verticalAngle : Float
    }


type alias Keys =
    { keyboardModel : Keyboard.Extra.Model
    , spaceKey : Bool
    , wasd : { x : Int, y : Int }
    , keyList : List Keyboard.Extra.Key
    }


type alias PointerLock =
    { wantToBeLocked : Bool
    , isLocked : Bool
    }


{-| This type is returned by the fullscreen JS api in PointerLock.js
for mouse movement.
-}
type alias MouseMovement =
    ( Int, Int )


{-| This is the applications's Model data structure
-}
type alias Model =
    { person : Person
    , keys : Keys
    , pointerLock : PointerLock
    , maybeTexture : Maybe Texture
    , maybeWindowSize : Maybe Window.Size
    , message : String
    }


{-| This is a data structure representing the arguments to Html.programWithFlags
-}
type alias Args =
    { movement : MouseMovement
    , isLocked : Bool
    }


toKeys : Keyboard.Extra.Model -> Keys
toKeys keyboardModel =
    { keyboardModel = keyboardModel
    , spaceKey = Keyboard.Extra.isPressed Keyboard.Extra.Space keyboardModel
    , wasd = Keyboard.Extra.wasd keyboardModel
    , keyList = Keyboard.Extra.pressedDown keyboardModel
    }


{-| When the application first starts, this is initial state of the Model.

Not using the movement attribute of Args at this time;
it's a carryover from the original, and the additional complexity
to actually use it is probably not worth it in this case.
It's still a useful example using Html.programWithFlags though.
-}
init : Args -> ( Model, Cmd Msg )
init { movement, isLocked } =
    let
        ( keyboardModel, keyboardCmd ) =
            Keyboard.Extra.init
    in
        ( { person =
                { position = vec3 0 eyeLevel -10
                , velocity = vec3 0 0 0
                , horizontalAngle = degrees 90
                , verticalAngle = 0
                }
          , keys = toKeys keyboardModel
          , pointerLock =
                { wantToBeLocked = True
                , isLocked = isLocked
                }
          , maybeTexture = Nothing
          , maybeWindowSize = Nothing
          , message = "No texture yet"
          }
        , Cmd.batch
            [ loadTexture "woodCrate.jpg"
                |> Task.perform TextureError TextureLoaded
            , Window.size |> Task.perform (always Resize ( 0, 0 )) Resize
            , Cmd.map KeyboardExtraMsg keyboardCmd
            ]
        )


{-| direction is a derived property of Model.Person.{horizontalAngle, verticalAnglem}

In an OO language, this would probably be implemented as a readonly getter
(i.e. no accompanying setter).
-}
direction : Person -> Vec3
direction person =
    let
        h =
            person.horizontalAngle

        v =
            person.verticalAngle
    in
        vec3 (cos h) (sin v) (sin h)


{-| Constant definition for eyeLevel
-}
eyeLevel : Float
eyeLevel =
    2
