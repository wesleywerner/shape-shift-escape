-- Begin defining our game stage, a jail cell
local cell = {}

function cell.setup (self)

    -- Clear the stage
    slime:reset()

    -- Add the background
    slime:background("images/cell-background.png")
    
    -- Apply the walk-behind layer
    slime:layer("images/cell-background.png", "images/cell-layer.png", 50)
    
    -- Set the floor
    slime:floor("images/cell-floor-closed.png")
    
    -- Add our main actor
    cell.addEgoActor(70, 50)
    
    -- Add the cell door
    cell.addCellDoor(50, 49)
    
    -- Hole in the wall
    local x, y, width, height = 92, 23, 8, 8
    slime:hotspot("hole", x, y, width, height)

    -- Bowl and spoon
    local bowl = slime:actor("bowl and spoon")
    bowl.x = 65
    bowl.y = 37
    bowl:setImage("images/bowl1.png")
    
    -- Hook into the slime callbacks
    slime.callback = cell.callback
    slime.animationLooped = cell.animationLooped
    
    local chain = slime:chain()
    chain:wait(1)
    chain:talk("ego", "I must get out of here!")

--    cell.openCellDoor ()
end

function cell.addEgoActor (x, y)

    -- Add an actor named "ego"
    local ego = slime:actor("ego", x, y)
    
    -- The time between actor steps. More delay means slower steps.
    ego.movedelay = 0.05

    -- create a new animation pack for ego using a tileset of 12x12 frames
    local egoAnim = ego:tileset("images/ego.png", {w=12, h=12})
    
    -- Idle animation
    -- The idle animation plays when the actor is not walking or talking:
    -- a simple two-frame animation: Open eyes, and blink.
    
    local southFrames = {'11-10', 1}
    local southDelays = {3, 0.2}
    local westFrames = {'3-2', 1}
    local westDelays = {3, 0.2}
    local northFrames = {18, 1}
    local northDelays = 1
        
    egoAnim:define("idle south", southFrames, southDelays)
    egoAnim:define("idle west", westFrames, westDelays)
    egoAnim:define("idle north", northFrames, northDelays)
    egoAnim:define("idle east", westFrames, westDelays):flip()

    -- Walk animation
    southFrames = {'11-14', 1}
    southDelays = 0.2
    westFrames = {'6-3', 1}
    westDelays = 0.2
    northFrames = {'18-21', 1}
    northDelays = 0.2
    
    egoAnim:define("walk south", southFrames, southDelays)
    egoAnim:define("walk west", westFrames, westDelays)
    egoAnim:define("walk north", northFrames, northDelays)
    egoAnim:define("walk east", westFrames, westDelays):flip()

    -- Talk animation
    southFrames = {'15-17', 1}
    southDelays = 0.2
    westFrames = {'7-9', 1}
    westDelays = 0.2
    northFrames = {'15-17', 1}
    northDelays = 0.2

    egoAnim:define("talk south", southFrames, southDelays)
    egoAnim:define("talk west", westFrames, westDelays)
    egoAnim:define("talk north", northFrames, northDelays)
    egoAnim:define("talk east", westFrames, westDelays):flip()
    
    -- Ego animation using the spoon to dig
    egoAnim:define("dig", {"22-25", 1}, 0.2):flip()

end


function cell.addGuard (name)
    local actor = slime:actor(name, 35, 45)
    actor.movedelay = 0.05
    local anim = actor:tileset("images/guard.png", {w=12, h=12})
    -- Idle animation
    -- The idle animation plays when the actor is not walking or talking:
    -- a simple two-frame animation: Open eyes, and blink.
    
    local southFrames = {'11-10', 1}
    local southDelays = {3, 0.2}
    local eastFrames = {'3-2', 1}
    local eastDelays = {3, 0.2}
    local northFrames = {18, 1}
    local northDelays = 1
    
    anim:define("idle south", southFrames, southDelays)
    anim:define("idle west", eastFrames, eastDelays):flip()
    anim:define("idle north", northFrames, northDelays)
    anim:define("idle east", eastFrames, eastDelays)

    -- Walk animation
    southFrames = {'11-14', 1}
    southDelays = 0.2
    eastFrames = {'6-3', 1}
    eastDelays = 0.2
    northFrames = {'18-21', 1}
    northDelays = 0.2
    
    anim:define("walk south", southFrames, southDelays)
    anim:define("walk west", eastFrames, eastDelays):flip()
    anim:define("walk north", northFrames, northDelays)
    anim:define("walk east", eastFrames, eastDelays)

    -- Talk animation
    southFrames = {'15-17', 1}
    southDelays = 0.2
    eastFrames = {'7-9', 1}
    eastDelays = 0.2
    northFrames = {'15-17', 1}
    northDelays = 0.2

    anim:define("talk south", southFrames, southDelays)
    anim:define("talk west", eastFrames, eastDelays):flip()
    anim:define("talk north", northFrames, northDelays)
    anim:define("talk east", eastFrames, eastDelays)
end


