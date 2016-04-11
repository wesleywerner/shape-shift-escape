slime = require("slime")
helper = require("helper")
cast = require("cast")
costumes = require("costumes")
intro = require("intro")
cell = require("cell")
hallway = require("hallway")
security = require("security")
lab = require("lab")
storage = require("storage")
exithallway = require("exit-hallway")
shapeshift = require("shapeshift")
win = require("end-win")
fail = require("end-fail")
game = {
    egoshape = "monster",
    scientistReceivedReport = false,
    guardsKnockedOut = false,
    takenKnockoutGas = false,
    firstStoreVisit = true,
    isbusy = false,
    bagY = 86
    }
inventoryTakeSound = nil
inventoryUseSound = nil

-- Cursors
POINT = 1
LOOK = 2
TALK = 3
TAKE = 4
BUSY = 5

function game.reset (self)
    slime.bags['ego'] = {}
    game.egoshape = 'monser'
    game.scientistReceivedReport = false
    game.guardsKnockedOut = false
    game.takenKnockoutGas = false
    game.firstStoreVisit = true
    game.isbusy = false
end

    
-- Loads the given game stage
function game.warp(self, stage)
    self.lastStage = self.stage
    self.stage = stage
    stage:setup()
end


function game.busy()
    game.isbusy = true
    slime:useCursor(BUSY)
end


function game.unbusy()
    game.isbusy = false
    slime:useCursor(POINT)
end


function love.load ()
    
    -- enable debugging
    --if arg[#arg] == "-debug" then require("mobdebug").start() end
    
    -- Random seed
    math.randomseed(os.time())
    
    -- Nearest image interpolation (pixel graphics, no anti-aliasing)
    love.graphics.setDefaultFilter("nearest", "nearest", 1)
    
    -- Slime settings
    slime.settings["speech font"] = love.graphics.newFont(8)
    slime.settings["speech position"] = 4
    slime.settings["status font"] = love.graphics.newFont(8)
    slime.settings["walk and talk"] = true
    slime.settings["builtin text"] = true
    
    inventoryTakeSound = love.audio.newSource("sounds/take.wav", "static")
    inventoryUseSound = love.audio.newSource("sounds/inventory-pick.wav", "static")
    gameMusic = love.audio.newSource("sounds/bu-a-lively-cheese.it", "static")
    gameMusic:setLooping(true)
    love.audio.play(gameMusic)
    
    -- Load cursors
    local cursorHotspots = { {x=4, y=4}, {x=4, y=3}, {x=2, y=6}, {x=3, y=3} }
    local cursorNames = {"interact", "look", "talk", "take", "busy" }
    slime:loadCursors("images/cursors.png", 12, 12, cursorNames, cursorHotspots)
    slime:useCursor(1)
    
    love.mouse.setVisible(false)
    
    -- Load the first stage
    game:warp(intro)
    
    -- testing
--    local bagitem = {
--        ["name"] = "security card",
--        ["image"] = "images/security-pass-inventory.png"
--        }
--    slime:bagInsert("ego", bagitem)
    
--    game.scientistReceivedReport = true
--    game.egoshape = "guard"
--    game.stage = hallway
    --game:warp(exithallway)
end


function love.draw ()
    love.graphics.push()
    love.graphics.scale(scale)
    slime:draw(scale)
    love.graphics.pop()
    slime:debugdraw()
end


function love.update (dt)
    
    helper:update(dt)
    
    slime:update(dt)
    
    -- reset cursor
    slime:useCursor(game.isbusy and BUSY or POINT)
    
    -- display hover over objects
    local x, y = love.mouse.getPosition()
    -- Adjust for scale
    x = math.floor(x / scale)
    y = math.floor(y / scale)
    local objects = slime:getObjects(x, y)
    if objects then
        local items = ''
        for _, hoverobject in pairs(objects) do
            if hoverobject.name ~= "ego" then
                items = string.format("%s %s", hoverobject.name, items)
                -- hover over cursor
                if hoverobject.cursor then
                    slime:useCursor(hoverobject.cursor)
                end
            end
        end
        slime:status(items)
    else
        slime:status()
    end
    
end


function love.keypressed (key, isrepeat)
    if key == "escape" then
        love.event.quit()
    elseif key == "tab" then
        slime.debug.enabled = not slime.debug.enabled
    end
end


-- Left clicking moves our Ego actor, and interacts with objects.
function love.mousepressed (x, y, button)

    if game.isbusy then
        slime:skipSpeech()
        return
    end
    
    -- Adjust for scale
    x = math.floor(x / scale)
    y = math.floor(y / scale)

    -- Left mouse button
    if button == "l" then
    
        -- The point is in our bag inventory area
        if (y > game.bagY) then
            local button = slime:getObjects(x, y)
            if button and button[1].image then
                local cursorSize = { button[1].image:getDimensions() }
                slime:setCursor(
                    button[1].name,
                    button[1].image, 
                    {x=cursorSize[1]/2, y=cursorSize[2]/2}
                    )
                love.audio.play(inventoryUseSound)
            end
        end
            
        if slime:someoneTalking() then
            slime:skipSpeech()
        else
            -- Check with the current stage if we should walk up
            -- to an object first, or interact without movement
            if game.stage.onMoveTo then
                local hasmoved = false
                local objects = slime:getObjects(x, y)
                local action = slime.cursorName or "interact"
                if objects then
                    for _, item in pairs(objects) do
                        if game.stage:onMoveTo(action, item.name) then
                            hasmoved = true
                            slime:moveActor("ego", x, y)    
                        end
                    end
                else
                    -- no objects found, allow move
                    slime:moveActor("ego", x, y)    
                end
                if not hasmoved then
                    slime:interact(x, y)
                end
            else
                -- Move Ego then interact with any objects
                slime:moveActor("ego", x, y)
            end
            
        end

    end
    
    -- Right clicks uses the default cursor
    if button == "r" then
        slime:setCursor()
    end
    
end


-- Position bag buttons
function slime.inventoryChanged (bag)
    slime.bagButtons = { }
    local xpos = 10
    for counter, item in pairs(slime:bagContents("ego")) do
        slime:bagButton(item.name, item.image, xpos, game.bagY)
        xpos = xpos + item.image:getWidth() + 4
    end
    love.audio.play(inventoryTakeSound)
end

