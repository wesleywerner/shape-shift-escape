local lab = {}

function lab.setup (self)

    -- Hook into the slime callbacks
    slime.callback = lab.onCallback
    slime.animationLooped = lab.onAnimationLooped
    
    -- Clear the stage
    slime:reset()

    -- Add the background
    slime:background("images/lab-background.png")
    
    -- Apply the walk-behind layer
    slime:layer("images/lab-background.png", "images/lab-layer-bench.png", 75)--75
    slime:layer("images/lab-background.png", "images/lab-layer-desks.png", 46)
    slime:layer("images/lab-background.png", "images/lab-layer-door.png", 52)
    
    -- Set the floor
    slime:floor("images/lab-floor.png")
    
    slime:hotspot("exit", 1, 34, 30, 52-34)
    
    local glassware = slime:actor("lab equipment", 70, 67)
    local tileset = glassware:tileset("images/lab-equipment.png", {w=115, h=14})
    tileset:define("bubble"):frames({'1-4', 1}):delays(0.3)
    slime:setAnimation("lab equipment", "bubble")
    glassware.nozbuffer = true
    
    if not game.takenKnockoutGas then
        local gas = slime:actor("Knockout Gas", 80, 28)
        gas:setImage("images/knockout-gas-bottle.png")
    end
    
    -- scientist one
    cast.scientist(63, 44, "scientist one")
    
    -- scientist two
    cast.scientist(93, 44, "scientist two")
    
    -- scientist three
    cast.scientist(124, 44, "scientist three")
    
    slime:setAnimation("scientist one", "work")
    slime:setAnimation("scientist two", "work")
    slime:setAnimation("scientist three", "look")
    
    -- Add our main actor
    cast.ego(14, 46)
    slime:moveActor("ego", 36, 46)
    
end


function lab.onCallback (event, object)

    slime:log(event .. " on " .. object.name)
    
    if (event == "moved" and object.name == "ego") then
        slime:interact(object.clickedX, object.clickedY)
    end
    
end


function lab.onAnimationLooped (actor, key, counter)
    
    --slime:log("anim loop " .. actor .. " " .. key .. " " .. tostring(counter))
    
    if string.sub(actor, 1, 9) == "scientist" then
        -- alternate between working and looking around
        if key == "look" and counter == 2 then
            slime:setAnimation(actor, "work")
        end
        if key == "work" then
            slime:setAnimation(actor, "look")
        end
    end
    
    
end


function lab.onMoveTo (self, action, name)
    -- skip moving to these items
    local skip = {}
    skip.actorOrHotspotName = true
    skip.onlyOnInteractActions = action == "interact"
    return not skip[name]
end


function lab.moveScientistOne (self)
    
--    while (currentRoom == labRoom)
--    {
--        pause (200);
--        moveCharacter (scientistOne, 46, 60);
--        pause (50);
--        if (somethingSpeaking () == NULL)
--        {
--            say (scientistOne, pickOne (
--                "how curious!",
--                "interesting!",
--                "fascinating!"
--                ) );
--        }
--        moveCharacter (scientistOne, 63, 44);
--        turnCharacter (scientistOne, SOUTH);
--        animate (scientistOne, scientistWorkAnim() );
--    }

end


function lab.moveScientistThree (self)
    
--    while (currentRoom == labRoom)
--    {
--        moveCharacter (scientistThree, 113, 60);
--        pause (45);
--        if (somethingSpeaking () == NULL)
--        {
--            say (scientistThree, pickOne (
--                "how curious!",
--                "interesting!",
--                "fascinating!"
--                ) );
--        }
--        moveCharacter (scientistThree, 60, 60);
--        turnCharacter (scientistThree, SOUTH);
--        pause (75);
--        moveCharacter (scientistThree, 124, 44);
--        turnCharacter (scientistThree, SOUTH);
--        animate (scientistThree, scientistWorkAnim() );
--        pause (450);
--    }

end


return lab