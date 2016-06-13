module UpdateTest exposing (tests)

import ElmTestBDDStyle exposing (..)
import Check.Producer exposing (..)
import Model exposing (..)
import Update exposing (..)


ioc : Model.IoC msg
ioc =
    { requestPointerLock = (\_ -> Cmd.none)
    , exitPointerLock = (\_ -> Cmd.none)
    , movement = (\_ -> Sub.none)
    , isLocked = (\_ -> Sub.none)
    }


tests : Test
tests =
    describe "Update Module Test Suite"
        [ it "initialises the model"
            <| expect Update.init ioc (Args True) toBe ( {}, Cmd.none )
        , it "fails for non-sense stuff"
            <| expect True toBe False
        , itAlways "ends up with the same list when reversing twice"
            <| expectThat (\list -> List.reverse (List.reverse list))
                isTheSameAs
                (identity)
                forEvery
                (list int)
        ]
