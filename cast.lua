local cast = {}

function cast.ego (x, y)

    -- Add an actor named "ego"
    local ego = slime:actor("ego", x, y)
    
    -- The time between actor steps. More delay means slower steps.
    ego.movedelay = 0.05

    costumes.monster(ego)
    
end


function cast.guard (x, y, name)
    local actor = slime:actor(name, x, y)
    actor.movedelay = 0.05
    costumes.guard(actor)
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


return cast