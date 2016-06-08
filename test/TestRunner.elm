module TestRunner exposing (..)

import ElmTest exposing (..)
import Example


tests : Test
tests =
    Example.tests



-- This version emits test results as HTML
-- main : Program Never
-- main =
--     runSuiteHtml tests
-- This version runs at the console and returns a non-zero exit code on test failure


main : Program Never
main =
    runSuite tests
