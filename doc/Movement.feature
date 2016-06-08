Feature: Standing there looking
    In order to see what's in front of me
    As a player
    I want the walls and enemies in front of me to be drawn correctly

    Scenario: Staring at a wall
        Given I am in a box
        When I turn
        Then I should see a ceiling above me
        Then I should see a wall 0 units in front
        And I should see a wall 0 units to the left
        And I should see a wall 0 units to the right

    Scenario: Turning
        Given I am stationary
        When I turn
        Then I should be moved forward to the next junction in the direction I am facing
        And I should be turned 90 degrees in the direction I turned

    Scenario: Moving and turning
        Given I am moving
        And I turn
        When I reach the next junction in the direction I am moving
        Then I should be turned 90 degrees in the direction I turned

    Scenario: Moving
        Given I am stationary
        When I move
        Then I should start moving in the current direction

    Scenario: Stopping
        Given I am moving
        When I stop moving
        Then I should stop moving
