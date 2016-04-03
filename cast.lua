local cast = {}

function cast.ego (x, y)

    -- Add an actor named "ego"
    local ego = slime:actor("ego", x, y)
    
    -- The time between actor steps. More delay means slower steps.
    ego.movedelay = 0.05
    
    ego.speechcolor = {64, 255, 64}

    if game.egoshape == "guard" then
        costumes.guard(ego)
    elseif game.egoshape == "scientist" then
        costumes.scientist(ego)
    else
        costumes.monster(ego)
    end
    
end


function cast.guard (x, y, name)
    local actor = slime:actor(name, x, y)
    actor.movedelay = 0.05
    actor.speechcolor = {64, 64, 255}
    costumes.guard(actor)
    return actor
end


function cast.scientist (x, y, name)
    local actor = slime:actor(name, x, y)
    actor.movedelay = 0.05
    costumes.scientist(actor)
    return actor
end



function cast.door (x, y, name)

    local door = slime:actor(name, x, y)

    -- Sprite frames
    local delay = 0.05
    -- A single frame that shows the door as open or closed
    local closedFrame = {1, 1}
    local openFrame = {31, 1}
    -- A series of frames that open or close the door
    local openingFrames = {"1-31", 1}
    local closingFrames = {"31-1", 1}
    local soundFrames = {[2] = "sounds/celldooropen.wav"}
    
    local tiles = door:tileset("images/cell-door.png", {w=9, h=30})
    tiles
        :define("closing")
        :frames(closingFrames)
        :delays(delay)
        :sounds(soundFrames)
    tiles
        :define("closed")
        :frames(closedFrame)
        :delays(10)
    tiles
        :define("opening")
        :frames(openingFrames)
        :delays(delay)
        :sounds(soundFrames)
    tiles
        :define("open")
        :frames(closingFrames)
        :delays(10)

    -- Start off closed
    door.open = false
    slime:setAnimation("door", "closed")
    
    -- Create a light above the door
    local light = slime:actor("light", x-1, y-30)
    light.nozbuffer = true
    light:setImage("images/cell-light-red.png")

end


function cast.securitymonitor (x, y, display)
        
    if display == "pong" then
        local actor = slime:actor("game screen", x, y)
        local tiles = actor:tileset("images/securitymonitor.png", {w=10, h=17})
        tiles
            :define("display")
            :frames({'7-11', 1, '10-8', 1})
            :delays(0.3)
        actor.base = {0, 0}
        slime:setAnimation("game screen", "display")
    end
    
    if display == "rooms" then
        local actor = slime:actor("security screen", x, y)
        local tiles = actor:tileset("images/securitymonitor.png", {w=10, h=17})
        tiles
            :define("display")
            :frames({'1-3', 1})
            :delays(2.7)
        actor.base = {0, 0}
        slime:setAnimation("security screen", "display")
    end

    if display == "text" then
        local actor = slime:actor("text screen", x, y)
        local tiles = actor:tileset("images/securitymonitor.png", {w=10, h=17})
        tiles
            :define("display")
            :frames({'4-6', 1})
            :delays(0.5)
        actor.base = {0, 0}
        slime:setAnimation("text screen", "display")
    end

end


function cast.securitypass (x, y)
    local actor = slime:actor("security pass", x, y)
    actor:setImage("images/security-pass.png")
end


function cast.coffee (x, y)
    local actor = slime:actor("coffee", x, y)
    local tileset = actor:tileset("images/coffee.png", {w=6, h=10})
    tileset:define("steam"):frames({'1-2', 1}):delays(0.8)
    actor.customAnimationKey = "steam"
end


function cast.spiltcoffee (x, y)
    local actor = slime:actor("cup", x, y)
    local tileset = actor:tileset("images/coffee.png", {w=6, h=10})
    tileset:define("steam"):frames({3, 1}):delays(10)
    actor.customAnimationKey = "steam"
    
    actor = slime:actor("A big mess", x, y)
    tileset = actor:tileset("images/coffee-spill.png", {w=7, h=19})
    tileset:define("drip"):frames({'1-8', 1}):delays(0.2)
    actor.base = {0, 4}
    actor.customAnimationKey = "drip"
end


function cast.gas (x, y)
    local actor = slime:actor("gas", x, y)
    local tileset = actor:tileset("images/knockout-gas.png", {w=40, h=40})
    tileset:define("explode")
        :frames({'1-12', 1})
        :delays(0.1)
        :sounds({[2] = "sounds/knockout-gas.wav"})
    actor.customAnimationKey = "explode"
end


return cast