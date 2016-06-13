module TestRunner exposing (..)

import ElmTest exposing (..)
import Example
import UpdateTest
import ViewTest


tests : Test
tests =
    UpdateTest.tests



-- This version emits test results as HTML


main : Program Never
main =
    runSuiteHtml tests



-- This version runs at the console and returns a non-zero exit code on test failure
-- main : Program Never
-- main =
--     runSuite tests
