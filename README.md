# COOLCATS - GMTK 2022
<hr />
Ocean-voyage exploration game where rolling dice on unexplored tiles determines what you find there and how to resolve events. Pick up relics and such to change how dice behave and find El Do-rando by rolling 6 6s

## start game
you are a ship with a crew, supplies counter

## Turn Phases
### phase 1
    exploration phase
    click the explore button to roll exploration dice. determines how far you go along the route to next port.
### phase 2
    navigation phase
    zoom in on the crows nest, crew member pops up to view potential places to go
    options are rolled on massive table of where you can take the ship this phase.
    options have a variable cost from dice rolls
    there are always at least one or two negative, dangerous options which do not have a cost. the positive, beneficial or safe options are costly.
    you can select from your crew members to roll for navigation. crew members can provide unique die relating to their skills which may help unlock certain options or alternate aspects of options.
    common negative options for example, might be able to become safe or benificial due to the presense of a specific skilled crew member or relic.
    or you can save crew member rolls for later phases.
    after rolling dice, it goes into the pool for the phase, where they can be edited by relics
    might consider saving crew die for the event phase, you never know when you'll need them
    select the option an undergo the consequences of the event
    
### phase 3
    event resolution
    
### phase 4
    relic phase
    roll all your relics, their effects engage based on the rolls from their respective tables


## Ports
the roll on exploration determines how far along the route you travel. the distance between ports increases each time.
ports replenish your supplies.
you may spend (some kind of limited resource) on upgrading: max supply, purchasing a new crew member, improving your ships hull & armaments



## events
depending on the event that comes up as a result of exploration, you will be prompted with consequences, decisions, skill checks or chance rolls
these may deplete supplies, damage ship, affect crew, or something else of the like

### Sample Event Definition
```json
{
    "name": "Is that... Singing?",
    "description": "The whistling of the ocean breeze carries a haunting melody. After a moment, the lookout spots a small islet port-ward."
    "options": [
        {
            "text": "Stay the course and put the wail out of your mind",
            "result": {
                "text": "The crew mutters at their work and tempers are high until the wailing falls out of earshot",
                "reward": [{"resource": "morale", "value": -1}]
            }
        },
        {
            "text": "Send a crew to investigate",
            "cost": [{"resource": "crew", "value": 1}]
            "result": {
                "text": "The sun falls below the horizon before the dinghy makes it back to the ship. The crew is gone, in their place a bright white bird's skull scoured clean by the salt water.",
                "reward": [{"resource": "relic_4", "value": 1}]
            }
        }, 
    ]
}

```
