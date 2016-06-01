# Implementation plan

I'm going to map the whole thing as a snake of rooms.

I'll basically expand the crate and place us inside it, and selectively remove walls.

Further down the track I can just create a Model for everything, then have logic to work out which walls I can possibly see at any given time.

The Model is essentially a maze, position and orientation and a {Matrix4, Position (x,y), Orientation (NSEW)}

The events are WASD + space for shoot.

The hardest thing at the moment is probably the maze; this could be static (the same maze all the time, probably ripped off the original game), or dynamically generated e.g. [Eller's algorithm]()

Actually, having looked at some actual mazes, we don't really want mazes since they tend to be single solution. What we want is instead more of a labyrinth, with multiple paths to any given place, and no actual in and out.

I've had a look at Super Maze Wars, have the game playable, and have some screenshots of at least some of the maps.

I'd originally been thinking that I'd implement the original MazeWars, but I don't have a copy of it and my recollection of the gameplay is a bit sketchy... Should probably try [Maze Wars SVG]

So I could approach this a free-form movement game around obstacles, since I already have a template for that from first-person-start-app.elm. This will probably require better collision detection though, at least at some point

## So, decision point:

### use Super Maze War as the template

Follow a fixed path around the world. The game will basically put you onto a node from which you can turn or whatever. It's still mostly real-time though.

Pros:

- Familiar
- Closer to original aims
- I have Super Maze Wars to compare it to
- Don't have to implement collision detection, at least for walls

### use first-person-elm as the template

You can go where you like, and implement collision detection so you don't go through walls.

Pros:

- More free-form
- Have existing code from first-person-elm to work from in terms of free movement

## Tasks:
- Implement npm & gulp
- Implement submodules
- Implement test with relative path for fast reload
- Implement integration test with local install of main package
- Implement DI
- Test everything
- Work out how to test WebGL (image comparison?)

[maze wars svg]: (http://mazewarssvg.sourceforge.net/)
