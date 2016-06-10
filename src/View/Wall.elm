module View.Wall exposing (renderWall)

import Math.Vector2 as Vector2
import Math.Vector3 as Vector3
import Math.Matrix4 as Matrix4
import WebGL


{-| Render the visible renderCrate
-}
renderWall : WebGL.Texture -> Matrix4.Mat4 -> WebGL.Renderable
renderWall texture perspective =
    -- WebGL.render vertexShader fragmentShader wall { perspective = perspective }
    WebGL.render vertexShader fragmentShader wall { wall = texture, perspective = perspective }


{-| Describes properties of a Crate vertex
-}
type alias Vertex =
    { position : Vector3.Vec3, coord : Vector3.Vec3 }


{-| Describes a wall as a WebGL.Drawable
-}
wall : WebGL.Drawable Vertex
wall =
    WebGL.Triangle (List.concatMap rotatedFace [ ( 0, 0 ), ( 90, 0 ), ( 180, 0 ), ( 270, 0 ), ( 0, 90 ), ( 0, -90 ) ])


{-| Rotate a wall face
-}
rotatedFace : ( Float, Float ) -> List ( Vertex, Vertex, Vertex )
rotatedFace ( angleXZ, angleYZ ) =
    let
        x =
            Matrix4.makeRotate (degrees angleXZ) Vector3.j

        y =
            Matrix4.makeRotate (degrees angleYZ) Vector3.i

        t =
            x `Matrix4.mul` y

        each f ( a, b, c ) =
            ( f a, f b, f c )
    in
        List.map (each (\v -> { v | position = Matrix4.transform t v.position })) face


{-| Constant function describing the faces of a generic wall
-}
face : List ( Vertex, Vertex, Vertex )
face =
    let
        topLeft =
            Vertex (Vector3.vec3 -1 1 1) (Vector3.vec3 0 1 0)

        topRight =
            Vertex (Vector3.vec3 1 1 1) (Vector3.vec3 1 1 0)

        bottomLeft =
            Vertex (Vector3.vec3 -1 -1 1) (Vector3.vec3 0 0 0)

        bottomRight =
            Vertex (Vector3.vec3 1 -1 1) (Vector3.vec3 1 0 0)
    in
        [ ( topLeft, topRight, bottomLeft )
        , ( bottomLeft, topRight, bottomRight )
        ]


{-| Vertex shader for crates
-}
vertexShader : WebGL.Shader { position : Vector3.Vec3, coord : Vector3.Vec3 } { u | perspective : Matrix4.Mat4 } { vcoord : Vector2.Vec2 }
vertexShader =
    [glsl|

attribute vec3 position;
attribute vec3 coord;
uniform mat4 perspective;
varying vec2 vcoord;

void main () {
  gl_Position = perspective * vec4(position, 1.0);
  vcoord = coord.xy;
}

|]


{-| Fragment shader for crates
-}
fragmentShader : WebGL.Shader {} { u | wall : WebGL.Texture } { vcoord : Vector2.Vec2 }
fragmentShader =
    [glsl|

precision mediump float;
uniform sampler2D wall;
varying vec2 vcoord;

void main () {
  gl_FragColor = texture2D(wall, vcoord);
}

|]
