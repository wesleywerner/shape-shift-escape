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
    cell.addDoorActor(50, 49)
    
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
    
    slime:say("ego", "I must get out of here!")

    --cell.pickUpDust()

end

function cell.addEgoActor (x, y)

    -- Add an actor named "ego"
    local ego = slime:actor("ego", x, y)
    
    -- The time between actor steps. More delay means slower steps.
    ego.movedelay = 0.05

    cell.setEgoMonsterCostume()
    
end

function cell.setEgoMonsterCostume ()
    
    local ego = slime.actors["ego"]
    
    -- Throw dust
    local tiles = ego:tileset("images/ego-throw.png", {w=22, h=12})
    
    tiles:define("throw dust")
        :frames({"1-12", 1})
        :delays(0.1)
        :sounds({[1] = "sounds/dust.wav"})
        :offset(-10, 0)
        :flip()

    -- create a new animation pack for ego using a tileset of 12x12 frames
    tiles = ego:tileset("images/ego.png", {w=12, h=12})
    
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
    
    -- Shape shift to a guard
    tiles:define("shift to guard")
        :frames({"26-37", 1})
        :delays(0.2)
        :sounds({[1] = "sounds/shapeshift.wav"})
        :offset(0, 2)
    
end


function cell.addGuardActor (name)
    local actor = slime:actor(name, 35, 45)
    actor.movedelay = 0.05
    cell.setGuardCostume(actor)
end

function cell.setGuardCostume(actor)

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
    tiles:define("talk east"):frames(eastFrames):delays(eastDelaysu)
    
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


function cell.setGuardHandsUpCostume(actor)

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


function cell.addDoorActor (x, y)

    -- Add the door as an actor
    cell.door = slime:actor("door", x, y)

    -- Sprite frames
    local delay = 0.05
    -- A single frame that shows the door as open or closed
    local closedFrame = {1, 1}
    local openFrame = {31, 1}
    -- A series of frames that open or close the door
    local openingFrames = {"1-31", 1}
    local closingFrames = {"31-1", 1}
    local soundFrames = {[2] = "sounds/celldooropen.wav"}
    
    local tiles = cell.door:tileset("images/cell-door.png", {w=9, h=30})
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
    slime:setAnimation("door", "closed")
    
    -- Create a light above the door
    cell.light = slime:actor("light", 49, 19)
    cell.light.nozbuffer = true
    cell.light:setImage("images/cell-light-red.png")

end


function cell.openCellDoor ()
    
    cell.doorOpen = true
    game.busy()
    
    local chain = slime:chain()
    chain:image("light", "images/cell-light-green.png")
    chain:sound("sounds/unlock.wav")
    chain:move("ego", "light")
    chain:move("ego", {x=90, y=47})
    chain:turn("ego", "west")
    chain:wait(1)
    chain:anim("door", "opening")
    chain:floor("images/cell-floor-open.png")
    chain:func(cell.addGuardActor, {"guard 1"})
    chain:func(cell.addGuardActor, {"guard 2"})
    chain:move("guard 1", {x=53, y=44})
    chain:move("guard 1", {x=48, y=53})
    chain:turn("guard 1", "east")
    chain:move("guard 2", {x=53, y=44})
    chain:move("guard 2", {x=62, y=38})
    chain:turn("guard 2", "east")
    chain:say("guard 1", "MONSTER!")
    chain:say("guard 2", "TIME FOR THE TESTS, MONSTER!")
    chain:say("guard 1", "MOVE IT!")
    chain:func(cell.addExitHotspot)
    chain:func(game.unbusy)
    
end


function cell.addExitHotspot ()
    slime:hotspot("exit", 0, 24, 35, 27)
end


function cell.closeCellDoor ()
    local chain = slime:chain()
    chain:floor("images/cell-floor-closed.png")
    chain:anim("door", "closing", true)
    chain:image("light", "images/cell-light-red.png")
    chain:sound("sounds/unlock.wav")
    
--    slime:setAnimation("door", "closing")
--    slime:floor("images/cell-floor-closed.png")
--    cell.light:setImage("images/cell-light-red.png")
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
    slime:removeActor("falling dust")
    local chain = slime:chain()
    chain:say("ego", "This dust can blind eyeballs for a short time.")
    chain:func(cell.openCellDoor)
end


-- Creates an animation of falling dust where ego digs into the wall
function cell.addFallingDustActor ()
    local actor = slime:actor("falling dust", 96, 34)
    local tiles = actor:tileset("images/dust.png", {w=5, h=6})
    tiles:define("fall"):frames({'1-14', 1}):delays(0.2)
    tiles:define("still"):frames({14, 1}):delays(10)
    slime:setAnimation("falling dust", "fall")
end


