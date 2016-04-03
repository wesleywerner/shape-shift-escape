local costumes = {}

function costumes.monster (actor)
        
    -- Throw dust
    local tiles = actor:tileset("images/ego-throw.png", {w=22, h=12})
    
    tiles:define("throw dust")
        :frames({"1-12", 1})
        :delays(0.05)
        :sounds({[1] = "sounds/dust.wav"})
        :offset(-10, 0)
        :flip()

    -- create a new animation pack for ego using a tileset of 12x12 frames
    tiles = actor:tileset("images/ego.png", {w=12, h=12})
    
    -- Idle animation
    -- The idle animation plays when the actor is not walking or talking:
    -- a simple two-frame animation: Open eyes, and blink.
    
    local southFrames = {'11-10', 1}
    local southDelays = {3, 0.2}
    local westFrames = {'3-2', 1}
    local westDelays = {3, 0.2}
    local northFrames = {18, 1}
    local northDelays = 1
    
    tiles:define("idle south"):frames(southFrames):delays(southDelays)
    tiles:define("idle west"):frames(westFrames):delays(westDelays)
    tiles:define("idle north"):frames(northFrames):delays(northDelays)
    tiles:define("idle east"):frames(westFrames):delays(westDelays):flip()

    -- Walk animation
    southFrames = {'11-14', 1}
    southDelays = 0.2
    westFrames = {'6-3', 1}
    westDelays = 0.2
    northFrames = {'18-21', 1}
    northDelays = 0.2
    
    tiles:define("walk south"):frames(southFrames):delays(southDelays)
    tiles:define("walk west"):frames(westFrames):delays(westDelays)
    tiles:define("walk north"):frames(northFrames):delays(northDelays)
    tiles:define("walk east"):frames(westFrames):delays(westDelays):flip()

    -- Talk animation
    southFrames = {'15-17', 1}
    southDelays = 0.2
    westFrames = {'7-9', 1}
    westDelays = 0.2
    northFrames = {'15-17', 1}
    northDelays = 0.2

    tiles:define("talk south"):frames(southFrames):delays(southDelays)
    tiles:define("talk west"):frames(westFrames):delays(westDelays)
    tiles:define("talk north"):frames(northFrames):delays(northDelays)
    tiles:define("talk east"):frames(westFrames):delays(westDelays):flip()
    
    -- Dig with a spoon
    tiles:define("dig")
        :frames({"22-25", 1})
        :delays(0.2)
        :sounds({[1] = "sounds/dig.wav"})
        :flip()
    
--    -- Shape shift to a guard
--    tiles:define("shift to guard")
--        :frames({"26-37", 1})
--        :delays(0.2)
--        :sounds({[2] = "sounds/shapeshift.wav"})
    
end

function costumes.guard(actor)

    local tiles = actor:tileset("images/guard.png", {w=12, h=14})
    
    -- Idle animation
    -- The idle animation plays when the actor is not walking or talking:
    -- a simple two-frame animation: Open eyes, and blink.
    
    local southFrames = {'11-10', 1}
    local southDelays = {3, 0.2}
    local eastFrames = {'3-2', 1}
    local eastDelays = {3, 0.2}
    local northFrames = {18, 1}
    local northDelays = 1
    
    tiles:define("idle south"):frames(southFrames):delays(southDelays)
    tiles:define("idle west"):frames(eastFrames):delays(eastDelays):flip()
    tiles:define("idle north"):frames(northFrames):delays(northDelays)
    tiles:define("idle east"):frames(eastFrames):delays(eastDelays)

    -- Walk animation
    southFrames = {'11-14', 1}
    southDelays = 0.2
    eastFrames = {'6-3', 1}
    eastDelays = 0.2
    northFrames = {'18-21', 1}
    northDelays = 0.2
    
    tiles:define("walk south"):frames(southFrames):delays(southDelays)
    tiles:define("walk west"):frames(eastFrames):delays(eastDelays):flip()
    tiles:define("walk north"):frames(northFrames):delays(northDelays)
    tiles:define("walk east"):frames(eastFrames):delays(eastDelays)

    -- Talk animation
    southFrames = {'15-17', 1}
    southDelays = 0.2
    eastFrames = {'7-9', 1}
    eastDelays = 0.2
    northFrames = {'15-17', 1}
    northDelays = 0.2

    tiles:define("talk south"):frames(southFrames):delays(southDelays)
    tiles:define("talk west"):frames(eastFrames):delays(eastDelays):flip()
    tiles:define("talk north"):frames(northFrames):delays(northDelays)
    tiles:define("talk east"):frames(eastFrames):delays(eastDelays)
    
    -- Rub eyes
    eastFrames = {
        '22-26', 1,
        '25-26', 1,
        '25-26', 1,
        '25-26', 1,
        '24-22', 1,
        }
    eastDelays = 0.2
    tiles:define("rub eyes"):frames(eastFrames):delays(eastDelays)
    
