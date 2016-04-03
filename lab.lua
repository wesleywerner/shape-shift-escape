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
    
    lab:moveScientistOne()
    lab:moveScientistThree()
    
end


function lab.onCallback (event, object)

    slime:log(event .. " on " .. object.name)
    
    if (event == "moved" and object.name == "ego") then
        slime:interact(object.clickedX, object.clickedY)
    end
    
    if object.name == "exit" then
        game:warp(hallway)
    end
    
    if object.name == "Knockout Gas" then
        lab:takeBottle()
    end
    
    if object.name == "scientist two" then
        if game.egoshape == "guard" then
            if (game.scientistReceivedReport) then
                slime:say("ego", "Best I don't attract attention.")
            else
                game.scientistReceivedReport = true
                slime:stopActor("ego")
                slime:say("ego", "Scientist Sir...")
                slime:say("scientist two", "What?")
                slime:say("ego", "Err, reporting a near prisoner escape.")
                slime:say("scientist two", "Very well.")
            end
        end
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
    skip["scientist two"] = true
    skip.onlyOnInteractActions = action == "interact"
    return not skip[name]
end


function lab.moveScientistOne ()
    
    if not game.stage == lab then return end
    
    local chain = slime:chain()
    
    chain:wait(5 + math.random(10))
    chain:move("scientist one", 30 + math.random(40), 60)
    chain:anim("scientist one", "look", true)
    chain:say("scientist one", 
        helper:pickone({
        "how curious!",
        "interesting!",
        "fascinating!"
        }))
    chain:move("scientist one", 63, 44)
    chain:turn("scientist one", "south")
    chain:anim("scientist one", "work")
    chain:func(lab.moveScientistOne)

end


function lab.moveScientistThree ()
    
    if not game.stage == lab then return end

    local chain = slime:chain()
    
    chain:wait(5 + math.random(10))
    chain:move("scientist three", 113, 60)
    chain:anim("scientist three", "look", true)
    chain:say("scientist three", 
        helper:pickone({
        "how curious!",
        "interesting!",
        "fascinating!"
    }))
    if (math.random(100) < 5) then
        chain:move("scientist three", 75, 60)
        chain:turn("scientist three", "south")
        chain:wait(2)
    end
    chain:move("scientist three", 124, 44)
    chain:turn("scientist three", "south")
    chain:anim("scientist three", "work")
    chain:func(lab.moveScientistThree)

end


function lab.takeBottle (self)
    
    if game.egoshape == "guard" then
        slime:say("scientist two", "Don't touch that! It is a knockout gas.");
        slime:say("scientist two", "If it drops we will all go unconscious!");
    end
    
    if game.egoshape == "scientist" then
        game.takenKnockoutGas = true
        local item = { ["name"] = "Gas", image = "images/knockout-gas-bottle.png" }
        slime:bagInsert("ego", item)
        slime:removeActor("Knockout Gas")
    end
    
end


return lab