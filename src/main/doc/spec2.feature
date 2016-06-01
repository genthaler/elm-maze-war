Feature: Standing there looking
    In order to see what's in front of me
    As a player
    I want the walls and enemies in front of me to be drawn correctly

    Scenario: Starting a game
        Given the game has just started
        And there are no players
        Then I should see the ground and walls in front of me

    Scenario: shooting
        Given the game has started
        When I shoot a bullet
        Then the bullet should move in a straight line until it hits a wall or a player

    Scenario: shot a wall
        Given A bullet has been shot
        When the bullet hits a wall
        Then the bullet will explode
