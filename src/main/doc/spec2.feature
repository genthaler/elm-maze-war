Feature: Standing there looking
    In order to see what's in front of me
    As a player
    I want the walls and enemies in front of me to be drawn correctly

    Scenario: Starting a game
        Given the game has just started
        And there are no players
        Then I should see the ground and at least one wall in front of me

    Scenario: shooting
        Given the game has started
        When I shoot a bullet
        Then the bullet should move in a straight line until it hits a wall or a player

    Scenario: shot a wall
        Given A bullet has been shot
        When the bullet hits a wall
        Then the bullet will explode

    Scenario: Shot a player
        Given I shot a bullet
        When the bullet hits another player
        Then the player should die
        And respawn later

    Scenario: I'm shot
        Given a player shot a bullet
        When the bullet hits me
        Then I should die
        And respawn later
