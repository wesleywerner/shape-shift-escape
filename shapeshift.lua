local shift = {}


function shift.toMonster (self)
    
    if game.egoshape == "monster" then return end
    
    local chain = slime:chain()
    chain:turn("ego", "west")
    
    if game.egoshape == "guard" then
        chain:anim("ego", "shift from guard", true)
    end
    
    if game.egoshape == "scientist" then
        chain:anim("ego", "shift from scientist", true)
    end
    
    chain:func(costumes.monster, {slime:getActor("ego")})
    chain:anim("ego", nil)
    game.egoshape = "monster"
    
end

function shift.toGuard (self)
    
    if game.egoshape == "guard" then return end
    
    local chain = slime:chain()
    chain:turn("ego", "west")
    
    if game.egoshape == "scientist" then
        chain:anim("ego", "shift from scientist", true)
    end
    
    chain:anim("ego", "shift to guard", true)

    chain:func(costumes.guard, {slime:getActor("ego")})
    chain:anim("ego", nil)
    game.egoshape = "guard"

end


function shift.toScientist (self)
    
    if game.egoshape == "scientist" then return end
    
    local chain = slime:chain()
    chain:turn("ego", "west")
    
    if game.egoshape == "guard" then
        chain:anim("ego", "shift from guard", true)
    end
    
    chain:anim("ego", "shift to scientist", true)

    chain:func(costumes.scientist, {slime:getActor("ego")})
    chain:anim("ego", nil)
    game.egoshape = "scientist"

end


return shift