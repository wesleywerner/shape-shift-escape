local exithallway = {}

function exithallway.setup (self)

    -- Hook into the slime callbacks
    slime.callback = exithallway.onCallback
    slime.animationLooped = exithallway.onAnimationLooped
    
    -- Clear the stage
    slime:reset()

    -- Add the background
    slime:background("images/exit-background.png")
    
    -- Apply the walk-behind layer
    slime:layer("images/exit-background.png", "images/exit-layer-shade.png", 96)
    slime:layer("images/exit-background.png", "images/exit-layer-wall.png", 62)
    
    -- Set the floor
    slime:floor("images/exit-floor-closed.png")
    
    slime:hotspot("Hallway", 76, 47, 110-76, 69-47)
    slime:hotspot("Security panel", 11, 47, 17-11, 58-47)
    
    cast:door(24, 55, "door")
    cast.ego(86, 57)
    
    slime:moveActor("ego", 35, 57)
    
end


function exithallway.onCallback (event, object)

    slime:log(event .. " on " .. object.name)
    
    if (event == "moved" and object.name == "ego") then
        slime:interact(object.clickedX, object.clickedY)
    end
    
    if object.name == "Security panel" then
        if event == "interact" then
            slime:say("ego", "I need to steal a security pass to get out")
        end
        if event == "security card" then
            exithallway:openDoor()
        end
    end
    
    if object.name == "Hallway" then
        game:warp(hallway)
    end
    
    
end


function exithallway.onAnimationLooped (actor, key, counter)
    
    if actor == "door" then
        
        -- Keep the door closed after the closing animation played.
        if key == "closing" then
            slime:setAnimation("door", "closed")
        end
        
        -- Keep the door open after the opening animation played.
        if key == "opening" then
            slime:setAnimation("door", "open")
        end
        
    end   
    
end


function exithallway.onMoveTo (self, action, name)
    
    -- skip moving to these items
    local skip = {}
    skip["Security panel"] = true
    skip.onlyOnInteractActions = action == "interact"
    return not skip[name]

end


function exithallway.openDoor (self)
    -- clear bag
    slime.bagButtons = { }
    game:busy()
    slime:setCursor()
    local chain = slime:chain()
    chain:move("ego", "door")
    -- open door
    chain:image("light", "images/cell-light-green.png")
    chain:sound("sounds/unlock.wav")
    chain:wait(1)
    chain:anim("door", "opening")
    chain:floor("images/exit-floor-open.png")
    chain:move("ego", 35, 57)
    chain:turn("ego", "west")
    chain:func(shapeshift.toMonster)
    chain:wait(2)
    chain:say("ego", "Freedom!")
    chain:move("ego", 1, 57)
    -- close cell door
    chain:floor("images/cell-floor-closed.png")
    chain:anim("door", "closing", true)
    chain:image("light", "images/cell-light-red.png")
    chain:sound("sounds/unlock.wav")
    -- done
    chain:wait(4)
    chain:func(game.warp, {game, win})
    
end



return exithallway