-- Begin defining our game stage, a jail cell
local cell = {}

function cell.setup (self)
    
    -- Hook into the slime callbacks
    slime.callback = cell.onCallback
    slime.animationLooped = cell.onAnimationLooped
    
    -- Clear the stage
    slime:reset()

    -- Add the background
    slime:background("images/cell-background.png")
    
    -- Apply the walk-behind layer
    slime:layer("images/cell-background.png", "images/cell-layer.png", 50)
    
    -- Set the floor
    slime:floor("images/cell-floor-closed.png")
    
    -- Add our main actor
    cast.ego(70, 50)
    
    -- Add the cell door
    cast.door(50, 49, "door")
    
    -- Hole in the wall
    local x, y, width, height = 92, 23, 8, 8
    slime:hotspot("hole", x, y, width, height)

    -- Bowl and spoon
    local bowl = slime:actor("bowl and spoon")
    bowl.x = 65
    bowl.y = 37
    bowl:setImage("images/bowl1.png")
        
    slime:say("ego", "I must get out of here!")

    cell.pickUpDust()

end


function cell.openCellDoor ()
    
    local door = slime.actors["door"]
    door.open = true
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
    chain:func(cast.guard, {35, 45, "guard 1"})
    chain:func(cast.guard, {35, 45, "guard 2"})
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


function cell.onCallback (event, object)

    slime:log(event .. " on " .. object.name)

    if (event == "moved" and object.name == "ego") then
        slime:interact(object.clickedX, object.clickedY)
    end
    
    if event == "interact" then
        
        if object.name == "door" and not object.open then
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
        
        if object.name == "light" then
            slime:say("ego", "It is locked")
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


function cell.onAnimationLooped (actor, key, counter)
    
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
            costumes.guard(slime.actors["ego"])
            slime:setAnimation("ego", nil)
        end
    end
    
end


function cell.onMoveTo (self, action, name)
    
    -- skip moving to these items
    local skip = {}
    skip.light = true
    skip["guard 1"] = action == "cement dust"
    skip["guard 2"] = action == "cement dust"
    return not skip[name]

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
    chain:say("guard 1", "OH CRAP...")
    chain:turn("guard 2", "west")

    chain:say("guard 2", "IT'S HIM! HE'S THE MONSTER!")
    chain:say("ego", "NO, HE IS THE MONSTER!")
    chain:turn("guard 2", "east")
    chain:say("guard 2", "NO! I AM A GUARD!")
    chain:say("ego", "I AM A GUARD!")
    chain:say("guard 1", "ONE OF YOU IS THE MONSTER...")
    chain:say("guard 1", "LUCKILY WE HAVE DEVISED A QUESTION IF THIS EVER HAPPENED!")
    chain:turn("guard 2", "west")
    chain:say("guard 1", "YOU!...")    
    chain:say("ego", "ME?")
    chain:say("guard 1", "YES YOU... WHAT DOES 5, 7, 11 AND 13 HAVE IN COMMON?")
    chain:say("ego", "THEY ARE ALL... UM... NUMBERS?")
    chain:say("guard 1", "CORRECT! THAT MEANS THE OTHER ONE IS THE MONSTER!")
    chain:turn("guard 2", "south")
    chain:say("guard 2", "NO! I AM THE REAL GUARD!")
    chain:say("guard 1", "EXACTLY WHAT A MONSTER WOULD SAY!")

    -- walks up to other guard
    chain:move("guard 1", {x=50, y=45})
    chain:turn("guard 1", "east")
    chain:say("guard 1", "MOVE IT!")
    
    -- puts hands up
    chain:func(costumes.guardHandsUp, {slime.actors["guard 2"]})
    chain:move("guard 2", {x=85, y=46})
    chain:move("guard 1", {x=68, y=52})
    chain:turn("guard 2", "west")

    -- move ego around
    chain:move("ego", {x=47, y=44})
    chain:turn("ego", "east")
    
    chain:say("guard 2", "YOU'RE MAKING A MISTAKE!")
    chain:say("ego", "I DON'T THINK SO! LOCK THAT MONSTER AWAY, GUARD!")
    chain:say("guard 1", "MY PLEASURE!")
    chain:say("guard 1", "GO TELL THE SCIENTISTS OF THIS INCIDENT.")
    chain:say("ego", "RIGHT.")
    
    chain:func(game.unbusy)

end


function cell.exitToHallway()
    if not cell.exiting then
        cell.exiting = true
        local chain = slime:chain()
        game.busy()
        if game.egoshape == "guard" then
            chain:move("guard 1", {x=30, y=46})
            chain:func(cell.closeCellDoor)
            chain:wait(1)
            chain:say("guard 2", "CRAP.")
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