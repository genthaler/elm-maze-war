module TestRunner exposing (..)

import ElmTestBDDStyle exposing (..)
import ElmTest exposing (runSuite, runSuiteHtml)
import UpdateTest


tests : Test
tests =
    describe "Elm Maze War"
        [ UpdateTest.suite ]



-- This version emits test results as HTML


main : Program Never
main =
    runSuiteHtml tests



-- This version runs at the console and returns a non-zero exit code on test failure
-- main : Program Never
-- main =
--     runSuite tests