function cell.callback (event, object)

    slime:log(event .. " on " .. object.name)

    if (event == "moved" and object.name == "ego") then
        slime:interact(object.clickedX, object.clickedY)
    end
    
    if event == "interact" then
        
        if object.name == "door" and not cell.doorOpen then
            slime:say("ego", "I am locked in this cell.")
        end
        
        -- give ego a bowl and a spoon inventory items
        if object.name == "bowl and spoon" then
            cell.pickUpSpoon()
        end
        
        -- Look at the hole in the wall
        if object.name == "hole" then
            slime:say("ego", "It looks like somebody tried digging here.")
        end
        
        if object.name == "falling dust" then
            cell.pickUpDust()
        end
        
        if object.name == "exit" then
            cell.exitToHallway()
        end
    
    end
    
    if event == "spoon" then
        if object.name == "door" then
            slime:say("ego", "The spoon won't open this door")
        end
        if object.name == "hole" then
            if not cell.dug then
                cell.dug = true
                game.busy()
                slime:turnActor("ego", "east")
                slime:setAnimation("ego", "dig")
                cell.addFallingDustActor()
                slime:setCursor()
            end
        end
    end
    
    if event == "cement dust" and (object.name == "guard 1" or object.name == "guard 2") then
        cell.throwDust()
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
    
    if actor == "falling dust" and key == "fall" then
        slime:setAnimation("falling dust", "still")
        slime:setAnimation("ego", nil)
        game.unbusy()
    end
    
    if actor == "ego" then
        if key == "throw dust" then
            slime:setAnimation("ego", nil)
        end
        if key == "shift to guard" then
            cell.setGuardCostume(slime.actors["ego"])
            slime:setAnimation("ego", nil)
        end
    end
    
end

function cell.throwDust ()
    
    game.egoshape = "guard"
    slime:setCursor()
    slime:bagRemove("ego", "cement dust")
    
    local chain = slime:chain()
    
    chain:func(game.busy)
    chain:move("ego", {x=60, y=53})
    chain:turn("ego", "west");
    
    -- throw dust
    chain:anim("ego", "throw dust", true)
    
    -- guard rubs eyes
    chain:anim("guard 1", "rub eyes")
    
    -- shape shift (ego's costume changes to a guard on animation loop)
    chain:anim("ego", "shift to guard", true)
    
    -- move ego next to top guard
    chain:move("guard 2", {x=56, y=45})
    chain:move("ego", {x=70, y=45})
    chain:turn("guard 2", "east")
    chain:turn("ego", "west")
    
    -- dusty guard opens his eyes
    chain:anim("guard 1", nil)
    
    -- begin dialogue
    chain:wait(1)
    chain:say("guard 2", "OH CRAP...")
    chain:turn("guard 2", "west")

    chain:say("guard 1", "IT'S HIM! HE'S THE MONSTER!")
    chain:say("ego", "NO, HE IS THE MONSTER!")
    chain:say("guard 1", "NO! I AM A GUARD!")
    chain:say("ego", "I AM A GUARD!")
    chain:say("guard 2", "ONE OF YOU IS THE MONSTER...")
    chain:say("guard 2", "LUCKILY WE HAVE DEVISED A QUESTION IF THIS EVER HAPPENED!")
    chain:turn("guard 2", "east")
    chain:say("guard 2", "YOU!...")    
    chain:say("ego", "ME?")
    chain:say("guard 2", "YES YOU... WHAT DOES 5, 7, 11 AND 13 HAVE IN COMMON?")
    chain:say("ego", "THEY ARE ALL... UM... NUMBERS?")
    chain:say("guard 2", "CORRECT! THAT MEANS THE OTHER ONE IS THE MONSTER!")
    chain:turn("guard 2", "west")
    chain:say("guard 1", "NO! I AM THE REAL GUARD!")
    chain:say("guard 2", "EXACTLY WHAT A MONSTER WOULD SAY!")

    -- walks up to other guard
    chain:move("guard 2", {x=50, y=45})
    chain:turn("guard 2", "east")
    chain:say("guard 2", "MOVE IT!")
    
    -- puts hands up
    chain:func(cell.setGuardHandsUpCostume, {slime.actors["guard 1"]})
    chain:move("guard 1", {x=85, y=46})
    chain:move("guard 2", {x=68, y=52})
    chain:turn("guard 1", "west")

    -- move ego around
    chain:move("ego", {x=47, y=44})
    chain:turn("ego", "east")
    
    chain:say("guard 1", "YOU'RE MAKING A MISTAKE!")
    chain:say("ego", "I DON'T THINK SO! LOCK THAT MONSTER AWAY, GUARD!")
    chain:say("guard 2", "MY PLEASURE!")
    chain:say("guard 2", "GO TELL THE SCIENTISTS OF THIS INCIDENT.")
    chain:say("ego", "RIGHT.")
    
    chain:func(game.unbusy)

end


function cell.exitToHallway()
    if not cell.exiting then
        cell.exiting = true
        local chain = slime:chain()
        game.busy()
        if game.egoshape == "guard" then
            chain:move("guard 2", {x=10, y=45})
            chain:func(cell.closeCellDoor)
            chain:wait(1)
            chain:say("guard 1", "CRAP.")
            chain:wait(3)
            --chain:func(game.warp, {game, hallway})
        else
            chain:move("guard 2", {x=30, y=46})
            chain:move("guard 1", {x=30, y=46})
            chain:func(cell.closeCellDoor)
            chain:wait(0.5)
            --chain:func(game.warp, {game, fail})
        end
    end
end



return cell