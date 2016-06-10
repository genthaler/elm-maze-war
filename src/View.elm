module View exposing (view)

import Html
import Html.Attributes as Attributes
import Math.Matrix4 as Matrix4
import Math.Vector3 as Vector3
import Model
import View.Ground
import View.Wall
import WebGL
import Window


{-| generate a View from a Model
-}
view : Model.Model -> Html.Html Model.Msg
view { person, maybeWindowSize, maybeTexture, pointerLock } =
    case ( maybeWindowSize, maybeTexture ) of
        ( Nothing, _ ) ->
            Html.text ""

        ( _, Nothing ) ->
            Html.text ""

        ( Just windowSize, Just texture ) ->
            layoutScene windowSize pointerLock.isLocked texture person


layoutScene : Window.Size -> Bool -> WebGL.Texture -> Model.Person -> Html.Html Model.Msg
layoutScene windowSize isLocked texture person =
    Html.div
        [ Attributes.style
            [ ( "width", toString Attributes.width ++ "px" )
            , ( "height", toString Attributes.height ++ "px" )
            , ( "position", "relative" )
            , ( "backgroundColor", "rgb(135, 206, 235)" )
            ]
        ]
        [ WebGL.toHtml [ Attributes.width windowSize.width, Attributes.height windowSize.height, Attributes.style [ ( "display", "block" ) ] ]
            (renderWorld texture (perspective windowSize person))
        , Html.div
            [ Attributes.style
                [ ( "position", "absolute" )
                , ( "font-family", "monospace" )
                , ( "text-align", "center" )
                , ( "left", "20px" )
                , ( "right", "20px" )
                , ( "top", "20px" )
                ]
            ]
            (if isLocked then
                exitMsg
             else
                enterMsg
            )
        ]


{-| Set up 3D world
-}
renderWorld : WebGL.Texture -> Matrix4.Mat4 -> List WebGL.Renderable
renderWorld texture perspective =
    let
        renderedCrates =
            [ View.Wall.renderWall texture perspective
            , View.Wall.renderWall texture (Matrix4.translate3 10 0 10 perspective)
            , View.Wall.renderWall texture (Matrix4.translate3 -10 0 -10 perspective)
            ]
    in
        (View.Ground.renderGround perspective) :: renderedCrates


{-| Calculate the viewers field of view.
-}
perspective : Window.Size -> Model.Person -> Matrix4.Mat4
perspective { width, height } person =
    Matrix4.mul (Matrix4.makePerspective 45 (toFloat width / toFloat height) 1.0e-2 100)
        (Matrix4.makeLookAt person.position (person.position `Vector3.add` person.direction) Vector3.j)


enterMsg : List (Html.Html Model.Msg)
enterMsg =
    message "Click to go full screen and move your head with the mouse."


exitMsg : List (Html.Html Model.Msg)
exitMsg =
    message "Press <escape> to exit full screen."


message : String -> List (Html.Html Model.Msg)
message msg =
    [ Html.p [] [ Html.text "This uses stuff that is only available in Chrome and Firefox!" ]
    , Html.p [] [ Html.text "WASD keys to move, space bar to jump." ]
    , Html.p [] [ Html.text msg ]
    ]
