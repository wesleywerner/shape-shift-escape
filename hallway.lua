local hallway = {}

function hallway.setup (self)

    -- Hook into the slime callbacks
    slime.callback = hallway.onCallback
    slime.animationLooped = hallway.onAnimationLooped
    
    game:busy()
    
    -- Clear the stage
    slime:reset()

    -- Add the background
    slime:background("images/hallway-background.png")
    
    -- Apply the walk-behind layer
    slime:layer("images/hallway-background.png", "images/hallway-layer.png", 70)
    
    -- Set the floor
    slime:floor("images/hallway-floor.png")
    
    slime:hotspot("security cameras", 0, 0, 145, 23)
    slime:hotspot("storage", 17, 30, 29-17, 47-30)
    slime:hotspot("lab", 56, 30, 68-56, 47-30)
    slime:hotspot("security", 94, 30, 105-94, 47-30)
    slime:hotspot("exit", 0, 47, 7, 67-47)
    
    if game.lastStage == cell then
        cast.guard(120, 60, "guard")
        cast.ego(160, 60)
        costumes.guard(slime.actors["ego"])
--        local chain = slime:chain()
--        chain:move("guard", {x=99, y=60});
--        chain:move("guard", {x=99, y=46});
--        chain:wait(1)
--        chain:func(slime.removeActor, {slime, "guard"})
--        chain:move("ego", {x=90, y=60})
--        chain:turn("ego", "east")
--        chain:wait(0.3)
--        chain:turn("ego", "west")
--        chain:wait(1)
--        chain:say("ego", "That was close! But I am not out yet...")
--        chain:func(game.unbusy)
game:unbusy()
    end
    
    if game.lastStage == security then
        
--        addCharacter (ego, 100, 45, egoShapeAnim() );
--        moveCharacter (ego, 100, 56);
--        turnCharacter (ego, WEST);
    end
    
    if game.lastStage == lab then
        
--        addCharacter (ego, 62, 46, egoShapeAnim() );
--        moveCharacter (ego, 62, 56);
--        turnCharacter (ego, EAST);
    end
    
    if game.lastStage == storage then
        
--        addCharacter (ego, 23, 46, egoShapeAnim() );
--        moveCharacter (ego, 23, 56);
--        turnCharacter (ego, EAST);
    end
    
    if game.lastStage == exithallway then
        
--        addCharacter (ego, 0, 56, egoShapeAnim() );
--        moveCharacter (ego, 23, 56);
    end

end


function hallway.onCallback (event, object)

    slime:log(event .. " on " .. object.name)
    
    if (event == "moved" and object.name == "ego") then
        slime:interact(object.clickedX, object.clickedY)
    end
    
    if object.name == "security cameras" then
        slime:say("ego", "I can't shape shift while they are watching.")
    end
    
    if object.name == "security" then
        if (game.egoshape == "scientist") then
            slime:say("ego", "Not looking like this, it will be suspicious!")
        else
            slime:log("warping")
            --game:warp(securityroom)
        end
    end
    
    if object.name == "lab" then
        slime:log("warping")
        --game:warp(lab)
    end

    if object.name == "storage" then
        slime:log("warping")
        --game:warp(lab)
    end

    if object.name == "exit" then
        slime:log("warping")
        --game:warp(lab)
    end

end


function hallway.onAnimationLooped (actor, key, counter)
    
    
end


function hallway.onMoveTo (self, action, name)
    
    -- skip moving to these items
    local skip = {}
    skip["security cameras"] = true
    return not skip[name]

end


return hallway