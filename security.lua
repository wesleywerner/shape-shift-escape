local security = {}


function security.setup (self)

    -- Hook into the slime callbacks
    slime.callback = security.onCallback
    slime.animationLooped = security.onAnimationLooped
    
    -- Clear the stage
    slime:reset()

    -- Add the background
    slime:background("images/security-background.png")
    
    -- Apply the walk-behind layer
    slime:layer("images/security-background.png", "images/security-layer.png", 96)
    
    -- Set the floor
    slime:floor("images/security-floor.png")
    
    -- Hotspots
    slime:hotspot("exit", 88, 79, 122-88, 95-79)
    slime:hotspot("Meta-security cameras", 77, 9, 120-77, 12)
    slime:hotspot("bulletin board", 69, 22, 105-69, 31-22)
    cast.securitymonitor(118, 19, "pong")
    cast.securitymonitor(128, 28, "rooms")
    cast.securitymonitor(138, 37, "text")
    cast.securitypass(65, 28)
    
    if game.scientistReceivedReport then
        cast.spiltcoffee(134, 58)
    else
        cast.coffee(132, 55)
    end
    
    cast.guard(107, 46, "busy guard")
    slime:turnActor("busy guard", "east")
    
    cast.guard(120, 61, "lazy guard")
    slime:turnActor("lazy guard", "east")
    
    if game.guardsKnockedOut then
        costumes.guardUnconscious(slime.actors["busy guard"])
        costumes.guardUnconscious(slime.actors["lazy guard"])
    end

    cast.ego(103, 91)
    slime:moveActor("ego", 103, 69)
    
    security.moveGuardInSecurityRoom()
    security.guardSaysRandomThing()
    
end


function security.onCallback (event, object)

    slime:log(event .. " on " .. object.name)
    
    if (event == "moved" and object.name == "ego") then
        slime:interact(object.clickedX, object.clickedY)
    end
    
    if object.name == "exit" then
        game:warp(hallway)
    end
    
    if object.name == "bulletin board" then
        slime:say("ego", "It is covered in notes")
    end
    
    if object.name == "game screen" then
        slime:turnActor("ego", "east")
        slime:say("ego", helper:pickone({
            "What a classic game",
            "That is one way to keep busy",
            "World championship pong tourney"
            }))
    end
    
    if object.name == "text screen" then
        slime:turnActor("ego", "east")
        slime:say("ego", "It's running Linux")
    end
    
    if object.name == "security screen" then
        slime:turnActor("ego", "east")
        slime:say("ego", "The cameras watch every room")
    end
    
    if object.name == "coffee" then
        slime:say("lazy guard", "Hands off!")
    end
    
    if object.name == "cup" then
        slime:say("ego", "No thanks.")
    end
    
    if object.name == "security pass" then
        if game.guardsKnockedOut then
            security:takeSecurityCard()
        else
            slime:say("ego", "I can't. The cameras are watching!")
        end
    end
    
    if event == "knockout gas" then
        if object.name == "busy guard" or object.name == "lazy guard" then
           security:popKnockoutGas() 
        end
    end
    
    
end


function security.onAnimationLooped (actor, key, counter)
    
    if actor == "gas" then
        slime:removeActor("gas")
    end
    
end


function security.onMoveTo (self, action, name)
    
    -- skip moving to these items
    local skip = {}
    skip["game screen"] = true
    skip["security screen"] = true
    skip["security pass"] = true
    skip["text screen"] = true
    skip["cup"] = true
    skip["A big mess"] = true
    skip.onlyOnInteractActions = action == "interact"
    return not skip[name]

end


function security.moveGuardInSecurityRoom ()
    
    if game.guardsKnockedOut then return end
    
    local chain = slime:chain()
    chain:move("busy guard", 90, 40)
    chain:turn("busy guard", "north")
    chain:wait(8)
    chain:move("busy guard", 107, 46)
    chain:turn("busy guard", "east")
    chain:wait(14)
    
    -- repeat
    if game.stage == security and not game.guardsKnockedOut then
        chain:func(security.moveGuardInSecurityRoom)
    end
    
end


function security.guardSaysRandomThing ()
    if game.stage == security and not game.guardsKnockedOut then
        local chain = slime:chain()
        if math.random(100) < 5 then
            local words = {
                "Did you submit to Ludum Dare?",
                "Looking good", 
                "Nothing to report", 
                "How about that game last night",
                "Simant is still a good game",
                "I sure love coffee",
                "Gosh this is exciting",
                "I wonder what this button does",
                "Best job in the world"
            }
            if game.scientistReceivedReport then
                words = {
                    "What a mess", 
                    "Where is that janitor", 
                    "I need another coffee", 
                    "Damnit", 
                    "Stupid opposing thumb"
                }
            end
            chain:say("lazy guard", helper:pickone(words))
        end
        chain:wait(3)
        chain:func(security.guardSaysRandomThing)
    end
    
end


function security.takeSecurityCard (self)
    local bagitem = {
        ["name"] = "security card",
        ["image"] = "images/security-pass-inventory.png"
        }
    local chain = slime:chain()
    chain:move("ego", 71, 41)
    chain:func(slime.removeActor, {slime, "security pass"})
    chain:func(slime.bagInsert, {slime, "ego", bagitem})
end


function security.popKnockoutGas (self)

    -- pop the gas!
    game.guardsKnockedOut = true
    cast.gas(100, 70)
    
    -- replace guards with sleeping clones
    slime:removeActor("busy guard")
    slime:removeActor("lazy guard")
    local guard = cast.guard(100, 46, "sleeping guard")
    costumes.guardUnconscious(guard)
    guard = cast.guard(115, 61, "sleeping guard")
    costumes.guardUnconscious(guard)
    
    slime:bagRemove("ego", "knockout gas")

end

return security