function cell.addCellDoor (x, y)

    -- Add the door as an actor
    cell.door = slime:actor("door", x, y)

    -- Sprite frames
    local frameWidth, frameHeight = 9, 30
    local animationDelay = 0.05
    -- A single frame that shows the door as open or closed
    local closedFrame = {1, 1}
    local openFrame = {31, 1}
    -- A series of frames that open or close the door
    local openingFrames = {"1-31", 1}
    local closingFrames = {"31-1", 1}
    
    local doorAnim = cell.door:tileset("images/cell-door.png", {w=9, h=30})
    doorAnim:define("closing", closingFrames, animationDelay)
    doorAnim:define("closed", closedFrame)
    doorAnim:define("opening", openingFrames, animationDelay)
    doorAnim:define("open", openFrame)
    
    -- Start off closed
    slime:setAnimation("door", "closed")
    
    -- Create a light above the door
    cell.light = slime:actor("light", 49, 19)
    cell.light.nozbuffer = true
    cell.light:setImage("images/cell-light-red.png")

end


function cell.openCellDoor ()
    
    cell.doorOpen = true
    
    local chain = slime:chain()
    chain:image("light", "images/cell-light-green.png")
    chain:move("ego", "light")
    chain:move("ego", {x=90, y=47})
    chain:turn("ego", "west")
    chain:wait(1)
    chain:anim("door", "opening")
    chain:floor("images/cell-floor-open.png")
    chain:func(cell.addGuard, {"guard 1"})
    chain:func(cell.addGuard, {"guard 2"})
    chain:move("guard 1", {x=53, y=44})
    chain:move("guard 1", {x=48, y=53})
    chain:turn("guard 1", "east")
    chain:move("guard 2", {x=53, y=44})
    chain:move("guard 2", {x=62, y=38})
    chain:turn("guard 2", "east")
    chain:talk("guard 1", "MONSTER!")
    chain:talk("guard 2", "TIME FOR THE TESTS, MONSTER!")
    chain:talk("guard 1", "MOVE IT!")
    
    slime:hotspot("exit", 0, 24, 55, 27)
     
--        addScreenRegion (cellExit, 0, 32, 45, 50, 0, 0, WEST);
end


function cell.closeCellDoor ()
    slime:setAnimation("door", "closing")
    slime:floor("images/cell-floor-closed.png")
    cell.light:setImage("images/cell-light-red.png")
end


-- Picks up the spoon and place them in inventory
function cell.pickUpSpoon ()
    -- Face Ego to the player
    slime:turnActor("ego", "south")
    -- Add items to Ego's bag
    slime:bagInsert("ego", { ["name"] = "bowl", ["image"] = "images/bowl2.png" })
    slime:bagInsert("ego", { ["name"] = "spoon", ["image"] = "images/spoon.png" })
    -- Remove the bowl and spoon actor from the stage
    slime.actors["bowl and spoon"] = nil    
end


-- Picks up the cement dust
function cell.pickUpDust ()
    slime:bagInsert("ego", 
        { ["name"] = "cement dust", ["image"] = "images/inv-dust.png" })
    slime.actors["dust"] = nil
    local chain = slime:chain()
    chain:talk("ego", "This dust can blind eyeballs for a short time.")
    chain:func(cell.openCellDoor)
end


-- Creates an animation of falling dust where ego digs into the wall
function cell.addDustAnimation ()
    local dustActor = slime:actor("dust", 96, 34)
    local dustAnim = dustActor:tileset("images/dust.png", {w=5, h=6})
    dustAnim:define("fall", {'1-14', 1}, 0.2)
    dustAnim:define("still", {14, 1})
    slime:setAnimation("dust", "fall")
end


function cell.callback (event, object)

    slime:log(event .. " on " .. object.name)

    if (event == "moved" and object.name == "ego") then
        slime:interact(object.clickedX, object.clickedY)
    end
    
    if event == "interact" then
        
        if object.name == "door" and not cell.doorOpen then
            slime:addSpeech("ego", "I am locked in this cell.")
        end
        
        -- give ego a bowl and a spoon inventory items
        if object.name == "bowl and spoon" then
            cell.pickUpSpoon()
        end
        
        -- Look at the hole in the wall
        if object.name == "hole" then
            slime:addSpeech("ego", "I see a hole in the wall")
        end
        
        -- Set the cursor when interacting on bag items
        if object.name == "spoon" then
            slime:setCursor(object.name, object.image, scale, 0, 0)
        end
        
        if object.name == "dust" then
            cell.pickUpDust()
        end
        
        if object.name == "exit" then
            slime:moveActor("ego", 10, 45)
        end
    
    end
    
    if event == "spoon" then
        if object.name == "door" then
            slime:addSpeech("ego", "The spoon won't open this door")
        end
        if object.name == "hole" then
            slime:turnActor("ego", "east")
            slime:setAnimation("ego", "dig")
            cell.addDustAnimation()
            slime:setCursor()
        end
    end
    
end


function cell.animationLooped (actor, key, counter)
    
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
    
    if actor == "dust" then
        slime:setAnimation("dust", "still")
        slime:setAnimation("ego", nil)
    end
    
end

return cell