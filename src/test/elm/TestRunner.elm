module TestRunner exposing (..)

import ElmTest exposing (..)
import Example


tests : Test
tests =
    Example.tests


main : Program Never
main =
    runSuiteHtml tests
