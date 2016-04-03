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
        local chain = slime:chain()
        chain:move("guard", 99, 60);
        chain:move("guard", 99, 46);
        chain:wait(1)
        chain:func(slime.removeActor, {slime, "guard"})
        chain:move("ego", 90, 60)
        chain:turn("ego", "east")
        chain:wait(0.3)
        chain:turn("ego", "west")
        chain:wait(1)
        chain:say("ego", "That was close! But I am not out yet...")
        chain:func(game.unbusy)
    end
    
    if game.lastStage == security then
        cast.ego(100, 45)
        slime:moveActor("ego", 100, 56)
    end
    
    if game.lastStage == lab then
        cast.ego(62, 46)
        slime:moveActor("ego", 62, 56)
    end
    
    if game.lastStage == storage then
        cast.ego(23, 46)
        slime:moveActor("ego", 23, 56)
    end
    
    if game.lastStage == exithallway then
        cast.ego(10, 56)
        slime:moveActor("ego", 23, 56)
    end

    game:unbusy()

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
            game:warp(security)
        end
    end
    
    if object.name == "lab" then
        slime:log("warping")
        game:warp(lab)
    end

    if object.name == "storage" then
        slime:log("warping")
        game:warp(storage)
    end

    if object.name == "exit" then
        slime:log("warping")
        game:warp(exithallway)
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