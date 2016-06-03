Feature: Bumping into things
    In order to not walk through walls
    As a player
    I want walls and players to stop me moving

    Scenario: Staring at a wall
        Given I am facing a wall
        When I try to move forward
        Then I should not move

    Scenario: Hitting a wall
        Given I am moving perpendicularly towards a wall
        When I collide with the wall
        Then I should stop moving

    Scenario: Hitting a player
        Given I am moving toward a stationary player
        When I collide with the player
        Then I should stop moving
