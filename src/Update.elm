module Update exposing (update, init, eyeLevel, toKeys, direction)

import Keyboard.Extra
import Math.Matrix4 as Matrix4
import Math.Vector3 as Vector3
import Model
import Task
import WebGL
import Window


{-| Transforms program arguments into an initial Model.
-}
init : Model.IoC Model.Msg -> Model.Args -> ( Model.Model, Cmd Model.Msg )
init ioc { isLocked } =
    let
        ( keyboardModel, keyboardCmd ) =
            Keyboard.Extra.init
    in
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
            , isLocked = isLocked
            }
        , maybeTexture = Nothing
        , maybeWindowSize = Nothing
        , message = "No texture yet"
        }
            ! [ WebGL.loadTexture "woodCrate.jpg"
                    |> Task.perform Model.TextureError Model.TextureLoaded
              , Window.size
                    |> Task.perform (always Model.Resize ( 0, 0 )) Model.Resize
              , Cmd.map Model.KeyboardExtraMsg keyboardCmd
              ]


{-| Take a Msg and a Model and return an updated Model
-}
update : Model.IoC Model.Msg -> Model.Msg -> Model.Model -> ( Model.Model, Cmd Model.Msg )
update ioc msg model =
    case msg of
        Model.TextureError err ->
            { model | message = "Error loading texture" }
                ! []

        Model.TextureLoaded texture ->
            { model | maybeTexture = Just texture }
                ! []

        Model.KeyboardExtraMsg keyMsg ->
            let
                ( keyboardModel, keyboardCmd ) =
                    Keyboard.Extra.update keyMsg model.keys.keyboardModel
            in
                { model
                    | keys = toKeys keyboardModel
                }
                    ! [ Cmd.map Model.KeyboardExtraMsg keyboardCmd ]

        Model.Resize windowSize ->
            { model | maybeWindowSize = Just windowSize }
                ! []

        Model.MouseMove movement ->
            { model | person = turn movement model.person }
                ! []

        Model.LockRequest wantToBeLocked ->
            let
                pointerLock =
                    model.pointerLock
            in
                { model | pointerLock = { pointerLock | wantToBeLocked = wantToBeLocked } }
                    ! if model.pointerLock.wantToBeLocked == model.pointerLock.isLocked then
                        []
                      else if model.pointerLock.wantToBeLocked then
                        [ ioc.requestPointerLock () ]
                      else
                        [ ioc.exitPointerLock () ]

        Model.LockUpdate isLocked ->
            let
                pointerLock =
                    model.pointerLock
            in
                { model | pointerLock = { pointerLock | isLocked = isLocked } }
                    ! []

        Model.Animate dt ->
            { model
                | person =
                    model.person
                        |> walk model.keys.wasd
                        |> jump model.keys.spaceKey
                        |> gravity (dt / 500)
                        |> physics (dt / 500)
            }
                ! []


toKeys : Keyboard.Extra.Model -> Model.Keys
toKeys keyboardModel =
    { keyboardModel = keyboardModel
    , spaceKey = Keyboard.Extra.isPressed Keyboard.Extra.Space keyboardModel
    , wasd = Keyboard.Extra.wasd keyboardModel
    , keyList = Keyboard.Extra.pressedDown keyboardModel
    }


{-| direction is a derived property of Model.Person.{horizontalAngle, verticalAnglem}

In an OO language, this would probably be implemented as a readonly getter
(i.e. no accompanying setter).
-}
direction : ( Float, Float ) -> Vector3.Vec3
direction ( h, v ) =
    Vector3.vec3 (cos h) (sin v) (sin h)


{-| Constant definition for eyeLevel
-}
eyeLevel : Float
eyeLevel =
    2


flatten : Vector3.Vec3 -> Vector3.Vec3
flatten v =
    let
        r =
            Vector3.toRecord v
    in
        Vector3.normalize (Vector3.vec3 r.x 0 r.z)


turn : Model.MouseMovement -> Model.Person -> Model.Person
turn ( dx, dy ) person =
    let
        horizontalAngle' =
            person.horizontalAngle + toFloat dx / 500

        verticalAngle' =
            person.verticalAngle
                - toFloat dy
                / 500
                |> clamp (degrees -45) (degrees 45)
    in
        { person
            | horizontalAngle = horizontalAngle'
            , verticalAngle = verticalAngle'
            , direction = direction ( horizontalAngle', verticalAngle' )
        }


walk : { x : Int, y : Int } -> Model.Person -> Model.Person
walk directions person =
    if Vector3.getY person.position > eyeLevel then
        person
    else
        let
            moveDir =
                Vector3.normalize (flatten person.direction)

            strafeDir =
                Matrix4.transform (Matrix4.makeRotate (degrees -90) Vector3.j) moveDir

            move =
                Vector3.scale (toFloat directions.y) moveDir

            strafe =
                Vector3.scale (toFloat directions.x) strafeDir
        in
            { person | velocity = adjustVelocity (move `Vector3.add` strafe) }


adjustVelocity : Vector3.Vec3 -> Vector3.Vec3
adjustVelocity v =
    case Vector3.toTuple v of
        ( 0, 0, 0 ) ->
            v

        _ ->
            Vector3.scale 2 (Vector3.normalize v)


jump : Bool -> Model.Person -> Model.Person
jump isJumping person =
    if not isJumping || Vector3.getY person.position > eyeLevel then
        person
    else
        let
            v =
                Vector3.toRecord person.velocity
        in
            { person | velocity = Vector3.vec3 v.x 2 v.z }


physics : Float -> Model.Person -> Model.Person
physics dt person =
    let
        position =
            person.position `Vector3.add` Vector3.scale dt person.velocity

        p =
            Vector3.toRecord position

        position' =
            if p.y < eyeLevel then
                Vector3.vec3 p.x eyeLevel p.z
            else
                position
    in
        { person | position = position' }


gravity : Float -> Model.Person -> Model.Person
gravity dt person =
    if Vector3.getY person.position <= eyeLevel then
        person
    else
        let
            v =
                Vector3.toRecord person.velocity
        in
            { person | velocity = Vector3.vec3 v.x (v.y - 2 * dt) v.z }
