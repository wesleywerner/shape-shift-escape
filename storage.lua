local storage = {}

function storage.setup (self)

    -- Hook into the slime callbacks
    slime.callback = storage.onCallback
    slime.animationLooped = storage.onAnimationLooped
    
    -- Clear the stage
    slime:reset()

    -- Add the background
    slime:background("images/storage-background.png")
    
    -- Apply the walk-behind layer
    slime:layer("images/storage-background.png", "images/storage-layer.png", 96)
    
    -- Set the floor
    slime:floor("images/storage-floor.png")
    
    slime:hotspot("exit", 32, 59, 70-32, 80-59)
    
    cast:janitor(67, 38)
    cast.ego(50, 73)
    
    local chain = slime:chain()
    chain:func(game.busy)
    chain:move("ego", 60, 46)
    chain:turn("ego", "east")
    
    if game.firstStoreVisit and game.scientistReceivedReport then
        game.firstStoreVisit = false
        chain:say("ego", "Hey, there are no cameras here")
        chain:say("ego", "I can shape shift!")
    end
    
    -- Add the shape-shift triggers
    if game.scientistReceivedReport then
        chain:func(storage.showShapeShiftButtons)
    end
    
    chain:func(game.unbusy)
    
    
end


function storage.onCallback (event, object)

    slime:log(event .. " on " .. object.name)
    
    if (event == "moved" and object.name == "ego") then
        slime:interact(object.clickedX, object.clickedY)
    end
    
    if object.name == "exit" then
        if game.egoshape == "monster" then
            slime:say("ego", "I can't go out there looking like this!")
        else
            game:warp(hallway)
        end
    end
    
    if object.name == "Shape-shift Yourself" then
        shapeshift:toMonster()
    end
    
    if object.name == "Shape-shift Guard" then
        shapeshift:toGuard()
    end
    
    if object.name == "Shape-shift Scientist" then
        shapeshift:toScientist()
    end
    
    
end


function storage.onAnimationLooped (actor, key, counter)
    
    
end


function storage.onMoveTo (self, action, name)
    
    -- skip moving to these items
    local skip = {}
    skip["Shape-shift Yourself"] = true
    skip["Shape-shift Guard"] = true
    skip["Shape-shift Scientist"] = true
    return not skip[name]

end


function storage.showShapeShiftButtons (self)
    cast:scientistButton(130, 30)
    cast:guardButton(150, 30)
    cast:monsterButton(110, 30)
end


return storage