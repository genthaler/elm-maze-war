Feature: Standing there looking
    In order to see what's in front of me
    As a player
    I want the walls and enemies in front of me to be drawn correctly

    Scenario: Shooting
        Given A player shoots
        Then a new bullet should move in the direction the player is currently facing

    Scenario: Wall shot
        Given A bullet has been shot
        When the bullet hits a wall
        Then the bullet will explode

    Scenario: Player shot
        Given I shot a bullet
        When the bullet hits another player
        Then the player should die
        And respawn later

    Scenario: I'm shot
        Given a player shot a bullet
        When the bullet hits me
        Then I should die
        And respawn later