end


function costumes.guardHandsUp (actor)

    local tiles = actor:tileset("images/guard.png", {w=12, h=14})
    
    local eastFrames = {'28-27', 1}
    local eastDelays = {3, 0.2}
    
    tiles:define("idle west"):frames(eastFrames):delays(eastDelays):flip()
    tiles:define("idle east"):frames(eastFrames):delays(eastDelays)

    -- Walk animation
    eastFrames = {'29-31', 1}
    eastDelays = 0.2
    tiles:define("walk west"):frames(eastFrames):delays(eastDelays):flip()
    tiles:define("walk east"):frames(eastFrames):delays(eastDelays)

    -- Talk animation
    eastFrames = {'32-34', 1}
    eastDelays = 0.2
    tiles:define("talk west"):frames(eastFrames):delays(eastDelays):flip()
    tiles:define("talk east"):frames(eastFrames):delays(eastDelays)
    
end


function costumes.guardUnconscious (actor)

    local tiles = actor:tileset("images/guard.png", {w=12, h=14})
    
    local eastFrames = {1, 1}
    local eastDelays = 10
    
    tiles:define("out"):frames(eastFrames):delays(eastDelays):flip()
    actor.customAnimationKey = "out"
    
end


function costumes.scientist (actor)

    local tiles = actor:tileset("images/scientist.png", {w=12, h=18})
    
    -- Idle animation
    -- The idle animation plays when the actor is not walking or talking:
    -- a simple two-frame animation: Open eyes, and blink.
    
    local southFrames = {'11-10', 1}
    local southDelays = {3, 0.2}
    local eastFrames = {'3-2', 1}
    local eastDelays = {3, 0.2}
    local northFrames = {18, 1}
    local northDelays = 1
    
    tiles:define("idle south"):frames(southFrames):delays(southDelays)
    tiles:define("idle west"):frames(eastFrames):delays(eastDelays):flip()
    tiles:define("idle north"):frames(northFrames):delays(northDelays)
    tiles:define("idle east"):frames(eastFrames):delays(eastDelays)

    -- Walk animation
    southFrames = {'11-14', 1}
    southDelays = 0.2
    eastFrames = {'6-3', 1}
    eastDelays = 0.2
    northFrames = {'18-21', 1}
    northDelays = 0.2
    
    tiles:define("walk south"):frames(southFrames):delays(southDelays)
    tiles:define("walk west"):frames(eastFrames):delays(eastDelays):flip()
    tiles:define("walk north"):frames(northFrames):delays(northDelays)
    tiles:define("walk east"):frames(eastFrames):delays(eastDelays)

    -- Talk animation
    southFrames = {'15-17', 1}
    southDelays = 0.2
    eastFrames = {'7-9', 1}
    eastDelays = 0.2
    northFrames = {'15-17', 1}
    northDelays = 0.2

    tiles:define("talk south"):frames(southFrames):delays(southDelays)
    tiles:define("talk west"):frames(eastFrames):delays(eastDelays):flip()
    tiles:define("talk north"):frames(northFrames):delays(northDelays)
    tiles:define("talk east"):frames(eastFrames):delays(eastDelays)
    
    -- Work Animation
    southFrames = {'22-34', 1, '33-23', 1}
    southDelays = 0.1 + math.random(10) / 100
    tiles:define("work"):frames(southFrames):delays(southDelays)
    
    -- Look Around
    southFrames = {35,1,  22,1,  36,1,  22,1}
    southDelays = 1
    tiles:define("look"):frames(southFrames):delays(southDelays)

end


-- Adds the shape shift outfits to the actor
function costumes.addShapeShiftOutifts (self, actor)
    
    tiles = actor:tileset("images/ego.png", {w=12, h=12})
    
    tiles:define("shift from guard")
        :frames({'37-26', 1})
        :delays(0.1)
        --:offset(0, 2)
        :sounds({[2] = "sounds/shapeshift.wav"})
    
    tiles:define("shift to guard")
        :frames({'26-37', 1})
        :delays(0.1)
        :sounds({[2] = "sounds/shapeshift.wav"})
    
    tiles = actor:tileset("images/scientist-shift.png", {w=12, h=18})
    
    tiles:define("shift from scientist")
        :frames({'17-1', 1})
        :delays(0.1)
        :sounds({[2] = "sounds/shapeshift.wav"})
    
    tiles:define("shift to scientist")
        :frames({'1-17', 1})
        :delays(0.1)
        --:offset(0, -6)
        :sounds({[2] = "sounds/shapeshift.wav"})

    
end



return costumes