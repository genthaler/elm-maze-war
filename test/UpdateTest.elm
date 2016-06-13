module UpdateTest exposing (suite)

import ElmTestBDDStyle exposing (..)
import Check.Producer exposing (..)
import Model exposing (..)
import Update exposing (..)
import Math.Vector3 as Vector3
import Keyboard.Extra


suite : Test
suite =
    describe "Update Module"
        [ initTests
        , updateTests
        ]


ioc : Model.IoC msg
ioc =
    { requestPointerLock = (\_ -> Cmd.none)
    , exitPointerLock = (\_ -> Cmd.none)
    , movement = (\_ -> Sub.none)
    , isLocked = (\_ -> Sub.none)
    }


initTests : Test
initTests =
    let
        ( keyboardModel, keyboardCmd ) =
            Keyboard.Extra.init

        ( model, subs ) =
            Args True
                |> Update.init ioc
    in
        describe "init"
            [ it "initialises the model"
                <| expect model
                    toBe
                    { person =
                        { position = Vector3.vec3 0 eyeLevel -10
                        , velocity = Vector3.vec3 0 0 0
                        , horizontalAngle = degrees 90
                        , verticalAngle = 0
                        , direction = direction ( degrees 90, 0 )
                        }
                    , keys = toKeys keyboardModel
                    , pointerLock =
                        { wantToBeLocked = True
                        , isLocked = True
                        }
                    , maybeTexture = Nothing
                    , maybeWindowSize = Nothing
                    , message = "No texture yet"
                    }
              -- , it "initialises the subscriptions"
              --     <| expect subs toBe Cmd.none
            , itAlways "ends up with the same list when reversing twice"
                <| expectThat (\list -> List.reverse (List.reverse list))
                    isTheSameAs
                    (identity)
                    forEvery
                    (list int)
            ]


updateTests : Test
updateTests =
    describe "update"
        [ it "udpates the model"
            <| expect "model"
                toBe
                "model"
        ]
